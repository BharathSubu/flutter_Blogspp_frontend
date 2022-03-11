import 'package:blogapp/Blog/Blogs.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isdata = false;
  bool onsearch = false;
  TextEditingController vechieleNo = TextEditingController();
  getdata() {
    if (vechieleNo.text == "001") {
      setState(() {
        isdata = true;
      });
    } else {
      setState(() {
        isdata = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffEEEEFF),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                margin:
                    EdgeInsets.only(bottom: 20, right: 30, left: 30, top: 30),
                child: SearchInput(
                  textController: vechieleNo,
                  hintText: "Enter VechileNo woth no space",
                  onPressed: () {
                    if (vechieleNo.text != "") {
                      getdata();
                      setState(() {
                        onsearch = true;
                      });
                    }
                    ;
                  },
                ),
              ),
              if (onsearch)
                isdata
                    ? Column(
                        children: [
                          SizedBox(height: 10),
                          InvertedButtonFb2(
                              text: "Vehile Info", onPressed: () {}),
                          SizedBox(height: 10),
                          Vehicleinfo(
                            chase_no: "100",
                            speed: "100kmn/hr",
                            model: "SUV",
                            enginee_number: "001",
                            color: "silver",
                            location: "Chennai",
                          ),
                          SizedBox(height: 10),
                          InvertedButtonFb2(
                              text: "Employee Info", onPressed: () {}),
                          SizedBox(height: 10),
                          DriverInfo(
                            Phoneno: "9933556612",
                            driver_name: "Vinoth",
                            working_hours: "9am - 11pm",
                            alcohol_rate: "Low",
                            alcoho_consumption: "No",
                            drowsiness: "No",
                          )
                        ],
                      )
                    : CardFb1(
                        text: "No Data Found",
                        path: 'assets/notfound.png',
                      )
            ],
          ),
        ));
  }
}

class SearchInput extends StatelessWidget {
  final TextEditingController textController;
  final Function() onPressed;
  final String hintText;
  const SearchInput(
      {required this.textController,
      required this.hintText,
      required this.onPressed,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            offset: const Offset(12, 26),
            blurRadius: 50,
            spreadRadius: 0,
            color: Colors.grey.withOpacity(.1)),
      ]),
      child: TextField(
        controller: textController,
        onChanged: (value) {
          //Do something wi
        },
        decoration: InputDecoration(
          prefixIcon: InkWell(
            onTap: onPressed,
            child: const Icon(
              Icons.search,
              color: Color(0xff4338CA),
            ),
          ),
          filled: true,
          fillColor: Colors.white,
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 2.0),
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
        ),
      ),
    );
  }
}

class Vehicleinfo extends StatelessWidget {
  final String enginee_number;
  final String chase_no;
  final String color;
  final String model;
  final String speed;
  final String location;
  const Vehicleinfo(
      {Key? key,
      required this.enginee_number,
      required this.chase_no,
      required this.color,
      required this.model,
      required this.speed,
      required this.location})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: 230,
      padding: const EdgeInsets.all(30.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.5),
        boxShadow: [
          BoxShadow(
              offset: const Offset(10, 20),
              blurRadius: 10,
              spreadRadius: 0,
              color: Colors.grey.withOpacity(.05)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Enginee_Number : ${enginee_number}",
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              )),
          Text("Chase no : ${chase_no}",
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              )),
          Text("Color : ${color}",
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              )),
          Text("Model: ${model}",
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              )),
          Text("Speed : ${speed}",
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              )),
          Text("Location : ${location}",
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              )),
        ],
      ),
    );
  }
}

class DriverInfo extends StatelessWidget {
  final String driver_name;
  final String Phoneno;
  final String working_hours;
  final String alcoho_consumption;
  final String alcohol_rate;
  final String drowsiness;
  const DriverInfo(
      {Key? key,
      required this.driver_name,
      required this.Phoneno,
      required this.working_hours,
      required this.alcoho_consumption,
      required this.alcohol_rate,
      required this.drowsiness})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: 230,
      padding: const EdgeInsets.all(30.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.5),
        boxShadow: [
          BoxShadow(
              offset: const Offset(10, 20),
              blurRadius: 10,
              spreadRadius: 0,
              color: Colors.grey.withOpacity(.05)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text("Name : ${driver_name}",
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              )),
          Text("Phone : ${Phoneno}",
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              )),
          Text("Hours : ${working_hours}",
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              )),
          Text("Alcohol Consumption: ${alcoho_consumption}",
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              )),
          Text("Alcohol Rate : ${alcohol_rate}",
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              )),
          Text("Drowsiness : ${drowsiness}",
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              )),
        ],
      ),
    );
  }
}

class CardFb1 extends StatelessWidget {
  final String text;
  final String path;
  const CardFb1({required this.text, required this.path, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 230,
      padding: const EdgeInsets.all(30.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.5),
        boxShadow: [
          BoxShadow(
              offset: const Offset(10, 20),
              blurRadius: 10,
              spreadRadius: 0,
              color: Colors.grey.withOpacity(.05)),
        ],
      ),
      child: Column(
        children: [
          Text(text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              )),
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 120,
            width: 120,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(path),
                fit: BoxFit.fill,
              ),
              shape: BoxShape.circle,
            ),
          )
        ],
      ),
    );
  }
}

class InvertedButtonFb2 extends StatelessWidget {
  final String text;
  final Function() onPressed;
  InvertedButtonFb2({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xff4338CA);

    return OutlinedButton(
      style: ButtonStyle(
          elevation: MaterialStateProperty.all(0),
          alignment: Alignment.center,
          side: MaterialStateProperty.all(
              const BorderSide(width: 1, color: primaryColor)),
          padding: MaterialStateProperty.all(const EdgeInsets.only(
              right: 75, left: 75, top: 12.5, bottom: 12.5)),
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0)))),
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(color: primaryColor, fontSize: 16),
      ),
    );
  }
}
