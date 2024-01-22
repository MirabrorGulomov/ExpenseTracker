import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class AuthInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final TextCapitalization textCapitalization;
  final bool obscureText;
  final TextInputType textInputType;
  final String text;
  const AuthInputWidget({
    super.key,
    required this.controller,
    required this.textCapitalization,
    required this.obscureText,
    required this.textInputType,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: controller,
          decoration: InputDecoration(
            labelStyle: const TextStyle(
              color: Color(0xff492A53),
            ),
            labelText: text,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                color: Colors.grey.shade400,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                color: Colors.grey.shade400,
              ),
            ),
          ),
          textCapitalization: textCapitalization,
          obscureText: obscureText,
          keyboardType: textInputType,
        ),
        const SizedBox(
          height: 20,
        )
      ],
    );
  }
}
