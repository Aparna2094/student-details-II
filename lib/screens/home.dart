// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, sized_box_for_whitespace

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:student_provider/database/functions.dart';
import 'package:student_provider/database/models.dart';
import 'package:student_provider/provider/pro.dart';
import 'package:student_provider/screens/registration.dart';
import 'package:student_provider/widget/home_list.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    getStudent();
    super.initState();
    searchControler.removeListener(() {
      searchText;
    });
  }

  String searchText = '';
  Timer? debouncer;

  //CustomList? sear;
  final searchControler = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Consumer<StudentProvider>(
      builder: (context, value, child) {
        return Scaffold(
            extendBodyBehindAppBar: true,
           
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 12),
              child: FloatingActionButton.extended(
                backgroundColor: Color.fromARGB(255, 64, 159, 146),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (reg) => RegisterScreen(
                                isEdit: false,
                              )));
                },
                icon: Icon(
                  Icons.add,
                  size: 30,
                  color:Colors.white
                ),
                label: Text("Add Student",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
              ),
            ),
            appBar: AppBar(
              backgroundColor: Color.fromARGB(255, 64, 159, 146),
             
              centerTitle: true,
              title: Text(
               'Student Details',
               style: TextStyle(color: Colors.white),
                                ),
              bottom: PreferredSize(
                  preferredSize: Size.fromRadius(40),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 40, right: 40),
                    child: ValueListenableBuilder(
                        valueListenable: scroll,
                        builder: (context, isvisible, _) {
                          return isvisible
                              ? Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Container(
                                    height: 40,
                                    child: TextFormField(
                                      onChanged: (values) {
                                        value.getsearchText(values);
                                        onSearchChange(values);
                                      },
                                      controller: searchControler,
                                      decoration: InputDecoration(
                                          suffixIcon: searchControler
                                                  .text.isEmpty
                                              ? Icon(
                                                  Icons.mic,
                                                  color: Colors.black,
                                                )
                                              : IconButton(
                                                  onPressed: () {
                                                    searchControler.clear();
                                                    value.getsearchText('');
                                                    getStudent();
                                                  },
                                                  icon: Icon(
                                                    Icons.clear,
                                                    color: Colors.black,
                                                  )),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: const Color.fromARGB(
                                                    255,
                                                    0,
                                                    0,
                                                    0)), // Set underline color to white when focused
                                          ),
                                          labelStyle: TextStyle(
                                              color: Colors.white),
                                          label: Text(
                                            'search',
                                            style: TextStyle(
                                                color: Colors.black),
                                          ),
                                          filled: true,
                                          fillColor: Colors.grey,
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      30)),
                                          prefixIcon: Icon(
                                            Icons.search,
                                            color: Colors.black,
                                          )),
                                    ),
                                  ),
                                )
                              : SizedBox();
                        }),
                  )),
            ),
            body: NotificationListener<UserScrollNotification>(
                onNotification: (notification) {
                  final ScrollDirection direction = notification.direction;
                  if (direction == ScrollDirection.reverse) {
                    scroll.value = false;
                  } else if (direction == ScrollDirection.forward) {
                    scroll.value = true;
                  }
                  return true;
                },
                child: CustomList()));
      },
    );
  }

  onSearchChange(
    String values,
  ) {
    final studentdb = Hive.box<Studentupdate>('student');
    final students = studentdb.values.toList();
    values = searchControler.text;

    if (debouncer?.isActive ?? false) debouncer?.cancel();
    debouncer = Timer(Duration(milliseconds: 200), () {
      if (this.searchText != searchControler) {
        final filterdStudent = students
            .where((students) => students.name!
                .toLowerCase()
                .trim()
                .contains(values.toLowerCase().trim()))
            .toList();
        studentlist.value = filterdStudent;
      }
    });
  }
}