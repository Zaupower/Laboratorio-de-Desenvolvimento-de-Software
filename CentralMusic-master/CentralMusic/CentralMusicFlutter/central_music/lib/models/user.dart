class User {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String localization;
  final String image;

  User({
    this.id,
    this.email,
    this.firstName,
    this.lastName,
    this.localization,
    this.image});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toInt(),
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      localization: json['localization'],
      image: json['image']);
  }
}