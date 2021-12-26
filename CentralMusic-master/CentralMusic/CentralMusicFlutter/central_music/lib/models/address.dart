class Address {
  String street;
  int streetNumber;
  String postalCode;
  String district;
  String country;

  Address({
    this.street,
    this.streetNumber,
    this.postalCode,
    this.district,
    this.country,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    street: json["street"],
    streetNumber: json["streetNumber"],
    postalCode: json["postalCode"],
    district: json["district"],
    country: json["country"],
  );

  @override
  String toString() {
    return '$street, Nº$streetNumber $postalCode $district, $country';
  }

  Map<String, dynamic> toJson() => {
    "street": street,
    "streetNumber": streetNumber,
    "postalCode": postalCode,
    "district": district,
    "country": country,
  };
}