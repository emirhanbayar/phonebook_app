import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ContactListItem extends StatelessWidget {
  final String name;
  final String phoneNumber;
  final String? imageUrl;
  final VoidCallback onTap;

  const ContactListItem({
    Key? key,
    required this.name,
    required this.phoneNumber,
    this.imageUrl,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 13, 20, 13),
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.only(right: 15),
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: imageUrl != null
                      ? DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(imageUrl!),
                  )
                      : null,
                ),
                child: imageUrl == null
                    ? Icon(
                  Icons.person,
                  color: Colors.grey,
                )
                    : null,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.nunito(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Color(0xFF000000),
                      ),
                    ),
                    Text(
                      phoneNumber,
                      style: GoogleFonts.nunito(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Color(0xFFBABABA),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}