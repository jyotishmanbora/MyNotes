import 'package:flutter/material.dart';
import 'package:note_app/controllers/authController.dart';
import 'package:note_app/controllers/databaseController.dart';
import 'package:note_app/components.dart';
import 'package:get/get.dart';

class NoteScreen extends StatelessWidget {
  const NoteScreen({Key? key, required this.docId}) : super(key: key);

  final String docId;
  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final databaseController = Get.find<DatabaseController>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: AppBarButton(
          icon: Icons.arrow_back_ios,
          onTap: () {
            Get.back();
          },
          leftPadding: 9.0,
        ),
        leadingWidth: 73.0,
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
      ),
      bottomNavigationBar:
          databaseController.noteScreenBottomBar(authController.userUid, docId),
      body: Column(
        children: [
          SizedBox(height: 60.0),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(top: 15.0),
              decoration: BoxDecoration(
                color: Color(0xffF3F4FA),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding:
                        EdgeInsets.symmetric(horizontal: 18.0, vertical: 10.0),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom:
                            BorderSide(width: 0.5, color: Color(0xffA9B0CB)),
                      ),
                    ),
                    child: databaseController.noteScreenTitle(
                        authController.userUid, docId),
                  ),
                  Expanded(
                    child: databaseController.noteScreenBody(
                        authController.userUid, docId),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
