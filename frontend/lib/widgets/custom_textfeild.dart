import 'package:flutter/material.dart';

import '../constants/colors.dart';

class CusttomTextfeild extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final Color borderColor;

  const CusttomTextfeild({super.key, required this.controller, required this.labelText, required this.borderColor});

  @override
  State<CusttomTextfeild> createState() => _CusttomTextfeildState();
}

class _CusttomTextfeildState extends State<CusttomTextfeild> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color:  widget.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color:  widget.borderColor),
        ),
        label: Text(
          widget.labelText,
          style: TextStyle(
            color: AppColors.labeltextBlack,
            fontFamily: 'Poppins',
          ),
        ),
      ),
    );
  }
}