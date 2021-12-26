import 'address.dart';

class UserEdit {
  final String email;
  final String firstName;
  final String lastName;
  final Address localization;

  UserEdit({
    this.email,
    this.firstName,
    this.lastName,
    this.localization});

  factory UserEdit.fromJson(Map<String, dynamic> json) {
    return UserEdit(
        email: json["email"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        localization: Address.fromJson(json["localization"]));
  }
}