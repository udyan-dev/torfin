import 'dart:convert';
import 'dart:io';

import 'package:content_resolver/content_resolver.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/bindings/di.dart';
import '../../../core/helpers/base_exception.dart';
import '../../../core/helpers/data_state.dart';
import '../../../core/theme/app_styles.dart';
import '../../../core/utils/app_assets.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/utils/string_constants.dart';
import '../../data/engine/engine.dart';
import '../../domain/usecases/add_torrent_use_case.dart';
import '../home/cubit/home_cubit.dart';
import '../shared/notification_builders.dart';
import 'button_widget.dart';
import 'dialog_widget.dart';
import 'icon_widget.dart';
import 'notification_widget.dart';

void showAddTorrentDialog(BuildContext context, {String? initialUri}) {
  showAppDialog(
    context: context,
    builder: (dialogContext) => _AddTorrentDialog(initialUri: initialUri),
  );
}

class DownloadButtonWidget extends StatelessWidget {
  const DownloadButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) => state.status == DataStatus.success
          ? FloatingActionButton(
              backgroundColor: context.colors.buttonPrimary,
              shape: LinearBorder.none,
              child: SvgPicture.asset(
                AppAssets.icAddLarge,
                width: 20,
                height: 20,
                colorFilter: context.colors.iconOnColor.colorFilter,
              ),
              onPressed: () => showAddTorrentDialog(context),
            )
          : emptyBox,
    );
  }
}

class _AddTorrentDialog extends StatefulWidget {
  final String? initialUri;

  const _AddTorrentDialog({this.initialUri});

  @override
  State<_AddTorrentDialog> createState() => _AddTorrentDialogState();
}

class _AddTorrentDialogState extends State<_AddTorrentDialog> {
  late final AddTorrentUseCase _addTorrentUseCase;
  late final TextEditingController _controller;
  final ImagePicker _picker = ImagePicker();
  String? _filePath;
  String? _fileName;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _addTorrentUseCase = di<AddTorrentUseCase>();
    _controller = TextEditingController();
    if (widget.initialUri != null) {
      _handleInitialUri(widget.initialUri!);
    }
  }

  Future<void> _handleInitialUri(String uri) async {
    if (uri.startsWith('magnet:') || uri.startsWith('http')) {
      _controller.text = uri;
    } else if (uri.startsWith('content://') || uri.startsWith('file://')) {
      try {
        String? fileName;
        if (uri.startsWith('content://')) {
          final metadata = await ContentResolver.resolveContentMetadata(uri);
          fileName = metadata.fileName;
        } else {
          fileName = uri.split('/').last;
        }
        if (mounted && fileName != null) {
          setState(() {
            _filePath = uri;
            _fileName = fileName;
          });
        }
      } catch (_) {}
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _hasText => _controller.text.trim().isNotEmpty;

  bool get _hasFile => _filePath != null;

  bool get _canSubmit => (_hasText || _hasFile) && !_isLoading;

  Future<void> _pickFile() async {
    try {
      final result = await _picker.pickMedia();
      if (result == null) return;
      final file = result;
      setState(() {
        _filePath = file.path;
        _fileName = file.name;
        _controller.clear();
      });
    } catch (e) {
      if (mounted) {
        NotificationWidget.notify(
          context,
          errorNotification(failedToReadTorrentFile, e.toString()),
        );
      }
    }
  }

  void _clearFile() => setState(() {
    _filePath = null;
    _fileName = null;
  });

  Future<String?> _readFile(String path) async {
    try {
      List<int> bytes;
      if (path.startsWith('content://')) {
        bytes = (await ContentResolver.resolveContent(path)).data;
      } else {
        bytes = await File(path).readAsBytes();
      }
      if (bytes.isEmpty) return null;
      return base64Encode(bytes);
    } catch (e) {
      if (mounted) {
        _notify(
          AppNotification(
            type: NotificationType.error,
            message: '$failedToReadTorrentFile: ${e.toString()}',
          ),
        );
      }
      return null;
    }
  }

  bool _isValidLink(String input) {
    if (input.isEmpty) return false;
    final trimmed = input.trim();
    if (trimmed.isEmpty) return false;
    return trimmed.startsWith('magnet:?xt=urn:btih:') ||
        trimmed.startsWith('http://') ||
        trimmed.startsWith('https://');
  }

  Future<void> _download() async {
    if (!_canSubmit) return;
    setState(() => _isLoading = true);
    try {
      final result = _hasFile ? await _downloadFile() : await _downloadLink();
      if (result != null) _handleResult(result);
    } catch (e) {
      if (mounted) {
        _notify(
          AppNotification(
            type: NotificationType.error,
            message: '$failedToAddTorrent: ${e.toString()}',
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<DataState<TorrentAddedResponse>?> _downloadFile() async {
    try {
      if (_filePath == null || _filePath!.isEmpty) {
        if (mounted) Navigator.of(context).pop();
        _notify(
          const AppNotification(
            type: NotificationType.error,
            message: failedToReadTorrentFile,
          ),
        );
        return null;
      }
      final metainfo = await _readFile(_filePath!);
      if (metainfo == null || metainfo.isEmpty) return null;
      return await _addTorrentUseCase.call(
        const AddTorrentUseCaseParams(magnetLink: emptyString),
        cancelToken: CancelToken(),
        metainfo: metainfo,
      );
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop();
        _notify(
          AppNotification(
            type: NotificationType.error,
            message: '$failedToAddTorrent: ${e.toString()}',
          ),
        );
      }
      return null;
    }
  }

  Future<DataState<TorrentAddedResponse>?> _downloadLink() async {
    try {
      final link = _controller.text.trim();
      if (link.isEmpty) {
        if (mounted) Navigator.of(context).pop();
        _notify(
          const AppNotification(
            type: NotificationType.error,
            message: pleaseEnterMagnetOrSelectFile,
          ),
        );
        return null;
      }
      if (!_isValidLink(link)) {
        if (mounted) Navigator.of(context).pop();
        _notify(
          const AppNotification(
            type: NotificationType.error,
            message: invalidTorrent,
          ),
        );
        return null;
      }
      return await _addTorrentUseCase.call(
        AddTorrentUseCaseParams(magnetLink: link),
        cancelToken: CancelToken(),
      );
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop();
        _notify(
          AppNotification(
            type: NotificationType.error,
            message: '$failedToAddTorrent: ${e.toString()}',
          ),
        );
      }
      return null;
    }
  }

  void _handleResult(DataState<TorrentAddedResponse> result) {
    try {
      result.when(
        success: (response) {
          if (mounted) Navigator.of(context).pop();
          _notify(
            AppNotification(
              title: response == TorrentAddedResponse.duplicated
                  ? torrentAlreadyAdded
                  : torrentAdded,
              type: response == TorrentAddedResponse.duplicated
                  ? NotificationType.warning
                  : NotificationType.downloadStarted,
              message: response == TorrentAddedResponse.duplicated
                  ? torrentAlreadyExists
                  : downloadStartedSuccessfully,
            ),
          );
        },
        failure: (error) {
          if (mounted) Navigator.of(context).pop();
          _notify(
            error.type == BaseExceptionType.insufficientCoins
                ? insufficientCoinsNotification()
                : AppNotification(
                    type: NotificationType.error,
                    message: error.message,
                  ),
          );
        },
      );
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop();
        _notify(
          AppNotification(
            type: NotificationType.error,
            message: '$failedToAddTorrent: ${e.toString()}',
          ),
        );
      }
    }
  }

  void _notify(AppNotification notification) {
    if (mounted) NotificationWidget.notify(context, notification);
  }

  @override
  Widget build(BuildContext context) {
    return DialogWidget(
      title: addTorrent,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
            child: SizedBox(
              height: kMinInteractiveDimension,
              child: ValueListenableBuilder<TextEditingValue>(
                valueListenable: _controller,
                builder: (context, value, child) => SearchBar(
                  controller: _controller,
                  hintText: magnetOrHttpsHint,
                  keyboardType: TextInputType.url,
                  hintStyle: WidgetStatePropertyAll(
                    TextStyle(
                      fontFamily: ibmPlexSans,
                      fontSize: 16,
                      height: 22 / 16,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0,
                      color: context.colors.textPlaceholder,
                    ),
                  ),
                  enabled: !_hasFile && !_isLoading,
                  trailing: value.text.trim().isNotEmpty && !_isLoading
                      ? [
                          IconWidget(
                            onTap: _controller.clear,
                            icon: AppAssets.icClose,
                          ),
                        ]
                      : null,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(child: Divider(color: context.colors.borderSubtle00)),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: AppText.bodyCompact01(or),
                ),
                Expanded(child: Divider(color: context.colors.borderSubtle00)),
              ],
            ),
          ),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: _controller,
            builder: (_, value, _) => Padding(
              padding: EdgeInsets.only(
                left: 16.0,
                bottom: 16.0,
                top: 8.0,
                right: _hasFile && !_isLoading ? 8.0 : 16.0,
              ),
              child: Row(
                spacing: 8,
                children: [
                  Expanded(
                    child: ButtonWidget(
                      backgroundColor: context.colors.buttonSecondary,
                      buttonText: _fileName ?? selectTorrentFile,
                      onTap: value.text.trim().isEmpty && !_isLoading
                          ? _pickFile
                          : null,
                    ),
                  ),
                  if (_hasFile && !_isLoading) ...[
                    IconWidget(onTap: _clearFile, icon: AppAssets.icClose),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
      actions: ValueListenableBuilder<TextEditingValue>(
        valueListenable: _controller,
        builder: (context, value, child) => Row(
          children: [
            Expanded(
              child: ButtonWidget(
                backgroundColor: context.colors.buttonSecondary,
                buttonText: cancel,
                onTap: _isLoading ? null : () => Navigator.of(context).pop(),
              ),
            ),
            Expanded(
              child: ButtonWidget(
                backgroundColor: context.colors.buttonPrimary,
                buttonText: download,
                onTap: (value.text.trim().isNotEmpty || _hasFile) && !_isLoading
                    ? _download
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
