import 'package:blogapp/Blog/Blog.dart';
import 'package:blogapp/Blog/Blogs.dart';
import 'package:blogapp/Model/profileModel.dart';
import 'package:blogapp/networkapi/NetworkHandler.dart';
import 'package:blogapp/Screen/Profile/EditProfile.dart';
import 'package:flutter/material.dart';
import 'package:blogapp/Blog/Blog.dart';

class MainProfile extends StatefulWidget {
  @override
  _MainProfileState createState() => _MainProfileState();
}

class _MainProfileState extends State<MainProfile> {
  bool circular = true;
  NetworkHandler networkHandler = NetworkHandler();
  late ProfileModel profileModel;
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    var response = await networkHandler.get("profile/getData");
    setState(() {
      profileModel = ProfileModel.fromJson(response["data"]);
      //print("Profile Model ${response["data"]}");
      circular = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffEEEEFF),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white10,
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back),
        //   onPressed: () {},
        //   color: Colors.black,
        // ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditProfile(
                            name: profileModel.name,
                            username: profileModel.username,
                            profession: profileModel.profession,
                            DOB: profileModel.DOB,
                            titleline: profileModel.titleline,
                            about: profileModel.about,
                            img: profileModel.img,
                          )));
            },
            color: Colors.black,
          ),
        ],
      ),
      body: circular
          ? Center(child: CircularProgressIndicator())
          : ListView(
              children: <Widget>[
                if (profileModel.img == "") head("null"),
                if (profileModel.img != "")
                  head(NetworkHandler().getImage(profileModel.username)),
                Divider(
                  thickness: 0.8,
                ),
                otherDetails("Name", profileModel.name),
                otherDetails("About", profileModel.about),
                otherDetails("Profession", profileModel.profession),
                otherDetails("DOB", profileModel.DOB),
                Divider(
                  thickness: 0.8,
                ),
                SizedBox(
                  height: 20,
                ),
                Blogs(
                  url: "blogpost/getOwnBlog",
                  isOwnBlog: true,
                ),
              ],
            ),
    );
  }

  Widget head(String imageUrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          imageUrl != "null"
              ? Center(
                  child: CircleAvatar(
                      radius: 50, backgroundImage: NetworkImage(imageUrl)),
                )
              : Center(
                  child: CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage("assets/defaultprofile.jpg")),
                ),
          Text(
            profileModel.username,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          Text(profileModel.titleline)
        ],
      ),
    );
  }

  Widget otherDetails(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "$label :",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            value,
            style: TextStyle(fontSize: 15),
          )
        ],
      ),
    );
  }
}
