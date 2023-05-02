import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final TextInputType inputType;
  final Widget? prefix;

  const InputField(
      {Key? key,
      required this.labelText,
      required this.controller,
        this.prefix,
      this.inputType = TextInputType.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(

      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
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
