import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/contact.dart';
import 'screens/contacts_list_screen.dart';
import 'screens/new_contact_screen.dart';
import 'screens/view_contact_screen.dart';
import 'screens/edit_contact_screen.dart';
import 'services/service_locator.dart';

void main() {
  setupServiceLocator();
  runApp(
    ChangeNotifierProvider(
      create: (context) => ContactProvider(),
      child: PhonebookApp(),
    ),
  );
}

class PhonebookApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contact App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Nunito',
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => ContactsListScreen(),
        '/new_contact': (context) => NewContactScreen(),
        '/view_contact': (context) => ViewContactScreen(),
        '/edit_contact': (context) => EditContactScreen(),
      },
    );
  }
}