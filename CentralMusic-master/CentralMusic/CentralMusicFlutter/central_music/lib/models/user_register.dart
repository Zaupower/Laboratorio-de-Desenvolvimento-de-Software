import 'package:central_music/models/address.dart';

class UserRegister {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final Address localization;

  UserRegister({
    this.email,
    this.password,
    this.firstName,
    this.lastName,
    this.localization});

  factory UserRegister.fromJson(Map<String, dynamic> json) {
    return UserRegister(
      email: json["email"],
      password: json["password"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      localization: Address.fromJson(json["localization"]));
  }
}