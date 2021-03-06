import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:rail_lens/consta.dart';

class ViewImage extends StatelessWidget {
  List<Image> FullImage;
  int index;
  var doaminname;
  var indices = new List();
  ViewImage(this.FullImage, this.index,this.doaminname);

  @override
  Widget build(BuildContext context) {
    print("reached build");
    for (int i = index; i < FullImage.length; i++) {
      indices.add(i);
    }

    for (int i = index - 1; i > 0; i--) {
      indices.add(i);
    }
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[],
        backgroundColor:Colors.grey[300],
        title: Text(doaminname,style: TextStyle(color: consta.color1),),
        elevation: 0,
        iconTheme: IconThemeData(color: consta.color1),

        
      ),
      backgroundColor: Colors.grey[300],
      body: Container(
        child: Center(
          child: CarouselSlider(
            height: 400.0,
            enableInfiniteScroll: false,
            initialPage: index,
            items: FullImage.map(
              (i) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      height: 200,
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(),
                      child: i,
                    );
                  },
                );
              },
            ).toList(),
          ),
        ),
      ),
    );
  }
}
