import 'dart:convert';

import 'package:central_music/enums/categories.dart';
import 'package:central_music/enums/condition.dart';

import 'address.dart';
List<PublicationUpdate> publicationCreateFromJson(String str) => List<PublicationUpdate>.from(json.decode(str).map((x) => PublicationUpdate.fromJson(x)));
class PublicationUpdate {
  final int id;
  final int utilizadorId;
  final String tittle;
  final String description;
  final bool tradable;
  final Categories category;
  final int imagePath;
  final int initialPrice;
  final Conditions instrumentCondition;
  final Address localization;

  PublicationUpdate({
    this.id,
    this.utilizadorId,
    this.tittle,
    this.description,
    this.tradable,
    this.category,
    this.imagePath,
    this.initialPrice,
    this.instrumentCondition,
    this.localization});

  factory PublicationUpdate.fromJson(Map<String, dynamic> json) {
    return PublicationUpdate(
        id: json["id"],
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
