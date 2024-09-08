import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/contact.dart';
import '../utils/error_handler.dart';
import '../utils/constants.dart';

class ApiService {
  static const String baseUrl = AppConstants.apiBaseUrl;
  static const String apiKey = AppConstants.apiKey;

  Future<List<Contact>> getContacts({int skip = 0, int take = 10, String? search}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/User?skip=$skip&take=$take${search != null ? '&search=$search' : ''}'),
        headers: {'ApiKey': apiKey},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> contactsJson = data['data']['users'];
        return contactsJson.map((json) => Contact.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load contacts: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(ErrorHandler.getErrorMessage(e));
    }
  }

  Future<Contact> createContact(Contact contact) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/User'),
        headers: {
          'ApiKey': apiKey,
          'Content-Type': 'application/json',
        },
        body: json.encode(contact.toJson()),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Contact.fromJson(data['data']);
      } else {
        throw Exception('Failed to create contact: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(ErrorHandler.getErrorMessage(e));
    }
  }

  Future<Contact> getContact(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/User/$id'),
        headers: {'ApiKey': apiKey},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Contact.fromJson(data['data']);
      } else {
        throw Exception('Failed to load contact: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(ErrorHandler.getErrorMessage(e));
    }
  }

  Future<Contact> updateContact(Contact contact) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/User/${contact.id}'),
        headers: {
          'ApiKey': apiKey,
          'Content-Type': 'application/json',
        },
        body: json.encode(contact.toJson()),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Contact.fromJson(data['data']);
      } else {
        throw Exception('Failed to update contact: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(ErrorHandler.getErrorMessage(e));
    }
  }

  Future<void> deleteContact(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/User/$id'),
        headers: {'ApiKey': apiKey},
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete contact: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(ErrorHandler.getErrorMessage(e));
    }
  }

  Future<String> uploadImage(List<int> imageBytes) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/User/UploadImage'))
        ..headers['ApiKey'] = apiKey
        ..files.add(http.MultipartFile.fromBytes('image', imageBytes, filename: 'image.jpg'));

      var response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.toBytes();
        final responseString = String.fromCharCodes(responseData);
        final Map<String, dynamic> data = json.decode(responseString);
        return data['data']['imageUrl'];
      } else {
        throw Exception('Failed to upload image: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(ErrorHandler.getErrorMessage(e));
    }
  }
}