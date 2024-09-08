import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/constants.dart';

class EmptyContactList extends StatelessWidget {
  final VoidCallback onCreateNewContact;

  const EmptyContactList({Key? key, required this.onCreateNewContact})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
          child: SvgPicture.asset(
            'assets/vectors/empty-avatar.svg',
            width: 60,
            height: 60,
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, 7),
          child: Text(
            'No Contacts',
            style: GoogleFonts.nunito(
              fontWeight: FontWeight.w700,
              fontSize: 24,
              color: Color(0xFF000000),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, 7),
          child: Text(
            'Contacts you\'ve added will appear here.',
            style: GoogleFonts.nunito(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: Color(0xFF000000),
            ),
          ),
        ),
        GestureDetector(
          onTap: onCreateNewContact,
          child: Text(
            'Create New Contact',
            style: GoogleFonts.nunito(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: AppConstants.primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
