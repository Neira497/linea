import 'package:flutter/material.dart';

class DropdownField extends StatefulWidget {
  final String label;
  final List<String> items;
  final String? value;
  final void Function(String?) onChanged;
  final String? Function(String?)? validator;
  final bool? disabled;
  final EdgeInsetsGeometry? paddingInterno;
  final Color? colorFondo;
  final bool? centerHint;
  final Color? hintColor;

  const DropdownField({
    super.key,
    required this.label,
    required this.items,
    required this.onChanged,
    this.value,
    this.validator,
    this.disabled = false,
    this.paddingInterno,
    this.colorFondo,
    this.centerHint,
    this.hintColor,
  });

  @override
  State<DropdownField> createState() => _DropdownFieldState();
}

class _DropdownFieldState extends State<DropdownField> {
  bool _hasError = false;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: widget.value,
      onChanged: widget.disabled == true ? null : widget.onChanged,
      validator: (value) {
        final result = widget.validator?.call(value);
        setState(() {
          _hasError = result != null;
        });
        return result;
      },
      items: widget.items.map((item) {
        return DropdownMenuItem(value: item, child: Text(item));
      }).toList(),
      decoration: InputDecoration(
        contentPadding: widget.centerHint == true
            ? const EdgeInsets.only(top: 14, right: 10, left: 10)
            : widget.paddingInterno,
        filled: true,
        fillColor: widget.disabled == true
            ? Colors.grey.withValues(alpha: .13)
            : widget.colorFondo ?? Colors.white.withValues(alpha: .2),
        hintText: widget.centerHint == true ? widget.label : null,
        hintStyle: TextStyle(
          color: _hasError
              ? Colors.red
              : (widget.hintColor ??
                    (widget.disabled == true ? Colors.grey : Colors.brown)),
          fontSize: 16,
        ),
        labelText: widget.centerHint == true ? null : widget.label,
        labelStyle: TextStyle(
          color: _hasError
              ? Colors.red
              : (widget.disabled == true ? Colors.grey : Colors.brown),
        ),
        floatingLabelBehavior: widget.centerHint == true
            ? FloatingLabelBehavior.never
            : FloatingLabelBehavior.auto,
        errorStyle: const TextStyle(color: Colors.red),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.0),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.0),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.0),
          borderSide: const BorderSide(color: Colors.brown),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.0),
          borderSide: const BorderSide(color: Colors.brown),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.0),
          borderSide: const BorderSide(color: Colors.brown),
        ),
      ),
    );
  }
}
