import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_app/controllers/authController.dart';
import 'package:note_app/controllers/databaseController.dart';
import 'package:note_app/components.dart';

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final databaseController = Get.find<DatabaseController>();
    var term = ''.obs;
    return Scaffold(
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
        elevation: 0,
        actions: [
          Container(
            width: 270.0,
            padding: EdgeInsets.only(right: 18.0, bottom: 12.0),
            child: TextField(
              autofocus: true,
              cursorHeight: 22.0,
              textAlign: TextAlign.end,
              decoration: InputDecoration(
                hintText: 'Search here...',
                floatingLabelBehavior: FloatingLabelBehavior.never,
              ),
              onChanged: (value) {
                term.value = value;
              },
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Obx(() => databaseController.searchStream(
                term.value, authController.userUid)),
          ],
        ),
      ),
    );
  }
}
