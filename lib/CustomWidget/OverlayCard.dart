import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class OverlayCard extends StatelessWidget {
  File? imagefile;
  final String title;
  OverlayCard({
    required this.imagefile,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: EdgeInsets.all(5),
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: FileImage(
                    File(imagefile!.path),
                  ),
                  fit: BoxFit.fitWidth),
            ),
          ),
          Positioned(
            bottom: 2,
            child: Container(
              padding: EdgeInsets.all(8),
              height: 55,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(8)),
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
