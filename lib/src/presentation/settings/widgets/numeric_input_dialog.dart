import 'package:flutter/material.dart';

import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/string_constants.dart';
import '../../widgets/button_widget.dart';
import '../../widgets/dialog_widget.dart';
import '../../widgets/text_field_widget.dart';

class NumericInputDialog extends StatefulWidget {
  const NumericInputDialog({
    required this.title,
    required this.currentValue,
    this.validator,
    super.key,
  });

  final String title;
  final String currentValue;
  final String? Function(String?)? validator;

  @override
  State<NumericInputDialog> createState() => _NumericInputDialogState();

  static Future<int?> show(
    BuildContext context, {
    required String title,
    required String currentValue,
    String? Function(String?)? validator,
  }) async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => NumericInputDialog(
        title: title,
        currentValue: currentValue,
        validator: validator,
      ),
    );

    if (result?.isNotEmpty == true) {
      return int.tryParse(result!);
    }
    return null;
  }
}

class _NumericInputDialogState extends State<NumericInputDialog> {
  late String _inputValue;
  late bool _isValid;

  @override
  void initState() {
    super.initState();
    _inputValue = widget.currentValue;
    _isValid = _validate(widget.currentValue) == null;
  }

  String? _validate(String? value) {
    if (widget.validator != null) {
      return widget.validator!(value);
    }
    if (value?.isEmpty != false) return '';
    final intValue = int.tryParse(value ?? '');
    return (intValue != null && intValue > 0) ? null : '';
  }

  @override
  Widget build(BuildContext context) {
    return DialogWidget(
      title: widget.title,
      content: TextFieldWidget(
        hintText: enterANumber,
        initialValue: widget.currentValue,
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
        integerOnly: true,
        keyboardType: TextInputType.number,
        validator: _validate,
        onChange: (value) => _inputValue = value,
        onValidationChanged: (valid) => setState(() => _isValid = valid),
      ),
      actions: Row(
        children: [
          Expanded(
            child: ButtonWidget(
              backgroundColor: context.colors.buttonSecondary,
              buttonText: cancel,
              onTap: Navigator.of(context).pop,
            ),
          ),
          Expanded(
            child: Opacity(
              opacity: _isValid ? 1.0 : 0.5,
              child: ButtonWidget(
                backgroundColor: context.colors.buttonPrimary,
                buttonText: apply,
                onTap: _isValid
                    ? () => Navigator.of(context).pop(_inputValue)
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
