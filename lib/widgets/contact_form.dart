import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ContactForm extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController phoneNumberController;
  final VoidCallback? onChanged;

  const ContactForm({
    Key? key,
    required this.firstNameController,
    required this.lastNameController,
    required this.phoneNumberController,
    this.onChanged,
  }) : super(key: key);

  Widget _buildTextField(TextEditingController controller, String placeholder) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFF000000)),
        borderRadius: BorderRadius.circular(15),
        color: Color(0xFFF4F4F4),
      ),
      child: TextField(
        controller: controller,
        style: GoogleFonts.nunito(
          fontWeight: FontWeight.w700,
          fontSize: 16,
          color: Color(0xFF000000),
        ),
        decoration: InputDecoration(
          hintText: placeholder,
          hintStyle: GoogleFonts.nunito(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: Color(0xFFBABABA),
          ),
          contentPadding: EdgeInsets.fromLTRB(19, 9, 19, 10),
          border: InputBorder.none,
        ),
        onChanged: (_) => onChanged?.call(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTextField(firstNameController, 'First name'),
        _buildTextField(lastNameController, 'Last name'),
        _buildTextField(phoneNumberController, 'Phone number'),
      ],
    );
  }
}