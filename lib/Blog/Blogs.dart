import 'package:blogapp/Blog/Blog.dart';
import 'package:blogapp/CustomWidget/BlogCard.dart';

import 'package:blogapp/Model/SuperModel.dart';

import 'package:blogapp/networkapi/NetworkHandler.dart';
import 'package:flutter/material.dart';

class Blogs extends StatefulWidget {
  final String url;
  final bool isOwnBlog;
  Blogs({required this.url, required this.isOwnBlog});

  @override
  _BlogsState createState() => _BlogsState();
}

class _BlogsState extends State<Blogs> {
  NetworkHandler networkHandler = NetworkHandler();
  SuperModel superModel = SuperModel(data: []);
  List data = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  void deleteBlog(String id) {
    setState(() {
      data.removeWhere((element) => element.id == id);
    });
  }

  void fetchData() async {
    var response = await networkHandler.get(widget.url);
    if (response["status"]) {
      superModel = SuperModel.fromJson(response);

      setState(() {
        data = superModel.data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return data.length > 0
        ? Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: data.length,
              itemBuilder: (context, i) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (contex) => Blog(
                                  addBlogModel: data[i],
                                  networkHandler: networkHandler,
                                )));
                  },
                  child: BlogCard(
                    addBlogModel: data[i],
                    networkHandler: networkHandler,
                    isOwnBlog: widget.isOwnBlog,
                    deleteBlog: deleteBlog,
                  ),
                );
              },
            ),
          )
        // Column(
        //     children: data
        //         .map((item) => Column(
        //               children: <Widget>[
        //                 InkWell(
        //                   onTap: () {

        //                     Navigator.push(
        //                         context,
        //                         MaterialPageRoute(
        //                             builder: (contex) => Blog(
        //                                   addBlogModel: item,
        //                                   networkHandler: networkHandler,
        //                                 )));
        //                   },
        //                   child: BlogCard(
        //                     addBlogModel: item,
        //                     networkHandler: networkHandler,
        //                     isOwnBlog: widget.isOwnBlog,
        //                   ),
        //                 ),
        //                 SizedBox(
        //                   height: 0,
        //                 ),
        //               ],
        //             ))
        //         .toList(),
        //   )
        : Center(
            child: Text("We don't have any Blog Yet"),
          );
  }
}
