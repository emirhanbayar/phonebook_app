import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ContactDisplay extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final VoidCallback onDeleteContact;

  const ContactDisplay({
    Key? key,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.onDeleteContact,
  }) : super(key: key);

  Widget _buildInfoField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(15, 0, 15, 15),
          child: Text(
            value,
            style: GoogleFonts.nunito(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: Color(0xFF181818),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, 14),
          height: 1,
          color: Color(0xFFBABABA),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoField('First Name', firstName),
        _buildInfoField('Last Name', lastName),
        _buildInfoField('Phone Number', phoneNumber),
        SizedBox(height: 20),
        GestureDetector(
          onTap: onDeleteContact,
          child: Container(
            margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: Text(
              'Delete contact',
              style: GoogleFonts.nunito(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: Color(0xFFFF0000),
              ),
            ),
          ),
        ),
      ],
    );
  }
}