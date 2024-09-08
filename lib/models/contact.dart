import 'package:flutter/foundation.dart';
import 'dart:typed_data';
import '../services/api_service.dart';

class Contact {
  final String id;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String? profileImageUrl;

  Contact({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    this.profileImageUrl,
  });

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      phoneNumber: json['phoneNumber'],
      profileImageUrl: json['profileImageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'profileImageUrl': profileImageUrl,
    };
  }
}

class ContactProvider with ChangeNotifier {
  List<Contact> _contacts = [];
  final ApiService _apiService = ApiService();

  List<Contact> get contacts => _contacts;

  Future<void> fetchContacts({String? search}) async {
    try {
      _contacts = await _apiService.getContacts(search: search);
      notifyListeners();
    } catch (e) {
      print('Error fetching contacts: $e');
    }
  }

  Future<Contact> addContact(Contact contact) async {
    try {
      final newContact = await _apiService.createContact(contact);
      _contacts.add(newContact);
      notifyListeners();
      return newContact;
    } catch (e) {
      print('Error adding contact: $e');
      rethrow;
    }
  }

  Future<Contact> updateContact(Contact updatedContact) async {
    try {
      final contact = await _apiService.updateContact(updatedContact);
      final index = _contacts.indexWhere((c) => c.id == contact.id);
      if (index != -1) {
        _contacts[index] = contact;
        notifyListeners();
      }
      return contact;
    } catch (e) {
      print('Error updating contact: $e');
      rethrow;
    }
  }

  Future<void> deleteContact(String id) async {
    try {
      await _apiService.deleteContact(id);
      _contacts.removeWhere((contact) => contact.id == id);
      notifyListeners();
    } catch (e) {
      print('Error deleting contact: $e');
      rethrow;
    }
  }

  Future<String> uploadImage(Uint8List imageBytes) async {
    try {
      return await _apiService.uploadImage(imageBytes);
    } catch (e) {
      print('Error uploading image: $e');
      rethrow;
    }
  }
}