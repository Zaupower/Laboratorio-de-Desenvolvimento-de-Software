class ForgotPassword {
  final String email;

  ForgotPassword({this.email});

  factory ForgotPassword.fromJson(Map<String, dynamic> json) {
    return ForgotPassword(email: json["email"]);
  }
}