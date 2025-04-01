import 'package:flutter/material.dart';

class AppTextFormField extends StatelessWidget {
  const AppTextFormField({
    required this.labelText,
    required this.hintText,
    this.controller,
    this.focusNode,
    this.onSubmit,
    this.validator,
    this.maxLines = 1,
    super.key,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final void Function(String)? onSubmit;
  final String labelText;
  final String hintText;
  final String? Function(String?)? validator;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    final localController = controller ?? TextEditingController();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: TextStyle(color: Theme.of(context).colorScheme.outline),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: localController,
          focusNode: focusNode,
          onFieldSubmitted: onSubmit,
          decoration: InputDecoration(
            fillColor: Theme.of(context).colorScheme.onSecondary,
            suffixIcon: onSubmit != null
                ? IconButton(
                    onPressed: () => onSubmit!(localController.text),
                    icon: const Icon(Icons.add),
                  )
                : null,
            hintText: hintText,
            labelStyle: TextStyle(color: Theme.of(context).colorScheme.outline),
            hintStyle: TextStyle(color: Theme.of(context).colorScheme.outline),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Theme.of(context).colorScheme.outline.withOpacity(0.2)),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Theme.of(context).colorScheme.outline.withOpacity(0.2)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Theme.of(context).colorScheme.outline.withOpacity(0.2)),
            ),
          ),
          validator: validator,
          maxLines: maxLines,
        ),
      ],
    );
  }
}
