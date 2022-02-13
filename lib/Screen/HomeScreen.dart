import 'package:blogapp/Blog/Blogs.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffEEEEFF),
      body: SingleChildScrollView(
        child: Blogs(
          url: "blogpost/getOtherBlog",
          isOwnBlog: false,
        ),
      ),
    );
  }
}
