import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String labelText;
  final TextEditingController? controller;
  final TextInputType inputType;
  final ValueChanged<String>? onChanged;
  final Widget? prefix;
  String? Function(String?)? validator;
  final Function(String)? onSave;

   InputField(
      {Key? key,
      required this.labelText,
       this.controller,
         this.onChanged,
        required this.validator,
         this.onSave,
        this.prefix,
      this.inputType = TextInputType.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(

      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextFormField(
          validator: validator,
          keyboardType: inputType,
          decoration: InputDecoration(
            prefixIcon:prefix ,
            labelText: labelText,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(width: 1)),
          ),
          controller: controller,
        ),
      ),
    );
  }
}
