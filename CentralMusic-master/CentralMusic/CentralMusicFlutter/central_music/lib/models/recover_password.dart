class RecoverPassword {
  final String email;
  final String password;
  final String confirmPassword;
  final String token;

  RecoverPassword({
    this.email,
    this.password,
    this.confirmPassword,
    this.token});

  factory RecoverPassword.fromJson(Map<String, dynamic> json) {
    return RecoverPassword(
      email: json["email"],
      password: json["password"],
      confirmPassword: json["confirmPassword"],
      token: json["token"]);
  }
}