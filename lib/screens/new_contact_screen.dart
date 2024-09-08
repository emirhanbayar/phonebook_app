import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../models/contact.dart';
import '../widgets/screen_layout.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_avatar.dart';
import '../widgets/contact_form.dart';
import '../widgets/photo_option_drawer.dart';
import '../widgets/success_notification.dart';
import '../services/api_service.dart';

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
  bool _isUploading = false;

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
    setState(() {
      _isUploading = true;
    });

    final contactProvider = Provider.of<ContactProvider>(context, listen: false);
    final apiService = ApiService();

    try {
      String? profileImageUrl;
      if (_imageFile != null) {
        profileImageUrl = await apiService.uploadImage(_imageFile!);
      }

      final newContact = Contact(
        id: '', // ID will be assigned by the server
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        phoneNumber: _phoneNumberController.text,
        profileImageUrl: profileImageUrl,
      );

      final createdContact = await contactProvider.addContact(newContact);

      setState(() {
        _isUploading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: SuccessNotification(message: 'Contact added successfully'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      );
      Navigator.pushReplacementNamed(context, '/view_contact', arguments: createdContact);
    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add contact: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenLayout(
      useCardStyle: true,
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                ProfileHeader(
                  title: 'New Contact',
                  onCancel: () => Navigator.pop(context),
                  onAction: _isUploading ? null : () => _createContact(),
                  actionText: 'Done',
                  isActionEnabled: _isFormValid && !_isUploading,
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
          if (_isUploading)
            Container(
              color: Colors.black54,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}