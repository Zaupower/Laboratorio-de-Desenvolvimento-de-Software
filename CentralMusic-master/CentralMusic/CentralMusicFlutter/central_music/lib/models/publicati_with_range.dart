import 'dart:convert';

import 'package:central_music/enums/categories.dart';
import 'package:central_music/enums/condition.dart';

import 'address.dart';


List<PublicationWithRange> publicationWRFromJson(String str) => List<PublicationWithRange>.from(json.decode(str).map((x) => PublicationWithRange.fromJson(x)));

String publicationWRToJson(List<PublicationWithRange> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PublicationWithRange {

  PublicationWithRange({
    this.id,
    this.utilizadorId,
    this.tittle,
    this.description,
    this.tradable,
    this.category,
    this.initialPrice,
    this.instrumentCondition,
    this.userAddress,
    this.imagePath,
    this.range
  });

  int id;
  int utilizadorId;
  String tittle;
  String description;
  bool tradable;
  String category;
  int initialPrice;
  String instrumentCondition;
  Address userAddress;
  int imagePath;
  int range;

  factory PublicationWithRange.fromJson(Map<String, dynamic> json) => PublicationWithRange(
    id: json["id"],
    utilizadorId: json["utilizadorId"],
    tittle: json["tittle"],
    description: json["description"],
    tradable: json["tradable"],
    category: json["category"],
    initialPrice: json["initialPrice"],
    imagePath: json["imagePath"],
    instrumentCondition: json["instrumentCondition"],
    userAddress: Address.fromJson(json["userAddress"]),
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
    "imagePath" : imagePath,
    "instrumentCondition": instrumentCondition,
    "userAddress": userAddress.toJson(),
    "range": range,
  };
}