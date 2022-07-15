// To parse this JSON data, do
//
//     final salesForceContact = salesForceContactFromMap(jsonString);

import 'dart:convert';

class SalesForceContact {
  SalesForceContact({
    this.id,
    this.name,
    this.firstName,
    this.lastName,
    this.mailingStreet,
    this.mailingCity,
    this.mailingState,
    this.mailingPostalCode,
  });

  String? id;
  String? name;
  String? firstName;
  String? lastName;
  String? mailingStreet;
  String? mailingCity;
  String? mailingState;
  String? mailingPostalCode;

  factory SalesForceContact.fromJson(String str) => SalesForceContact.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SalesForceContact.fromMap(Map<String, dynamic> json) => SalesForceContact(
    id: json["Id"],
    name: json["Name"],
    firstName: json["FirstName"],
    lastName: json["LastName"],
    mailingStreet: json["MailingStreet"],
    mailingCity: json["MailingCity"],
    mailingState: json["MailingState"],
    mailingPostalCode: json["MailingPostalCode"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "firstName": firstName,
    "lastName": lastName,
    "mailingStreet": mailingStreet,
    "mailingCity": mailingCity,
    "mailingState": mailingState,
    "mailingPostalCode": mailingPostalCode,
  };
}