import 'package:flutter/material.dart';

import '../../../core/utils/extensions.dart';
import '../../../core/utils/string_constants.dart';
import 'button_widget.dart';
import 'dialog_widget.dart';

class BulkOperationDialog extends StatelessWidget {
  final String title;
  final String confirmButtonText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final Widget? trailing;
  final Widget? content;

  const BulkOperationDialog({
    super.key,
    required this.title,
    required this.confirmButtonText,
    this.onConfirm,
    this.onCancel,
    this.trailing,
    this.content,
  });

  @override
  Widget build(BuildContext context) {
    return DialogWidget(
      title: title,
      content: content,
      actions: Row(
        children: [
          Expanded(
            child: ButtonWidget(
              backgroundColor: context.colors.buttonSecondary,
              buttonText: cancel,
              onTap: onCancel ?? () => Navigator.of(context).maybePop(),
            ),
          ),
          Expanded(
            child: ButtonWidget(
              backgroundColor: context.colors.buttonPrimary,
              buttonText: confirmButtonText,
              onTap: onConfirm,
              trailing: trailing,
            ),
          ),
        ],
      ),
    );
  }
}
