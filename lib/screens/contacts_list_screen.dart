import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/contact.dart';
import '../widgets/screen_layout.dart';
import '../widgets/contacts_screen_header.dart';
import '../widgets/search_bar.dart';
import '../widgets/empty_contact_list.dart';
import '../widgets/contact_list_item.dart';

class ContactsListScreen extends StatefulWidget {
  @override
  _ContactsListScreenState createState() => _ContactsListScreenState();
}

class _ContactsListScreenState extends State<ContactsListScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchContacts();
  }

  Future<void> _fetchContacts() async {
    setState(() {
      _isLoading = true;
    });
    await Provider.of<ContactProvider>(context, listen: false).fetchContacts();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenLayout(
      child: Consumer<ContactProvider>(
        builder: (context, contactProvider, child) {
          return Container(
            padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
            child: Column(
              children: [
                ContactsScreenHeader(
                  onAddPressed: () => Navigator.pushNamed(context, '/new_contact'),
                ),
                CustomSearchBar(
                  onSearch: (value) {
                    _fetchContacts();
                  },
                ),
                Expanded(
                  child: _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : contactProvider.contacts.isEmpty
                      ? EmptyContactList(
                    onCreateNewContact: () => Navigator.pushNamed(context, '/new_contact'),
                  )
                      : ListView.builder(
                    itemCount: contactProvider.contacts.length,
                    itemBuilder: (context, index) {
                      final contact = contactProvider.contacts[index];
                      return ContactListItem(
                        name: '${contact.firstName} ${contact.lastName}',
                        phoneNumber: contact.phoneNumber,
                        imageUrl: contact.profileImageUrl,
                        onTap: () => Navigator.pushNamed(
                          context,
                          '/view_contact',
                          arguments: contact,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}