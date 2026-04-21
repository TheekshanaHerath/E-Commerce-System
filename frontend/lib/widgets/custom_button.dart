import 'package:flutter/material.dart';
import '../constants/colors.dart';

class CusttomButton extends StatelessWidget {
  final double btnWidth;
  final String btnText;
  final VoidCallback? onTap;

  const CusttomButton({
    super.key,
    required this.btnWidth,
    required this.btnText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: btnWidth,
        height: 55,
        decoration: BoxDecoration(
          color: AppColors.accentColor,
          borderRadius: BorderRadius.circular(80),
        ),
        child: Center(
          child: Text(
            btnText,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Poppins',
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}