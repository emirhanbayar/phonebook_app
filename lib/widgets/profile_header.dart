import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileHeader extends StatelessWidget {
  final String title;
  final VoidCallback onCancel;
  final VoidCallback onAction;
  final String actionText;
  final bool isActionEnabled;

  const ProfileHeader({
    Key? key,
    required this.title,
    required this.onCancel,
    required this.onAction,
    required this.actionText,
    this.isActionEnabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(30, 30, 30, 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: onCancel,
            child: Text(
              'Cancel',
              style: GoogleFonts.nunito(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Color(0xFF0075FF),
              ),
            ),
          ),
          Text(
            title,
            style: GoogleFonts.nunito(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: Color(0xFF181818),
            ),
          ),
          GestureDetector(
            onTap: isActionEnabled ? onAction : null,
            child: Text(
              actionText,
              style: GoogleFonts.nunito(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: isActionEnabled ? Color(0xFF0075FF) : Color(0xFFBABABA),
              ),
            ),
          ),
        ],
      ),
    );
  }
}