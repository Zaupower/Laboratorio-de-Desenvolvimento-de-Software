import 'dart:convert';

import 'package:central_music/enums/categories.dart';
import 'package:central_music/enums/condition.dart';

import 'address.dart';
List<AddPhotoModel> addPhotoFromJson(String str) => List<AddPhotoModel>.from(json.decode(str).map((x) => AddPhotoModel.fromJson(x)));
class AddPhotoModel {
  final int imagePath;

  AddPhotoModel({
    this.imagePath});

  factory AddPhotoModel.fromJson(Map<String, dynamic> json) {
    return AddPhotoModel(
        imagePath: json["imagePath"]);
  }
}