import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final String hintText;
  final Function(String) onChanged;
  final Function(String) onSubmitted;

  const CustomSearchBar({
    Key? key,
    required this.hintText,
    required this.onChanged,
    required this.onSubmitted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: TextField(
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.grey),
            prefixIcon: const Icon(Icons.search),
            suffixIcon: const Icon(Icons.clear),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.only(left: 15, top: 15, bottom: 15),
          ),
        ),
      ),
    );
  }
}