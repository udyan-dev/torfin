import 'package:flutter/material.dart';
import 'package:torfin/core/utils/extensions.dart';

import '../../../core/theme/app_styles.dart';
import '../../../core/utils/string_constants.dart';
import '../../data/models/response/action/action.dart';
import 'button_widget.dart';
import 'checkbox_widget.dart';

class ActionSheetWidget extends StatefulWidget {
  final List<ActionModel> actions;
  final Function(ActionItem actionItem) onTap;
  const ActionSheetWidget({
    super.key,
    required this.actions,
    required this.onTap,
  });

  @override
  State<ActionSheetWidget> createState() => _ActionSheetWidgetState();
}

class _ActionSheetWidgetState extends State<ActionSheetWidget> {
  late int? selectedActionIndex;
  late int? selectedItemIndex;
  late final List<ActionModel> _actions;

  @override
  void initState() {
    super.initState();
    _actions = widget.actions;
    _initializeSelection();
  }

  void _initializeSelection() {
    selectedActionIndex = null;
    selectedItemIndex = null;

    final actionsLength = _actions.length;
    for (int actionIndex = 0; actionIndex < actionsLength; actionIndex++) {
      final actionItems = _actions[actionIndex].actionItems;
      final itemsLength = actionItems.length;
      for (int itemIndex = 0; itemIndex < itemsLength; itemIndex++) {
        if (actionItems[itemIndex].isSelected) {
          selectedActionIndex = actionIndex;
          selectedItemIndex = itemIndex;
          return;
        }
      }
    }
  }

  void _updateSelection(int actionIndex, int itemIndex) {
    if (selectedActionIndex != actionIndex || selectedItemIndex != itemIndex) {
      setState(() {
        selectedActionIndex = actionIndex;
        selectedItemIndex = itemIndex;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ColoredBox(
        color: context.colors.background,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ..._actions.asMap().entries.map((actionEntry) {
              final actionIndex = actionEntry.key;
              final action = actionEntry.value;
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: AppText.headingCompact01(
                      action.actionTitle,
                      color: context.colors.textPrimary,
                    ),
                  ),
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: context.colors.borderSubtle00,
                  ),
                  ListView.separated(
                    itemCount: action.actionItems.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, itemIndex) => InkWell(
                      onTap: () => _updateSelection(actionIndex, itemIndex),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 13.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppText.bodyCompact01(
                              action.actionItems[itemIndex].title,
                              color: context.colors.textPrimary,
                            ),
                            CheckBoxWidget(
                              value:
                                  (selectedActionIndex == actionIndex &&
                                  selectedItemIndex == itemIndex),
                              side: BorderSide(
                                color: context.colors.iconPrimary,
                              ),
                              activeColor: context.colors.iconPrimary,
                              onChanged: (_) =>
                                  _updateSelection(actionIndex, itemIndex),
                            ),
                          ],
                        ),
                      ),
                    ),
                    separatorBuilder: (context, separatorIndex) => Divider(
                      height: 1,
                      thickness: 1,
                      color: context.colors.borderSubtle00,
                    ),
                  ),
                ],
              );
            }),
            Row(
              children: [
                Expanded(
                  child: ButtonWidget(
                    backgroundColor: context.colors.buttonSecondary,
                    buttonText: cancel,
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                Expanded(
                  child: ButtonWidget(
                    backgroundColor: context.colors.buttonPrimary,
                    buttonText: apply,
                    onTap: () {
                      final actionIndex = selectedActionIndex;
                      final itemIndex = selectedItemIndex;
                      if (actionIndex != null && itemIndex != null) {
                        widget.onTap.call(
                          _actions[actionIndex].actionItems[itemIndex],
                        );
                      }
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
