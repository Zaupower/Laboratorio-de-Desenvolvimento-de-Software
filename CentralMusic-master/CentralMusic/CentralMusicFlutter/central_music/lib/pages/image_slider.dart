import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImageSliderDemo extends StatelessWidget {
  List<String> imgList;
  ImageSliderDemo(List<String> imgList) : this.imgList = imgList ?? [];


  @override
  Widget build(BuildContext context) {

    return  Container(
          child: CarouselSlider(
            options: CarouselOptions(),
            items: imgList.map((item) => Container(
              padding: EdgeInsets.only(top: 30.0, left: 4, right: 4, bottom: 4),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(item,
                          fit: BoxFit.fill,
                          width: 500,
                        height: 600,
                      ),
                  ),

            )).toList(),
          )
      );
  }
}
