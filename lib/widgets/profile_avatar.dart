import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:io';
import '../utils/constants.dart';

class ProfileAvatar extends StatelessWidget {
  final String? imageUrl;
  final File? imageFile;
  final VoidCallback onTap;
  final String caption;

  const ProfileAvatar({
    Key? key,
    this.imageUrl,
    this.imageFile,
    required this.onTap,
    this.caption = "Add Contact"
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.35,
            height: MediaQuery.of(context).size.width * 0.35,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppConstants.backgroundColor,
            ),
            child: _buildImage(),
          ),
        ),
        SizedBox(height: 15),
        GestureDetector(
          onTap: onTap,
          child: Text(
            caption,
            style: GoogleFonts.nunito(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: AppConstants.textColor,
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
          width: double.infinity,
          height: double.infinity,
        ),
      );
    } else if (imageUrl != null && imageUrl!.isNotEmpty) {
      return ClipOval(
        child: CachedNetworkImage(
          imageUrl: imageUrl!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) => SvgPicture.asset(
            'assets/vectors/empty-avatar.svg',
            width: double.infinity,
            height: double.infinity,
          ),
        ),
      );
    } else {
      return SvgPicture.asset(
        'assets/vectors/empty-avatar.svg',
        width: double.infinity,
        height: double.infinity,
      );
    }
  }
}
