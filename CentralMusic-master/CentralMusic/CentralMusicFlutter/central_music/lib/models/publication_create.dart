import 'dart:convert';

import 'package:central_music/enums/categories.dart';
import 'package:central_music/enums/condition.dart';

import 'address.dart';
List<PublicationCreate> publicationCreateFromJson(String str) => List<PublicationCreate>.from(json.decode(str).map((x) => PublicationCreate.fromJson(x)));
class PublicationCreate {
  final int utilizadorId;
  final String tittle;
  final String description;
  final bool tradable;
  final Categories category;
  final int imagePath;
  final int initialPrice;
  final Conditions instrumentCondition;
  final Address localization;

  PublicationCreate({
    this.utilizadorId,
    this.tittle,
    this.description,
    this.tradable,
    this.category,
    this.imagePath,
    this.initialPrice,
    this.instrumentCondition,
    this.localization});

  factory PublicationCreate.fromJson(Map<String, dynamic> json) {
    return PublicationCreate(
        utilizadorId: json["utilizadorId"],
        tittle: json["tittle"],
        description: json["description"],
        tradable: json["tradable"],
        category: json["category"],
        imagePath: json["imagePath"],
        initialPrice: json["initialPrice"],
        instrumentCondition: json["instrumentCondition"],
        localization: Address.fromJson(json["localization"]));
  }
}