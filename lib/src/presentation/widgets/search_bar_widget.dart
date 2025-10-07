import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/theme/app_styles.dart';
import '../../../core/utils/app_assets.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/utils/string_constants.dart';

class SearchBarWidget extends StatefulWidget {
  final Function(String)? onSearch;
  final Function(String value) onFetchSuggestions;

  const SearchBarWidget({
    super.key,
    this.onSearch,
    required this.onFetchSuggestions,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return RawAutocomplete<String>(
      textEditingController: _controller,
      focusNode: _focusNode,
      optionsBuilder: (textEditingValue) async {
        return await widget.onFetchSuggestions.call(textEditingValue.text);
      },
      onSelected: (value) {
        widget.onSearch?.call(value);
        _focusNode.unfocus();
      },
      fieldViewBuilder: _buildSearchField,
      optionsViewBuilder: (context, onSelected, options) => Material(
        color: context.colors.background,
        child: ListView.builder(
          padding: const EdgeInsets.only(left: 52),
          shrinkWrap: true,
          itemCount: options.length,
          itemBuilder: (context, index) => ListTile(
            title: AppText.bodyCompact02(options.elementAt(index)),
            onTap: () => onSelected(options.elementAt(index)),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField(
    BuildContext context,
    TextEditingController controller,
    FocusNode focusNode,
    _,
  ) {
    return DecoratedBox(
      decoration: BoxDecoration(color: context.colors.background),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: SizedBox(
          height: kMinInteractiveDimension,
          child: SearchBar(
            focusNode: focusNode,
            controller: controller,
            onTapOutside: (_) => focusNode.unfocus(),
            hintText: hintText,
            textInputAction: TextInputAction.search,
            leading: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: SvgPicture.asset(
                AppAssets.icSearch,
                width: 22,
                height: 22,
                colorFilter: context.colors.iconSecondary.colorFilter,
              ),
            ),
            trailing: [
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: controller,
                builder: (_, value, _) => value.text.isNotEmpty
                    ? IconButton(
                        icon: SvgPicture.asset(
                          AppAssets.icClose,
                          width: 22,
                          height: 22,
                          colorFilter: context.colors.iconPrimary.colorFilter,
                        ),
                        onPressed: () {
                          controller.clear();
                          widget.onSearch?.call('');
                        },
                      )
                    : emptyBox,
              ),
            ],
            onSubmitted: (value) {
              final searchText = value.trim();
              widget.onSearch?.call(searchText);
            },
          ),
        ),
      ),
    );
  }
}
