import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';

class ProfileAvatar extends StatelessWidget {
  final String? imageUrl;
  final File? imageFile;
  final VoidCallback onTap;
  final bool isNewContact;

  const ProfileAvatar({
    Key? key,
    this.imageUrl,
    this.imageFile,
    required this.onTap,
    this.isNewContact = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 195,
            height: 195,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFF4F4F4),
            ),
            child: _buildImage(),
          ),
        ),
        SizedBox(height: 15),
        GestureDetector(
          onTap: onTap,
          child: Text(
            isNewContact ? 'Add Photo' : 'Change Photo',
            style: GoogleFonts.nunito(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: Color(0xFF181818),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImage() {
    if (imageFile != null) {
      return ClipOval(
        child: Image.file(
          imageFile!,
          fit: BoxFit.cover,
          width: 195,
          height: 195,
        ),
      );
    } else if (imageUrl != null && imageUrl!.isNotEmpty) {
      return ClipOval(
        child: Image.network(
          imageUrl!,
          fit: BoxFit.cover,
          width: 195,
          height: 195,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(child: CircularProgressIndicator());
          },
          errorBuilder: (context, error, stackTrace) {
            return SvgPicture.asset(
              'assets/vectors/empty-avatar.svg',
              width: 195,
              height: 195,
            );
          },
        ),
      );
    } else {
      return SvgPicture.asset(
        'assets/vectors/empty-avatar.svg',
        width: 195,
        height: 195,
      );
    }
  }
}