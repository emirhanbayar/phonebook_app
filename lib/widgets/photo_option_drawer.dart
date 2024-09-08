import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class PhotoOptionDrawer extends StatelessWidget {
  final VoidCallback onCameraPressed;
  final VoidCallback onGalleryPressed;
  final VoidCallback onCancelPressed;

  const PhotoOptionDrawer({
    Key? key,
    required this.onCameraPressed,
    required this.onGalleryPressed,
    required this.onCancelPressed,
  }) : super(key: key);

  Widget _buildOption(String text, String iconPath, VoidCallback onPressed) {
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (iconPath.isNotEmpty)
                SvgPicture.asset(
                  iconPath,
                  width: 24,
                  height: 24,
                  placeholderBuilder: (BuildContext context) => SizedBox(width: 24, height: 24),
                ),
              if (iconPath.isNotEmpty) SizedBox(width: 10),
              Text(
                text,
                style: GoogleFonts.nunito(
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                  color: iconPath.isEmpty ? Color(0xFF0075FF) : Color(0xFF000000),
                ),
                textAlign: iconPath.isEmpty ? TextAlign.center : TextAlign.left,
              ),
            ],
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
            _buildOption('Camera', 'assets/vectors/camera.svg', onCameraPressed),
            _buildOption('Gallery', 'assets/vectors/picture.svg', onGalleryPressed),
            _buildOption('Cancel', '', onCancelPressed),
          ],
        ),
      ),
    );
  }
}