import 'dart:convert';

import 'package:demo_salesforce/sales_force_contact.dart';
import 'package:http/http.dart' as http;

class SalesForceAPI {
  static Future<List<SalesForceContact>> getContacts(String accessToken) async {
    final response = await http.get(
      Uri.parse('https://brotherhackathon-dev-ed.my.salesforce.com/services/data/v42.0/query/?q=SELECT+id,PhotoUrl,name,FirstName,LastName,MailingStreet,MailingCity,MailingState,MailingPostalCode+from+Contact'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      }
    );
    if(response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      if(jsonResponse.containsKey('records')) {
        final contacts = jsonResponse['records']
            .map<SalesForceContact>(
            (contact) => SalesForceContact.fromMap(contact)).toList();
        return contacts;
      }
      else {
        throw Exception('No contacts found');
      }
    }
    else {
      throw Exception('Failed to load contacts');
    }
  }
}