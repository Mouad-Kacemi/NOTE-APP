import 'package:flutter/material.dart';

class ContainerTextFormAdd extends StatelessWidget {
  final String hinttext;
  final TextEditingController mycontroller;
  ContainerTextFormAdd(
      {super.key, required this.hinttext, required this.mycontroller, this.validator});
  final String? Function(String?)? validator;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: mycontroller,
      decoration: InputDecoration(
          hintText: hinttext,
          hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 2, horizontal: 20),
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40),
              borderSide: const BorderSide(color: Colors.grey))),
    );
  }
}
