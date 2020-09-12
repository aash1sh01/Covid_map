import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/HomePage/homemap.dart';
import 'package:flutter_auth/Screens/Login/components/background.dart';
import 'package:flutter_auth/Screens/Signup/signup_screen.dart' show SignUpScreen;
import 'package:flutter_auth/components/ErrorMessage.dart';
import 'package:flutter_auth/components/already_have_an_account_acheck.dart' show AlreadyHaveAnAccountCheck;
import 'package:flutter_auth/components/rounded_button.dart';
import 'package:flutter_auth/components/rounded_input_field.dart';
import 'package:flutter_auth/components/rounded_password_field.dart';
import 'dart:core';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';



class Body extends StatefulWidget {
  const Body({Key key}) : super(key: key);
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String _email, _password;
  bool emailValid;
  bool _autoValidate = false;
  var errorMsg;
  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      body: Form(
        autovalidate: _autoValidate,
        key: _formkey,
        child: Background(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "LOGIN",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: size.height * 0.03),
                Image.asset('assets/icons/login.png'),
                SizedBox(height: size.height * 0.03),
                RoundedInputField(
                    hintText: "Your Email",
                    validator: (value) {

                        Pattern pattern =
                            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                        RegExp regex = new RegExp(pattern);
                        if (value.isEmpty) return '*Required';
                        if (!regex.hasMatch(value))
                          return "*Enter a valid email";
                        else
                          return null;
                      },


                    onSaved: (value) {
                      setState(() {
                        _email = (value);
                      });
                    }


                ),

                RoundedPasswordField(
                      validator: (value) {
                      if (value.length < 8) {
                        return "Your Password must be at least 8 characters long";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      setState(() {
                        _password = (value);
                      });
                    }

                ),
                RoundedButton(
                    text: "LOGIN",
                    press: () {
                      setState(() {
                        Loading(indicator: BallPulseIndicator(), size: 100.0,color: Colors.pink);
                      });
                      login();
                    }
                ),
                SizedBox(height: size.height * 0.03),
                AlreadyHaveAnAccountCheck(
                  press: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return SignUpScreen();
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void login() async{
    final FormState form = _formkey.currentState;
    if(_formkey.currentState.validate()){
      form.save();
      setState(() {
      });
      try {
        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _email,
            password: _password,
          );
        Navigator.push(
            context,
              MaterialPageRoute(
              builder: (context) {
                return HomeMap();
              },
            ),
        );
      } catch (e) {
        if (e.code == 'user-not-found') {
          print("User not found");
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
        }
        else if (e.message=="The email address is badly formatted.") {
            return showDialog(context: context, barrierDismissible: true);        }
      }
      _autoValidate= true;
    }

  }

  }




