// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

//import 'dart:ffi';

import 'package:attendanceapp/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:slide_to_act_reborn/slide_to_act_reborn.dart';

class TodayScreen extends StatefulWidget {
  const TodayScreen({Key? key}) : super(key: key);

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  //static String username = " ";
  double screenHeight = 0;
  double screenWidth = 0;

  String checkIn = "__/__";
  String checkOut = "__/__";

  Color primary = const Color(0xffeef444c);

  @override
  void initState() {
    super.initState();
    _getRecord();
  }

  void _getRecord() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection("Employee")
          .where('id', isEqualTo: User.username)
          .get();

      DocumentSnapshot<Object?> snap2 = await FirebaseFirestore.instance
          .collection("Employee")
          .doc(snap.docs[0].id)
          .collection("Record")
          .doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
          .get();

      setState(() {
        checkIn = snap2["checkIn"];
        checkOut = snap2["checkOut"];
      });
    } catch (e) {
      checkIn = "__/__";
      checkOut = "__/__";
    }
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      // backgroundColor: Color.fromARGB(255, 111, 143, 123),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(top: 32),
              child: Text(
                "Welcome,",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: screenWidth / 22,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              //margin: EdgeInsets.only(top: 32),
              child: Text(
                "Employee ${User.username}",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: screenWidth / 18,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(top: 32),
              child: Text(
                "Today's Status",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: screenWidth / 20,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 32),
              height: 150,
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 10,
                    offset: Offset(2, 2),
                  ),
                ],
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Check In",
                          style: TextStyle(
                            fontSize: screenWidth / 20,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          checkIn,
                          //"10:00",
                          style: TextStyle(
                            fontSize: screenWidth / 20,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Check Out",
                          style: TextStyle(
                            fontSize: screenWidth / 20,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          checkOut,
                          //"05:00",
                          style: TextStyle(
                            fontSize: screenWidth / 20,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(top: 8),
              child: RichText(
                text: TextSpan(
                  text: DateTime.now().day.toString(),
                  style: TextStyle(
                    color: primary,
                    fontSize: screenWidth / 18,
                  ),
                  children: [
                    TextSpan(
                      text: DateFormat("MMMM yyyy").format(DateTime.now()),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: screenWidth / 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            StreamBuilder(
                stream: Stream.periodic(const Duration(seconds: 1)),
                builder: (context, snapshot) {
                  return Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(top: 8),
                    child: Text(
                      DateFormat('hh:mm:ss a').format(DateTime.now()),
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: screenWidth / 20,
                      ),
                    ),
                  );
                }),
            checkOut == "__/__"
                ? Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Builder(
                      builder: (context) {
                        final GlobalKey<SlideActionState> _key = GlobalKey();
                        //bool isCheckIn = true;
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SlideAction(
                            key: _key,
                            onSubmit: () async {
                              Future.delayed(
                                Duration(seconds: 1),
                                () => _key.currentState?.reset(),
                              );

                              print(DateFormat('hh:mm').format(DateTime.now()));
                              QuerySnapshot snap = await FirebaseFirestore
                                  .instance
                                  .collection("Employee")
                                  .where('id', isEqualTo: User.username)
                                  .get();
                              if (snap.docs.isNotEmpty) {
                                print(snap.docs[0].id);
                              } else {
                                print("No documents found");
                              }
                              DocumentSnapshot<Object?> snap2 =
                                  await FirebaseFirestore.instance
                                      .collection("Employee")
                                      .doc(snap.docs[0].id)
                                      .collection("Record")
                                      .doc(DateFormat('dd MMMM yyyy')
                                          .format(DateTime.now()))
                                      .get();

                              try {
                                String checkIn = snap2['checkIn'];
                                setState(() {
                                  checkOut = DateFormat('hh:mm')
                                      .format(DateTime.now());
                                });
                                await FirebaseFirestore.instance
                                    .collection("Employee")
                                    .doc(snap.docs[0].id)
                                    .collection("Record")
                                    .doc(DateFormat('dd MMMM yyyy')
                                        .format(DateTime.now()))
                                    .update({
                                  'checkIn': checkIn,
                                  'checkOut': DateFormat('hh:mm')
                                      .format(DateTime.now()),
                                });
                              } catch (e) {
                                setState(() {
                                  checkIn = DateFormat('hh:mm')
                                      .format(DateTime.now());
                                });
                                await FirebaseFirestore.instance
                                    .collection("Employee")
                                    .doc(snap.docs[0].id)
                                    .collection("Record")
                                    .doc(DateFormat('dd MMMM yyyy')
                                        .format(DateTime.now()))
                                    .set({
                                  'checkIn': DateFormat('hh:mm')
                                      .format(DateTime.now()),
                                });
                              }
                            },
                            alignment: Alignment.center,
                            child: Text(
                              checkIn == "__/__"
                                  ? "Slide for Check In"
                                  : "Slide for Check Out",
                              style: TextStyle(
                                color: Color.fromARGB(255, 7, 7, 7),
                              ),
                            ),
                            outerColor: Colors.white,
                            innerColor: primary,
                            sliderButtonIcon: Icon(Icons.lock),
                          ),
                        );
                      },
                    ),
                  )
                : Container(
                    margin: const EdgeInsets.only(top: 30),
                    child: Text(
                      "You have completed Today!",
                      style: TextStyle(fontSize: screenWidth / 20),
                      selectionColor: Colors.black45,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
