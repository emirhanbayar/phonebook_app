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

class EditContactScreen extends StatefulWidget {
  @override
  _EditContactScreenState createState() => _EditContactScreenState();
}

class _EditContactScreenState extends State<EditContactScreen> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneNumberController;
  String? _profileImageUrl;
  File? _imageFile;
  late Contact _contact;
  bool _hasChanges = false;
  bool _isUploading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _contact = ModalRoute.of(context)!.settings.arguments as Contact;
    _firstNameController = TextEditingController(text: _contact.firstName);
    _lastNameController = TextEditingController(text: _contact.lastName);
    _phoneNumberController = TextEditingController(text: _contact.phoneNumber);
    _profileImageUrl = _contact.profileImageUrl;
  }

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
        _hasChanges = true;
      });
    }
    Navigator.pop(context);
  }

  Future<void> _updateContact() async {
    setState(() {
      _isUploading = true;
    });

    final contactProvider =
        Provider.of<ContactProvider>(context, listen: false);
    final apiService = ApiService();

    try {
      if (_imageFile != null) {
        _profileImageUrl = await apiService.uploadImage(_imageFile!);
      }

      final updatedContact = Contact(
        id: _contact.id,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        phoneNumber: _phoneNumberController.text,
        profileImageUrl: _profileImageUrl,
      );

      final result = await contactProvider.updateContact(updatedContact);

      setState(() {
        _isUploading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: SuccessNotification(message: 'Contact updated successfully'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      );
      Navigator.pop(context, result);
    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update contact: ${e.toString()}')),
      );
    }
  }

  void _checkForChanges() {
    setState(() {
      _hasChanges = _firstNameController.text != _contact.firstName ||
          _lastNameController.text != _contact.lastName ||
          _phoneNumberController.text != _contact.phoneNumber ||
          _imageFile != null;
    });
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
                  title: '',
                  onCancel: () => Navigator.pop(context),
                  onAction: _isUploading ? null : () => _updateContact(),
                  actionText: 'Done',
                  isActionEnabled: _hasChanges && !_isUploading,
                ),
                ProfileAvatar(
                  imageFile: _imageFile,
                  imageUrl: _profileImageUrl,
                  onTap: _showPhotoOptions,
                  caption: "Change Photo",
                ),
                Padding(
                  padding: EdgeInsets.all(30),
                  child: ContactForm(
                    firstNameController: _firstNameController,
                    lastNameController: _lastNameController,
                    phoneNumberController: _phoneNumberController,
                    onChanged: _checkForChanges,
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
