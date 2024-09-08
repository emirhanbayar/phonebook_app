import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DeleteAccountDrawer extends StatelessWidget {
  final VoidCallback onYes;
  final VoidCallback onNo;

  const DeleteAccountDrawer({
    Key? key,
    required this.onYes,
    required this.onNo,
  }) : super(key: key);

  Widget _buildButton(String text, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color(0xFFF4F4F4),
          boxShadow: [
            BoxShadow(
              color: Color(0x40000000),
              offset: Offset(0, 0),
              blurRadius: 2,
            ),
          ],
        ),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          child: Text(
            text,
            style: GoogleFonts.nunito(
              fontWeight: FontWeight.w700,
              fontSize: 24,
              color: Color(0xFF000000),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFFFFFFF),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x40000000),
            offset: Offset(0, -6),
            blurRadius: 20.0499992371,
          ),
        ],
      ),
      child: Container(
        padding: EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 25),
              child: Text(
                'Delete Account?',
                style: GoogleFonts.nunito(
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                  color: Color(0xFFFF0000),
                ),
              ),
            ),
            _buildButton('Yes', onYes),
            _buildButton('No', onNo),
          ],
        ),
      ),
    );
  }
}