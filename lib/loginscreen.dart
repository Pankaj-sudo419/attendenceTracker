// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:attendanceapp/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController idController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  Color primary = Color.fromARGB(253, 233, 76, 84);
  late SharedPreferences sharedPreferences;

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 3,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: primary,
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(60),
                  bottomLeft: Radius.circular(60),
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: MediaQuery.of(context).size.width / 5,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: screenHeight / 15,
                bottom: screenHeight / 20,
              ),
              child: Center(
                child: Text(
                  "Login",
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width / 18,
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  fieldTitle("Employee ID"),
                  customField("Enter your employee ID", idController, false),
                  fieldTitle("Password"),
                  customField("Enter your Password", passwordController, true),
                  GestureDetector(
                    onTap: () async {
                      FocusScope.of(context).unfocus();
                      String id = idController.text.trim();
                      String password = passwordController.text.trim();

                      if (id.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Employee ID is still Empty!"),
                          ),
                        );
                      } else if (password.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Password is still Empty!"),
                          ),
                        );
                      } else {
                        QuerySnapshot snap = await FirebaseFirestore.instance
                            .collection("Employee")
                            .where('id', isEqualTo: id)
                            .get();

                        try {
                          if (password == snap.docs[0]['password']) {
                            //print("continue");
                            sharedPreferences =
                                await SharedPreferences.getInstance();
                            sharedPreferences
                                .setString('employeeId', id)
                                .then((_) {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomeScreen()));
                            });
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("Password is not correct"),
                            ));
                          }
                        } catch (e) {
                          String error = " ";
                          if (e.toString() ==
                              " RangeError (index): Index out of range: no indices are valid: 0") {
                            setState(() {
                              error = "Employee ID does not exist";
                            });
                          } else {
                            error = "Error occured!";
                          }
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(error),
                          ));
                        }
                      }
                    },
                    child: Container(
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 40),
                      decoration: BoxDecoration(
                        color: primary,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      child: Center(
                        child: Text(
                          "LOGIN",
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width / 26,
                            color: Colors.white,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget fieldTitle(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: MediaQuery.of(context).size.width / 26,
        ),
      ),
    );
  }

  Widget customField(
      String hint, TextEditingController controller, bool obscure) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height / 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(12)),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(66, 8, 8, 8),
            blurRadius: 10,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 6,
            child: Icon(
              Icons.person,
              color: primary,
              size: MediaQuery.of(context).size.width / 15,
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                  right: MediaQuery.of(context).size.height / 12),
              child: TextFormField(
                controller: controller,
                enableSuggestions: true,
                autocorrect: true,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height / 35,
                  ),
                  border: InputBorder.none,
                  hintText: hint,
                ),
                maxLines: 1,
                obscureText: obscure,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
