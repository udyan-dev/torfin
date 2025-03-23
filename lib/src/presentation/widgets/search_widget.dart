import 'package:flutter/material.dart';
import 'package:torfin/core/theme/app_text.dart';
import 'package:torfin/core/utils/app_extension.dart';

import '../../../core/theme/app_style.dart';
import '../../../gen/assets.gen.dart';
import 'icon_widget.dart';

class SearchWidget extends StatefulWidget {
  final Function(String) onSearch;
  final bool showSuggestions;
  final Future<List<String>> Function(String)? fetchSuggestions;

  const SearchWidget({
    super.key,
    required this.onSearch,
    this.showSuggestions = false,
    this.fetchSuggestions,
  });

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  late final FocusNode _focusNode;
  late final TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _textEditingController = TextEditingController();
  }

  Future<List<String>> _fetchSuggestions(String query) async {
    if (!widget.showSuggestions ||
        widget.fetchSuggestions == null ||
        query.isEmpty) {
      return [];
    }
    final suggestions = await widget.fetchSuggestions!(query);
    return suggestions;
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  Widget _buildField(
    BuildContext context,
    TextEditingController controller,
    FocusNode focusNode,
    VoidCallback onSubmitted,
  ) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      textAlignVertical: TextAlignVertical.center,
      cursorColor: context.themeColors.textPlaceholder,
      cursorRadius: Radius.circular(4),
      textAlign: TextAlign.center,
      style: AppStyle.getStyle(
        TextStyleType.heading01,
        color: context.themeColors.textSecondary,
      ),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.zero,
        fillColor: context.themeColors.field01,
        filled: true,
        isDense: true,
        hintText: "Search Torrent",
        hintStyle: AppStyle.getStyle(
          TextStyleType.helperText01,
          color: context.themeColors.textPlaceholder,
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: context.themeColors.borderStrong01),
          borderRadius: BorderRadius.zero,
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: context.themeColors.borderStrong01),
          borderRadius: BorderRadius.zero,
        ),
        prefixIcon: IconWidget(icon: AppAsset.svg.icSearch),
        suffixIcon: ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller,
          builder:
              (_, value, __) =>
                  value.text.isEmpty
                      ? SizedBox(width: 24)
                      : IconWidget(
                        icon: AppAsset.svg.icCancel,
                        enableSplash: false,
                        onTap: () {
                          controller.clear();
                          widget.onSearch("");
                        },
                      ),
        ),
      ),
      onSubmitted: (value) {
        widget.onSearch(value);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.showSuggestions) {
      return _buildField(context, TextEditingController(), _focusNode, () {});
    }

    return RawAutocomplete<String>(
      textEditingController: _textEditingController,
      focusNode: _focusNode,
      optionsBuilder: (textEditingValue) async {
        return await _fetchSuggestions(textEditingValue.text);
      },
      onSelected: widget.onSearch,
      fieldViewBuilder: _buildField,
      optionsViewBuilder:
          (context, onSelected, options) => Material(
            color: context.themeColors.background,
            child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: options.length,
              itemBuilder:
                  (context, index) => ListTile(
                    title: AppText.body01(options.elementAt(index)),
                    onTap: () => onSelected(options.elementAt(index)),
                  ),
            ),
          ),
    );
  }
}
