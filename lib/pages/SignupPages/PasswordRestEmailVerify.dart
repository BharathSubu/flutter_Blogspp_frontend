import 'dart:async';
import 'dart:convert';
import 'package:blogapp/networkapi/NetworkHandler.dart';
import 'package:blogapp/Pages/HomePage.dart';
import 'package:blogapp/Pages/SignupPages/auth.config.dart';
import 'package:blogapp/pages/SignupPages/ForgetPassword.dart';
import 'package:blogapp/pages/SignupPages/SignInpage.dart';
import 'package:blogapp/pages/SignupPages/SignUpPage.dart';
import "package:flutter/material.dart";
import 'package:email_auth/email_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PasswordResetEmailVerify extends StatefulWidget {
  @override
  _PasswordResetEmailVerifyState createState() =>
      _PasswordResetEmailVerifyState();
}

class _PasswordResetEmailVerifyState extends State<PasswordResetEmailVerify> {
  late EmailAuth emailAuth;
  bool submitValid = false;
  bool isotptrue = false;
  bool vis = true;
  final _globalkey = GlobalKey<FormState>();
  NetworkHandler networkHandler = NetworkHandler();

  //networkHandler to work with crude operation
  TextEditingController _emailverifyController = TextEditingController();
  TextEditingController _otpverifyController = TextEditingController();

  String errorText = ""; //to check for unique user name
  bool validate = false; //as boolen type
  bool circular = false; //to show circular bar instead of circular
  bool isEmailExist = false;
  String username = "";

  late Timer _timer;
  int _start = 30;
  int _currentIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    emailAuth = new EmailAuth(sessionName: "Blog_app");
    emailAuth.config(remoteServerConfiguration);
  }

  void resend() {
    setState(() {
      submitValid = true;
    });

    const oneSec = Duration(seconds: 2);
    _timer = new Timer.periodic(oneSec, (timer) {
      setState(() {
        if (_start == 0) {
          _start = 30;
          submitValid = false;
          timer.cancel();
        } else {
          _start--;
        }
      });
    });
  }

  void sendOtp() async {
    bool result = await emailAuth.sendOtp(
        recipientMail: _emailverifyController.value.text, otpLength: 5);
    if (result) {
      setState(() {
        submitValid = true;
      });
      resend();
    }
  }

  bool verify() {
    return (emailAuth.validateOtp(
        recipientMail: _emailverifyController.value.text,
        userOtp: _otpverifyController.value.text));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // height: MediaQuery.of(context).size.height,
        // width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.green.shade200],
            begin: const FractionalOffset(0.0, 1.0),
            end: const FractionalOffset(0.0, 1.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.repeated,
          ),
        ),
        child: Form(
          key: _globalkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Verify Email",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              emailverifyTextField(),
              otpTextField(),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 20),
                  InkWell(
                    onTap: () async {
                      await checkEmail();
                      if (_emailverifyController.text.length == 0) {
                        errorText = "Email Can't be empty";
                      }
                      if (isEmailExist) {
                        submitValid ? print("OTP SENT ALREADY") : sendOtp();
                      }

                      // if (submitValid) {
                      //   Fluttertoast.showToast(
                      //       msg: "OTP SENT",
                      //       toastLength: Toast.LENGTH_SHORT,
                      //       gravity: ToastGravity.CENTER,
                      //       timeInSecForIosWeb: 1,
                      //       backgroundColor: Colors.blueGrey,
                      //       textColor: Colors.white,
                      //       fontSize: 14.0);
                      // }
                    },
                    child: submitValid
                        ? Text(
                            "TRY AGAIN IN :" + _start.toString(),
                            style: TextStyle(
                              color: Colors.blue[900],
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : Text(
                            "REQUEST OTP",
                            style: TextStyle(
                              color: Colors.blue[900],
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () async {
                  setState(() {
                    circular = true;
                  });
                  await checkEmail();
                  if (_globalkey.currentState!.validate() &&
                      validate &&
                      verify()) {
                    //validate - if username unique
                    // we will send the data to rest server
                    String verifiedemail = _emailverifyController.text;
                    Map<String, String> data = {
                      'email': '${_emailverifyController.text}'
                    };
                    print(data);

                    setState(() {
                      circular = false;
                    });
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ForgotPasswordPage(
                                  username: username,
                                )));
                    //Login Logic added here

                  } else {
                    setState(() {
                      circular = false;
                    });
                  }
                },
                child: circular
                    ? CircularProgressIndicator()
                    : Container(
                        width: 150,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xff00A86B),
                        ),
                        child: Center(
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }

//Checking Whether user name is valid or not
  checkEmail() async {
    if (_emailverifyController.text.length == 0) {
      //if no user_name
      setState(() {
        circular = false;
        validate = false;
        errorText = "Email Can't be empty";
      });
    }
    //checking for username
    else {
      var response = await networkHandler
          .get("user/checkEmail/${_emailverifyController.text}");

      if (response["Status"]) {
        print(response["username"]);
        setState(() {
          //circular = false;
          username = response["username"];
          validate = true;
          isEmailExist = true;
        });
        return response["Status"];
      } else {
        setState(() {
          // circular = false;
          errorText = "Email Does not Exists";
          validate = false;
          isEmailExist = false;
        });
      }
    }
  }

  Widget emailverifyTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10.0),
      child: Column(
        children: [
          Text("Email"),
          TextFormField(
            controller: _emailverifyController,
            validator: (value) {
              if (value!.isEmpty) return "Email can't be empty";
              if (!value.contains("@")) return "Email is Invalid";
              return null;
            },
            decoration: InputDecoration(
              errorText: validate ? null : errorText,
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black,
                  width: 2,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget otpTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10.0),
      child: Column(
        children: [
          Text("OTP"),
          TextFormField(
            controller: _otpverifyController,
            validator: (value) {
              if (value!.isEmpty) return "OTP can't be empty";
              if (value.length < 4) return "OTP lenght must have >=4";
              return null;
            },
            obscureText: vis,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Icon(vis ? Icons.visibility_off : Icons.visibility),
                onPressed: () {
                  setState(() {
                    vis = !vis;
                  });
                },
              ),
              helperText: "OTP length should have >=4",
              helperStyle: TextStyle(
                fontSize: 14,
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black,
                  width: 2,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
