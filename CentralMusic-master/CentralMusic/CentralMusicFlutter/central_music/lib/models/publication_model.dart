import 'dart:convert';

import 'address.dart';

List<Publication> publicatioFromJson(String str) => List<Publication>.from(json.decode(str).map((x) => Publication.fromJson(x)));

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
    this.localization,
    this.imagePath
  });

  int id;
  int utilizadorId;
  String tittle;
  String description;
  bool tradable;
  String category;
  int initialPrice;
  String instrumentCondition;
  Address localization;
  int imagePath;

  factory Publication.fromJson(Map<String, dynamic> json) => Publication(
    id: json["id"],
    utilizadorId: json["utilizadorId"],
    tittle: json["tittle"],
    description: json["description"],
    tradable: json["tradable"],
    category: json["category"],
    initialPrice: json["initialPrice"],
    imagePath: json["imagePath"],
    instrumentCondition: json["instrumentCondition"],
    localization: Address.fromJson(json["localization"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "utilizadorId": utilizadorId,
    "tittle": tittle,
    "description": description,
    "tradable": tradable,
    "category": category,
    "initialPrice": initialPrice,
    "imagePath" : imagePath,
    "instrumentCondition": instrumentCondition,
    "userAddress": localization.toJson(),
  };
}