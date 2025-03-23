// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:torfin/core/utils/app_constant.dart';
import 'package:torfin/src/data/source/local/app_storage.dart';

import '../../../../../core/helper/base_cubit.dart';
import '../../../../../core/helper/base_usecase.dart';
import '../../../../data/model/response/torrent/torrent_res.dart';
import '../../../../domain/usecase/get_favorite_use_case.dart';
import '../../../../domain/usecase/remove_torrent_use_case.dart';
import '../../../../domain/usecase/save_torrent_use_case.dart';

part 'home_cubit.freezed.dart';
part 'home_state.dart';

class HomeCubit extends BaseCubit<HomeState> {
  final AppStorage appStorage;
  final GetFavoriteUseCase getFavoriteUseCase;
  final SaveTorrentUseCase saveTorrentUseCase;
  final RemoveTorrentUseCase removeTorrentUseCase;
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  HomeCubit({
    required this.appStorage,
    required this.getFavoriteUseCase,
    required this.saveTorrentUseCase,
    required this.removeTorrentUseCase,
  }) : super(const HomeState());

  void onNavigationTap(int index) {
    emit(state.copyWith(index: index, status: HomeStateEnum.indexChanged));
  }

  Future<void> initialize() async {
    try {
      // Check if storage permission is already granted
      if (await _isStoragePermissionGranted()) {
        await _createFolderAndSavePath();
        return;
      }

      // Request storage permission
      if (await _requestStoragePermission()) {
        await _createFolderAndSavePath();
      } else {
        // If permission is denied, clear the path
        await appStorage.setCommon(AppConstant.storage, "");
        emit(state.copyWith(status: HomeStateEnum.permissionDenied));
      }
    } catch (e) {
      // Handle errors
      await appStorage.setCommon(AppConstant.storage, "");
      emit(state.copyWith(status: HomeStateEnum.permissionDenied));
    }
  }

  // Check if storage permission is granted
  Future<bool> _isStoragePermissionGranted() async {
    final AndroidDeviceInfo androidInfo = await _deviceInfo.androidInfo;
    final int sdkInt = androidInfo.version.sdkInt;

    if (sdkInt <= 29) {
      // Android 10 and below: Check WRITE_EXTERNAL_STORAGE
      return await Permission.storage.isGranted;
    } else {
      return await Permission.manageExternalStorage.isGranted;
    }
  }

  // Request storage permission
  Future<bool> _requestStoragePermission() async {
    final AndroidDeviceInfo androidInfo = await _deviceInfo.androidInfo;
    final int sdkInt = androidInfo.version.sdkInt;

    if (sdkInt <= 29) {
      // Android 10 and below: Request WRITE_EXTERNAL_STORAGE
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        status = await Permission.storage.request();
      }
      return status.isGranted;
    } else {
      var status = await Permission.manageExternalStorage.status;
      if (!status.isGranted) {
        status = await Permission.manageExternalStorage.request();
      }
      return status.isGranted;
    }
  }

  // Create a folder named "Torfin" and save its path
  Future<void> _createFolderAndSavePath() async {
    try {
      // Get the external storage directory
      Directory externalStorageDirectory = Directory("/storage/emulated/0");

      // Create the folder path
      String folderPath =
          '${externalStorageDirectory.path}/${AppConstant.torfin}';

      // Create the folder
      Directory folder = Directory(folderPath);
      if (!await folder.exists()) {
        await folder.create(recursive: true);
      }

      // Save the folder path
      await appStorage.setCommon(AppConstant.storage, folderPath);

      // Emit success state
      emit(state.copyWith(status: HomeStateEnum.permissionGranted));
    } catch (e) {
      // Handle errors
      await appStorage.setCommon(AppConstant.storage, "");
      emit(state.copyWith(status: HomeStateEnum.permissionDenied));
    }
  }

  Future<void> getAllFavorites() async {
    try {
      final response = await getFavoriteUseCase.call(NoParams());
      if (isSuccess(response)) {
        emit(
          state.copyWith(
            status: HomeStateEnum.ready,
            favorites: response.data ?? [],
          ),
        );
      } else {
        emit(state.copyWith(favorites: []));
      }
    } catch (e) {
      emit(state.copyWith(favorites: []));
    }
  }

  Future<void> saveTorrent({required TorrentRes torrent}) async {
    try {
      await saveTorrentUseCase.call(torrent);
      await getAllFavorites();
      emit(state.copyWith(status: HomeStateEnum.save));
    } catch (e) {
      emit(state.copyWith(status: HomeStateEnum.failure));
    }
  }

  Future<void> removeTorrent({required TorrentRes torrent}) async {
    try {
      await removeTorrentUseCase.call(torrent);
      await getAllFavorites();
      emit(state.copyWith(status: HomeStateEnum.remove));
    } catch (e) {
      emit(state.copyWith(status: HomeStateEnum.failure));
    }
  }

  @override
  Future<void> closeToken() async {}
}
