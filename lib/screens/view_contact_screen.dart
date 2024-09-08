import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/contact.dart';
import '../services/api_service.dart';
import '../widgets/screen_layout.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_avatar.dart';
import '../widgets/contact_display.dart';
import '../widgets/delete_account_drawer.dart';
import '../widgets/success_notification.dart';

class ViewContactScreen extends StatefulWidget {
  @override
  _ViewContactScreenState createState() => _ViewContactScreenState();
}

class _ViewContactScreenState extends State<ViewContactScreen>
    with WidgetsBindingObserver {
  late Contact _contact;
  late ApiService _apiService;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _apiService = ApiService();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _contact = ModalRoute.of(context)!.settings.arguments as Contact;
    _fetchContactDetails();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _fetchContactDetails();
    }
  }

  Future<void> _fetchContactDetails() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final updatedContact = await _apiService.getContact(_contact.id);
      setState(() {
        _contact = updatedContact;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching contact details: $e');
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch contact details')),
      );
    }
  }

  void _showDeleteConfirmation() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return DeleteAccountDrawer(
          onYes: () async {
            final contactProvider =
                Provider.of<ContactProvider>(context, listen: false);
            try {
              await contactProvider.deleteContact(_contact.id);
              Navigator.pop(context); // Close the drawer
              Navigator.pop(context); // Go back to contacts list
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: SuccessNotification(
                      message: 'Contact deleted successfully'),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                ),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to delete contact')),
              );
            }
          },
          onNo: () => Navigator.pop(context),
        );
      },
    );
  }

  Future<void> _editContact() async {
    await Navigator.pushNamed(
      context,
      '/edit_contact',
      arguments: _contact,
    );
    _fetchContactDetails(); // Fetch updated contact details after returning from edit screen
  }

  @override
  Widget build(BuildContext context) {
    return ScreenLayout(
      useCardStyle: true,
      child: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  ProfileHeader(
                    title: '',
                    onCancel: () => Navigator.pop(context),
                    onAction: _editContact,
                    actionText: 'Edit',
                  ),
                  ProfileAvatar(
                    imageUrl: _contact.profileImageUrl,
                    onTap: () {}, // No action on view screen
                    caption: "",
                  ),
                  Padding(
                    padding: EdgeInsets.all(30),
                    child: ContactDisplay(
                      firstName: _contact.firstName,
                      lastName: _contact.lastName,
                      phoneNumber: _contact.phoneNumber,
                      onDeleteContact: _showDeleteConfirmation,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
