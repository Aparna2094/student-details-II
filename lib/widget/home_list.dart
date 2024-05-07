// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:student_provider/database/crud_operation.dart';
import 'package:student_provider/database/functions.dart';
import 'package:student_provider/database/models.dart';
import 'package:student_provider/screens/registration.dart';
import 'package:student_provider/widget/bottom_sheet.dart';


ValueNotifier<bool> scroll = ValueNotifier(false);

class CustomList extends StatefulWidget {
  const CustomList({super.key});
  @override
  State<CustomList> createState() => _CustomListState();
}

class _CustomListState extends State<CustomList> {
  @override
  void initState() {
    super.initState();
    getStudent();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 1,
        ),
        ValueListenableBuilder(
          valueListenable: studentlist,
          builder: (context, List<Studentupdate> students, Widget? child) {
            return studentlist.value.isEmpty
                ? Expanded(
                    // ignore: sized_box_for_whitespace
                    child: Container(
                      height: 600,
                      //width: 400,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 200,
                          ),
                          Image.asset(
                            'asset/data.png',
                            fit: BoxFit.cover,
                            // width: 200,
                            height: 200,
                          ),
                        ],
                      ),
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                        itemCount: students.length,
                        itemBuilder: (BuildContext context, int index) {
                          final studentdata = students.reversed.toList()[index];
                          return InkWell(
                            onTap: () {
                              bottomSheet(
                                  context,
                                  studentdata.name!,
                                  studentdata.domain!,
                                  studentdata.place!,
                                  studentdata.phone!,
                                  studentdata.image!);
                            },
                            child: Slidable(
                              endActionPane: ActionPane(
                                  motion: StretchMotion(),
                                  children: [
                                    SlidableAction(
                                        backgroundColor: Colors.red,
                                        icon: Icons.delete,
                                        label: 'Remove',
                                        onPressed: (context) {
                                          delete(context, studentdata.id);
                                        }),
                                    SlidableAction(
                                        label: 'Edit',
                                        icon: Icons.edit,
                                        backgroundColor: const Color.fromARGB(
                                            255, 33, 243, 72),
                                        onPressed: (context) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (reg) =>
                                                      RegisterScreen(
                                                        isEdit: true,
                                                        value: studentdata,
                                                      )));
                                        })
                                  ]),
                              child: Container(
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 6, top: 12, bottom: 12),
                                      child: CircleAvatar(
                                        radius: 41,
                                        backgroundImage:
                                            FileImage(File(studentdata.image!)),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 30,
                                    ),
                                    Text(
                                      studentdata.name!.toUpperCase(),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Spacer(),
                                    Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      color: Colors.black,
                                    ),
                                    SizedBox(
                                      width: 26,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  );
          },
        ),
      ],
    );
  }
}