import 'dart:io';

import 'package:blogapp/Model/addBlogModels.dart';
import 'package:blogapp/networkapi/NetworkHandler.dart';
import 'package:blogapp/Screen/Profile/MainProfile.dart';
import 'package:blogapp/pages/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class BlogCard extends StatelessWidget {
  //final AddBlogModel addBlogModel;
  final NetworkHandler networkHandler;
  final bool isOwnBlog;
  var addBlogModel;

  BlogCard(
      {this.addBlogModel,
      required this.networkHandler,
      required this.isOwnBlog});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      padding: EdgeInsets.symmetric(horizontal: 13, vertical: 8),
      width: MediaQuery.of(context).size.width,
      child: Card(
        child: Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                image: DecorationImage(
                    image:
                        NetworkImage(networkHandler.getImage(addBlogModel.id)),
                    fit: BoxFit.fill),
              ),
            ),
            Positioned(
              left: 10,
              bottom: 5,
              child: Container(
                //margin: EdgeInsets.only(right: 30, left: 30),
                padding: EdgeInsets.all(20),
                height: 60,
                width: MediaQuery.of(context).size.width - 50,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8)),
                child: Text(
                  addBlogModel.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            if (isOwnBlog)
              Positioned(
                  top: 20,
                  right: 20,
                  child: InkWell(
                    onTap: () async {
                      var response = await networkHandler
                          .delete("blogpost/delete/${addBlogModel.id}");
                      if (response.statusCode == 200) {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => HomePage()),
                            (route) => false);
                      }
                    },
                    child: CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.black,
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                        )),
                  ))
          ],
        ),
      ),
    );
  }
}
