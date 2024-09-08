import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class SuccessNotification extends StatelessWidget {
  final String message;

  const SuccessNotification({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFFFFFFF),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x00000000),
            offset: Offset(0, -6),
            blurRadius: 20.0499992371,
          ),
        ],
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/vectors/success.svg',
              width: 24,
              height: 24,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: GoogleFonts.nunito(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: Color(0xFF008505),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}