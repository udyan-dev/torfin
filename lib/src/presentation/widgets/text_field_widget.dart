import 'package:flutter/material.dart';

import '../../../core/utils/extensions.dart';
import '../../../core/utils/string_constants.dart';

class TextFieldWidget extends StatefulWidget {
  final String hintText;
  final String? initialValue;
  final EdgeInsets? padding;
  final ValueChanged<String>? onChange;
  final ValueChanged<bool>? onValidationChanged;
  final FormFieldValidator<String>? validator;
  final bool integerOnly;
  final TextInputType? keyboardType;
  final List<Widget>? trailing;

  const TextFieldWidget({
    super.key,
    required this.hintText,
    this.initialValue,
    this.padding,
    this.onChange,
    this.onValidationChanged,
    this.validator,
    this.integerOnly = false,
    this.keyboardType,
    this.trailing,
  });

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  late final TextEditingController _controller;
  bool _isValid = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue ?? '');
    final initialValue = widget.initialValue;
    if (initialValue?.isNotEmpty == true) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _validateInput(initialValue ?? ''),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _validateInput(String value) {
    final isValid = widget.validator?.call(value) == null;
    if (_isValid == isValid) return;
    setState(() => _isValid = isValid);
    widget.onValidationChanged?.call(isValid);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        height: kMinInteractiveDimension,
        child: SearchBar(
          controller: _controller,
          hintText: widget.hintText,
          keyboardType:
              widget.keyboardType ??
              (widget.integerOnly ? TextInputType.number : TextInputType.text),
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
          trailing: widget.trailing,
          onChanged: (value) {
            final text = value.trim();
            _validateInput(text);
            widget.onChange?.call(text);
          },
          onSubmitted: (value) {
            final text = value.trim();
            _validateInput(text);
            if (_isValid) widget.onChange?.call(text);
          },
        ),
      ),
    );
  }
}
