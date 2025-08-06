import 'package:flutter/material.dart';
import 'package:torfin/core/utils/extensions.dart';

import '../../../core/utils/app_assets.dart';
import '../../../core/utils/string_constants.dart';
import '../../data/models/response/action/action.dart';
import '../../data/models/response/torrent/torrent_res.dart';
import 'action_sheet_widget.dart';
import 'tag_widget.dart';

class SortWidget extends StatefulWidget {
  final Function(SortType sortType) onSort;
  const SortWidget({super.key, required this.onSort});

  @override
  State<SortWidget> createState() => _SortWidgetState();
}

class _SortWidgetState extends State<SortWidget> {
  SortType _selectedSort = SortType.none;

  @override
  Widget build(BuildContext context) {
    return TagWidget(
      tagText: _selectedSort.title,
      tagColor: context.colors.tagColorBlue,
      tagBackgroundColor: context.colors.tagBackgroundBlue,
      tagHoverColor: context.colors.tagHoverBlue,
      tagIcon: AppAssets.icSort,
      onTap: () {
        showModalBottomSheet(
          context: context,
          barrierColor: context.colors.overlay,
          backgroundColor: Colors.transparent,
          shape: LinearBorder.none,
          isScrollControlled: true,
          builder: (context) => ActionSheetWidget(
            actions: [
              ActionModel(
                actionTitle: sortBy,
                actionItems: SortType.values
                    .map(
                      (sort) => ActionItem(
                        title: sort.title,
                        value: sort.value,
                        isSelected: sort == _selectedSort,
                      ),
                    )
                    .toList(),
              ),
            ],
            onTap: (action) {
              setState(() {
                _selectedSort = SortType.values.firstWhere(
                  (sort) => sort.value == action.value,
                );
                widget.onSort.call(_selectedSort);
              });
            },
          ),
        );
      },
    );
  }
}
