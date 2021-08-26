import 'package:get/get.dart';
import 'package:note_app/controllers/authController.dart';
import 'package:flutter/material.dart';
import 'package:note_app/screens/authScreen.dart';
import 'package:note_app/screens/home.dart';

class Root extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authController = Get.put(AuthController());
    bool userState = authController.checkUserState();
    if (userState) {
      return Home();
    } else {
      return AuthScreen();
    }
  }
}
