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

class _ContactsListScreenState extends State<ContactsListScreen> with WidgetsBindingObserver {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _fetchContacts();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _fetchContacts();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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
          return RefreshIndicator(
            onRefresh: _fetchContacts,
            child: Container(
              padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: Column(
                children: [
                  ContactsScreenHeader(
                    onAddPressed: () => Navigator.pushNamed(context, '/new_contact').then((_) => _fetchContacts()),
                  ),
                  CustomSearchBar(
                    onSearch: (value) {
                      contactProvider.fetchContacts(search: value);
                    },
                  ),
                  Expanded(
                    child: _isLoading
                        ? Center(child: CircularProgressIndicator())
                        : contactProvider.contacts.isEmpty
                        ? EmptyContactList(
                      onCreateNewContact: () => Navigator.pushNamed(context, '/new_contact').then((_) => _fetchContacts()),
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
                          ).then((_) => _fetchContacts()),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}