class Login {
  final String email;
  final String password;

  Login({
    this.email,
    this.password});

  factory Login.fromJson(Map<String, dynamic> json) {
    return Login(
      email: json["email"],
      password: json["password"]);
  }
}