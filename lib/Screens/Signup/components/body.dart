import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/HomePage/homemap.dart';
import 'package:flutter_auth/Screens/Login/login_screen.dart';
import 'package:flutter_auth/Screens/Signup/components/background.dart';
import 'package:flutter_auth/Screens/Signup/components/or_divider.dart';
import 'package:flutter_auth/Screens/Signup/components/social_icon.dart';
import 'package:flutter_auth/components/already_have_an_account_acheck.dart';
import 'package:flutter_auth/components/rounded_button.dart';
import 'package:flutter_auth/components/rounded_input_field.dart';
import 'package:flutter_auth/components/rounded_password_field.dart';
import 'package:flutter_auth/components/hospital_icon.dart';
import "package:cloud_firestore/cloud_firestore.dart";

class Body extends StatefulWidget {
  const Body({Key key}) : super(key: key);
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  var list1 = ["O+", "O-", "A+", "A-", "B+", "B-", "AB+", "AB-"];
  var list2 = ["Positive", "Positive then recovered", "Negative", "Never Tested"];
  var _autovalidate = false;
  String _name, _email, _password, _bloodgroup, _covidstatus;
  final GlobalKey<FormState> _formkey1 = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      body: Form(
        key: _formkey1,
        child: Background(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "SIGNUP",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: size.height * 0.03),
                RoundedInputField(
                    hintText: "Full Name",
                    onChanged: (value) {},
                    onSaved: (value) {
                      _name = (value);
                    }
                ),
                Hospital(
                  hintText: "Blood Group",
                  items: list1.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),

                  onChanged: (value) {
                    print(value);
                  },
                  onSaved: (value) {
                    _bloodgroup = (value);
                  },
                ),
                Hospital(
                  hintText: "Covid Status",
                  items: list2.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    print(value);
                  },
                     onSaved: (value) {
                    _covidstatus = (value);
                  },
                ),
                RoundedInputField(
                    hintText: "Your Email",
                    validator: (value) {
                      emailValidator((value));
                    },

                    onSaved: (value) {
                      setState(() {
                        _email = (value);
                      });
                    }


                ),
                RoundedPasswordField(
                  onChanged: (value) {},
                  validator: (value) {
                    if (value.length<8) {
                      return "Your password must be at least 8 characters";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _password=(value);
                  },
                ),
                RoundedButton(
                  text: "SIGNUP",
                  press: () {
                    signup();
                  },
                ),
                SizedBox(height: size.height * 0.03),
                AlreadyHaveAnAccountCheck(
                  login: false,
                  press: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return LoginScreen();
                        },
                      ),
                    );
                  },
                ),
                OrDivider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SocalIcon(
                      iconSrc: "assets/icons/facebook.svg",
                      press: () {},
                    ),
                    SocalIcon(
                      iconSrc: "assets/icons/twitter.svg",
                      press: () {},
                    ),
                    SocalIcon(
                      iconSrc: "assets/icons/google-plus.svg",
                      press: () {},
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (value.isEmpty) return '*Required';
    if (!regex.hasMatch(value))
      return '*Enter a valid email';
    else
      return null;
  }

  void signup() async {
    final FormState form = _formkey1.currentState;
    if (_formkey1.currentState.validate()) {
      form.save();
      setState(() {});
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: _email,
          password: _password,
        );
        CollectionReference users = FirebaseFirestore.instance.collection('Users');
        FirebaseAuth auth = FirebaseAuth.instance;
        String uid = auth.currentUser.uid;
        users.add({'Full Name': _name, 'uid': uid, 'Email': _email, 'Password': _password, "BloodGroup": _bloodgroup, "CovidStatus": _covidstatus});
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return HomeMap();
            },
          ),
        );
      } catch (e) {
        print(e);
      }
      _autovalidate = true;
    }
  }
}