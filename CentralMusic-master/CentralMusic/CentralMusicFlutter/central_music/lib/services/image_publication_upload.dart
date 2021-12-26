import 'dart:convert';
import 'dart:typed_data';
import 'package:central_music/helpers/storage_helper.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class ImagePublicationServices {
  static Future<List<bool>> postImagesPublications(
      int id, List<Asset> images, Asset mainImage) async {
    String url =
        "https://10.0.2.2:5001/api/Publication/UpdateImagePublication?id=$id";
    String token = await StorageHelper.readToken();

    final imagesBytes = {};
    List<MultipartFile> multipartImageList = new List<MultipartFile>();
    if (null != images) {
      //Add all list to new list
      for (Asset asset in images) {
        ByteData byteData = await asset.getByteData();
        List<int> imageData = byteData.buffer.asUint8List();
        MultipartFile multipartFile = new MultipartFile.fromBytes(
          'images',
          imageData,
          filename: 'loaimage',
        );
        multipartImageList.add(multipartFile);
      }

      //MainImage
      ByteData bD = await mainImage.getByteData();
      List<int> imgD = bD.buffer.asUint8List();
      MultipartFile multipartFile = new MultipartFile.fromBytes(
        'mainImage',
        imgD,
        filename: 'loadimage2',
      );
      //Main image

      var request = http.MultipartRequest('POST', Uri.parse(url));

      request.headers['Content-Type'] = 'application/json';
      request.headers['Accept'] = 'application/json';
      request.headers['Authorization'] = 'Bearer $token';
      request.files.addAll(multipartImageList);
      request.files.add(multipartFile);

      var response = await request.send();
      if (response.statusCode == 200) {
        print("Image Uploaded");
      } else {
        print("Upload Failed");
      }
      response.stream.transform(utf8.decoder).listen((value) {
        print(value);
      });
    }
  }

  static Future<List<bool>> addImageProfile(Asset mainImage) async {
    String url = "https://10.0.2.2:5001/api/User/UploadProfilePic";
    String token = await StorageHelper.readToken();

    final imagesBytes = {};
    List<MultipartFile> multipartImageList = new List<MultipartFile>();

    //MainImage
    ByteData bD = await mainImage.getByteData();
    List<int> imgD = bD.buffer.asUint8List();
    MultipartFile multipartFile = new MultipartFile.fromBytes(
      'profilePic',
      imgD,
      filename: 'loadimage2',
    );
    //Main image

    var request = http.MultipartRequest('POST', Uri.parse(url));

    request.headers['Content-Type'] = 'application/json';
    request.headers['Accept'] = 'application/json';
    request.headers['Authorization'] = 'Bearer $token';
    request.files.add(multipartFile);

    var response = await request.send();
    if (response.statusCode == 200) {
      print("Image Uploaded");
    } else {
      print("Upload Failed");
    }
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
  }
}
