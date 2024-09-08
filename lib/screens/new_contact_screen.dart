import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import '../models/contact.dart';
import '../widgets/screen_layout.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_avatar.dart';
import '../widgets/contact_form.dart';
import '../widgets/photo_option_drawer.dart';
import '../widgets/success_notification.dart';

class NewContactScreen extends StatefulWidget {
  @override
  _NewContactScreenState createState() => _NewContactScreenState();
}

class _NewContactScreenState extends State<NewContactScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  String? _profileImageUrl;
  File? _imageFile;

  bool get _isFormValid =>
      _firstNameController.text.isNotEmpty &&
          _lastNameController.text.isNotEmpty &&
          _phoneNumberController.text.isNotEmpty;

  void _showPhotoOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return PhotoOptionDrawer(
          onCameraPressed: () => _getImage(ImageSource.camera),
          onGalleryPressed: () => _getImage(ImageSource.gallery),
          onCancelPressed: () => Navigator.pop(context),
        );
      },
    );
  }

  Future<void> _getImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
    Navigator.pop(context);
  }

  Future<void> _createContact() async {
    final contactProvider = Provider.of<ContactProvider>(context, listen: false);

    if (_imageFile != null) {
      final bytes = await _imageFile!.readAsBytes();
      _profileImageUrl = await contactProvider.uploadImage(Uint8List.fromList(bytes));
    }

    final newContact = Contact(
      id: '', // ID will be assigned by the server
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      phoneNumber: _phoneNumberController.text,
      profileImageUrl: _profileImageUrl,
    );

    try {
      final createdContact = await contactProvider.addContact(newContact);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: SuccessNotification(message: 'Contact added successfully'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      );
      Navigator.pushReplacementNamed(context, '/view_contact', arguments: createdContact);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add contact')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenLayout(
      useCardStyle: true,
      child: SingleChildScrollView(
        child: Column(
          children: [
            ProfileHeader(
              title: 'New Contact',
              onCancel: () => Navigator.pop(context),
              onAction: _createContact,
              actionText: 'Done',
              isActionEnabled: _isFormValid,
            ),
            ProfileAvatar(
              imageFile: _imageFile,
              imageUrl: _profileImageUrl,
              onTap: _showPhotoOptions,
              caption: "Add Photo",
            ),
            Padding(
              padding: EdgeInsets.all(30),
              child: ContactForm(
                firstNameController: _firstNameController,
                lastNameController: _lastNameController,
                phoneNumberController: _phoneNumberController,
                onChanged: () => setState(() {}),
              ),
            ),
          ],
        ),
      ),
    );
  }
}