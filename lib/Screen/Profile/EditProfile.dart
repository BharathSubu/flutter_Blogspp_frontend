import 'dart:io';
import 'dart:async';
import 'package:blogapp/networkapi/NetworkHandler.dart';
import 'package:blogapp/Pages/HomePage.dart';
import 'package:blogapp/Screen/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class EditProfile extends StatefulWidget {
  final String name, username, profession, DOB, titleline, about, img;
  EditProfile({
    required this.name,
    required this.username,
    required this.profession,
    required this.DOB,
    required this.titleline,
    required this.about,
    required this.img,
  });
  //const EditProfile ({ Key? key, required this.name,required this.username, required this.profession,
  // required this.DOB,required this.titleline,required this.about,required this.img }) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final networkHandler = NetworkHandler();
  bool circular = false;
  final ImagePicker _picker = ImagePicker();
  //late PickedFile _imageFile;
  File? _imageFile;
  final _globalkey = GlobalKey<FormState>();

  late TextEditingController _name = TextEditingController(text: widget.name);
  late TextEditingController _profession =
      TextEditingController(text: widget.profession);
  late String date = widget.DOB;
  late TextEditingController _title =
      TextEditingController(text: widget.titleline);
  late TextEditingController _about = TextEditingController(text: widget.about);
  var selectedDate;

  void _presentDatePicker() {
    DateFormat dateFormat = DateFormat("dd-MM-yyyy");

    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1930),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        selectedDate = pickedDate;
        date = dateFormat.format(selectedDate);
        print("Selected Date : ${date}");
      });
    });
    print('...');
  }

  @override
  Widget build(BuildContext context) {
    String webimagepath = widget.img;
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => HomePage()),
            (route) => false);
        return Future.value(false);
      },
      child: Scaffold(
        body: Form(
          key: _globalkey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            children: <Widget>[
              imageProfile(webimagepath),
              SizedBox(
                height: 20,
              ),
              nameTextField(),
              SizedBox(
                height: 20,
              ),
              professionTextField(),
              SizedBox(
                height: 20,
              ),
              dobField(),
              SizedBox(
                height: 20,
              ),
              titleTextField(),
              SizedBox(
                height: 20,
              ),
              aboutTextField(),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () async {
                  if (_globalkey.currentState!.validate() && date != "NULL") {
                    setState(() {
                      circular = true;
                    });
                    Map<String, String> data = {
                      "name": _name.text,
                      "profession": _profession.text,
                      "DOB": date,
                      "titleline": _title.text,
                      "about": _about.text,
                    };
                    var response =
                        await networkHandler.patch("profile/update", data);
                    print("Data  ${data}");
                    //print("Response ---  ${response}");
                    if (response.statusCode == 200 ||
                        response.statusCode == 201) {
                      print("Response  ${response}");
                      if (_imageFile == null) {
                        print("Image Not uploaded ");
                        setState(() {
                          circular = false;
                        });
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => HomePage()),
                            (route) => false);
                      }
                      if (_imageFile != null) {
                        var imageResponse = await networkHandler.patchImage(
                            "profile/add/image", _imageFile!.path);
                        if (imageResponse.statusCode == 200) {
                          print("Image upload successful");
                          setState(() {
                            circular = false;
                          });
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => HomePage()),
                              (route) => false);
                        }
                      } else {
                        setState(() {
                          circular = false;
                        });
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => HomePage()),
                            (route) => false);
                      }
                    }
                  }
                },
                child: Center(
                  child: Container(
                    width: 200,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: circular
                          ? CircularProgressIndicator()
                          : Text(
                              "Submit",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget imageProfile(String webimagepath) {
    return Center(
      child: Stack(children: <Widget>[
        _imageFile != null
            ? CircleAvatar(
                radius: 80.0,
                backgroundImage: Image.file(
                  _imageFile!,
                  fit: BoxFit.cover,
                ).image)
            : webimagepath == ""
                ? CircleAvatar(
                    radius: 80.0,
                    backgroundImage: AssetImage("assets/defaultprofile.jpg"))
                : CircleAvatar(
                    radius: 80.0,
                    backgroundImage: NetworkImage(
                        NetworkHandler().getImage(widget.username))),
        Positioned(
            bottom: 20.0,
            right: 20.0,
            child: InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: ((builder) => bottomSheet()),
                );
              },
              child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.teal,
                  child: Icon(
                    Icons.camera_enhance,
                    color: Colors.white,
                  )),
            )),
        if (webimagepath != "")
          Positioned(
              bottom: 20.0,
              left: 20.0,
              child: InkWell(
                onTap: () async {
                  var response =
                      await networkHandler.delete('user/deletephoto');
                  if (response.statusCode == 200) {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditProfile(
                                  name: widget.name,
                                  username: widget.username,
                                  profession: widget.profession,
                                  DOB: widget.DOB,
                                  titleline: widget.titleline,
                                  about: widget.about,
                                  img: "",
                                )),
                        (route) => false);
                  }
                },
                child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.teal,
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    )),
              ))
      ]),
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          Text(
            "Choose Profile photo",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.camera),
              onPressed: () {
                takePhoto(ImageSource.camera);
              },
              label: Text("Camera"),
            ),
            FlatButton.icon(
              icon: Icon(Icons.image),
              onPressed: () {
                takePhoto(ImageSource.gallery);
              },
              label: Text("Gallery"),
            ),
          ])
        ],
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    final pickedImage = await _picker.pickImage(source: source);
    if (pickedImage == null) return;
    final imageTemporary = File(pickedImage.path);
    setState(() => {_imageFile = imageTemporary});
  }

  Widget nameTextField() {
    return TextFormField(
      controller: _name,
      validator: (value) {
        if (value!.isEmpty) return "Name can't be empty";

        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.teal,
        )),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.orange,
          width: 2,
        )),
        prefixIcon: Icon(
          Icons.person,
          color: Colors.green,
        ),
        labelText: "Name",
        helperText: "Name can't be empty",
        hintText: "Your Name",
      ),
    );
  }

  Widget professionTextField() {
    return TextFormField(
      controller: _profession,
      validator: (value) {
        if (value!.isEmpty) return "Profession can't be empty";

        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.teal,
        )),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.orange,
          width: 2,
        )),
        prefixIcon: Icon(
          Icons.person,
          color: Colors.green,
        ),
        labelText: "Profession",
        helperText: "Profession can't be empty",
        hintText: "Your Profession",
      ),
    );
  }

  Widget dobField() {
    return Container(
      height: 70,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              selectedDate == null
                  ? widget.DOB
                  : 'Event Date: ${DateFormat('dd-MM-yyyy').format(selectedDate)}',
            ),
          ),
          RaisedButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Text(
              'Choose Date',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
            onPressed: _presentDatePicker,
          ),
        ],
      ),
    );
    // return TextFormField(
    //   controller: _dob,
    //   validator: (value) {
    //     if (value!.isEmpty) return "DOB can't be empty";
    //     return null;
    //   },
    //   decoration: InputDecoration(
    //     border: OutlineInputBorder(
    //         borderSide: BorderSide(
    //       color: Colors.teal,
    //     )),
    //     focusedBorder: OutlineInputBorder(
    //         borderSide: BorderSide(
    //       color: Colors.orange,
    //       width: 2,
    //     )),
    //     prefixIcon: Icon(
    //       Icons.person,
    //       color: Colors.green,
    //     ),
    //     labelText: "Date Of Birth",
    //     helperText: "Provide DOB on dd/mm/yyyy",
    //     hintText: "01/01/2020",
    //   ),
    // );
  }

  Widget titleTextField() {
    return TextFormField(
      controller: _title,
      validator: (value) {
        if (value!.isEmpty) return "Title can't be empty";

        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.teal,
        )),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.orange,
          width: 2,
        )),
        prefixIcon: Icon(
          Icons.person,
          color: Colors.green,
        ),
        labelText: "Title",
        helperText: "It can't be empty",
        hintText: "Flutter Developer",
      ),
    );
  }

  Widget aboutTextField() {
    return TextFormField(
      controller: _about,
      validator: (value) {
        if (value!.isEmpty) return "About can't be empty";

        return null;
      },
      maxLines: 4,
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.teal,
        )),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.orange,
          width: 2,
        )),
        labelText: "About",
        helperText: "Write about yourself",
        hintText: "I am Dev Stack",
      ),
    );
  }
}
