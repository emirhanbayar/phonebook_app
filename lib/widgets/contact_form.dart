import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/constants.dart';

class ContactForm extends StatefulWidget {
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

  @override
  _ContactFormState createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final _formKey = GlobalKey<FormState>();

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters long';
    }
    return null;
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    if (!RegExp(r'^\+?[\d\s-]+$').hasMatch(value)) {
      return 'Enter a valid phone number';
    }
    return null;
  }

  Widget _buildTextField(TextEditingController controller, String placeholder,
      String? Function(String?) validator) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
          border: Border.all(color: Color(0xFF000000)),
          borderRadius: BorderRadius.circular(15),
          color: AppConstants.backgroundColor),
      child: TextFormField(
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
          errorStyle: GoogleFonts.nunito(
            color: Colors.red,
            fontSize: 12,
          ),
        ),
        validator: validator,
        onChanged: (_) {
          widget.onChanged?.call();
          _formKey.currentState?.validate();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildTextField(
              widget.firstNameController, 'First name', _validateName),
          _buildTextField(
              widget.lastNameController, 'Last name', _validateName),
          _buildTextField(widget.phoneNumberController, 'Phone number',
              _validatePhoneNumber),
        ],
      ),
    );
  }
}
