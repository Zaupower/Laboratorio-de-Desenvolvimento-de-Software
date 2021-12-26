class ProfileModel {
  int id;
  String firstName;
  String lastName;
  String address;

  ProfileModel({this.id, this.firstName, this.lastName, this.address});

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json["id"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      address: json["address"],
    );
  }
}
