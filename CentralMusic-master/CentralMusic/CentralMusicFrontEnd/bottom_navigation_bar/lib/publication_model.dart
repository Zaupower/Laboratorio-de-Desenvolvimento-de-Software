
import 'dart:convert';

import 'package:bottom_navigation_bar/user_address_model.dart';

List<Publication> publicationFromJson(String str) => List<Publication>.from(json.decode(str).map((x) => Publication.fromJson(x)));

String publicationToJson(List<Publication> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Publication {
  Publication({
    this.id,
    this.utilizadorId,
    this.tittle,
    this.description,
    this.tradable,
    this.category,
    this.initialPrice,
    this.instrumentCondition,
    this.userAddress,
    this.range,
  });

  int id;
  int utilizadorId;
  String tittle;
  String description;
  bool tradable;
  String category;
  int initialPrice;
  String instrumentCondition;
  UserAddress userAddress;
  int range;

  factory Publication.fromJson(Map<String, dynamic> json) => Publication(
    id: json["id"],
    utilizadorId: json["utilizadorId"],
    tittle: json["tittle"],
    description: json["description"],
    tradable: json["tradable"],
    category: json["category"],
    initialPrice: json["initialPrice"],
    instrumentCondition: json["instrumentCondition"],
    userAddress: UserAddress.fromJson(json["userAddress"]),
    range: json["range"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "utilizadorId": utilizadorId,
    "tittle": tittle,
    "description": description,
    "tradable": tradable,
    "category": category,
    "initialPrice": initialPrice,
    "instrumentCondition": instrumentCondition,
    "userAddress": userAddress.toJson(),
    "range": range,
  };
}