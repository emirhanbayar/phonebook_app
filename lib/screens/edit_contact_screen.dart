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
    final contactProvider = Provider.of<ContactProvider>(context, listen: false);

    if (_imageFile != null) {
      final bytes = await _imageFile!.readAsBytes();
      _profileImageUrl = await contactProvider.uploadImage(Uint8List.fromList(bytes));
    }

    final updatedContact = Contact(
      id: _contact.id,
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      phoneNumber: _phoneNumberController.text,
      profileImageUrl: _profileImageUrl,
    );

    try {
      final result = await contactProvider.updateContact(updatedContact);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: SuccessNotification(message: 'Contact updated successfully'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      );
      Navigator.pop(context, result);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update contact')),
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
      child: SingleChildScrollView(
        child: Column(
          children: [
            ProfileHeader(
              title: 'Edit Contact',
              onCancel: () => Navigator.pop(context),
              onAction: _updateContact,
              actionText: 'Done',
              isActionEnabled: _hasChanges,
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
    );
  }
}