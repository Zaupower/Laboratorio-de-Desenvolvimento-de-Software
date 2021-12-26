class UserAddress {
  UserAddress({
    this.street,
    this.streetNumber,
    this.postalCode,
    this.district,
    this.country,
  });

  String street;
  int streetNumber;
  String postalCode;
  String district;
  String country;

  factory UserAddress.fromJson(Map<String, dynamic> json) => UserAddress(
    street: json["street"],
    streetNumber: json["streetNumber"],
    postalCode: json["postalCode"],
    district: json["district"],
    country: json["country"],
  );

  Map<String, dynamic> toJson() => {
    "street": street,
    "streetNumber": streetNumber,
    "postalCode": postalCode,
    "district": district,
    "country": country,
  };
}
