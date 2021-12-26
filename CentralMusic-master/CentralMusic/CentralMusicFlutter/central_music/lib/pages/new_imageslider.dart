import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class ImageSliderDemo2 extends StatelessWidget {
  List<Asset> imgList;
  ImageSliderDemo2(List<Asset> imgList) : this.imgList = imgList ?? [];
  @override
  Widget build(BuildContext context) {
    Prr();
    return  Container(
          child: CarouselSlider(
            options: CarouselOptions(),
            items: imgList.map((item) => Container(
              child: Center(

                  child: Image.asset("multi_image_picker/image/"+item.identifier, fit: BoxFit.fitWidth, width: 1000)
              ),
            )).toList(),
          )
      );
  }

  void Prr(){
    if(!imgList.isEmpty){
      print(imgList[0].identifier);
    }else{
      print("Deu empty");
    }

  }
}