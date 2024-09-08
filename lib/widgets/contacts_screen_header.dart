import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class ContactsScreenHeader extends StatelessWidget {
  final VoidCallback onAddPressed;

  const ContactsScreenHeader({Key? key, required this.onAddPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 16.5, 0),
            child: Text(
              'Contacts',
              style: GoogleFonts.nunito(
                fontWeight: FontWeight.w700,
                fontSize: 24,
                color: Color(0xFF000000),
              ),
            ),
          ),
          GestureDetector(
            onTap: onAddPressed,
            child: Container(
              margin: EdgeInsets.fromLTRB(0, 4, 0, 5),
              child: SvgPicture.asset(
                'assets/vectors/add.svg',
                width: 24,
                height: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}