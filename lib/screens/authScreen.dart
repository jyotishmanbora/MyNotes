import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_app/constants.dart';
import 'package:note_app/controllers/authController.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:note_app/components.dart';

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var email = ''.obs;
    var password = ''.obs;
    final emailTextController = TextEditingController();
    final passwordTextController = TextEditingController();
    final authController = Get.find<AuthController>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Authentication', style: appBarTextStyle),
        centerTitle: true,
        backgroundColor: Color(0xffA3ADD8),
        shadowColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  icon: Icon(Icons.email),
                  hintText: 'Enter email id',
                  helperText: 'Enter valid email id',
                ),
                onChanged: (value) {
                  email.value = value;
                },
                controller: emailTextController,
              ),
              SizedBox(height: 10.0),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  icon: Icon(Icons.lock),
                  hintText: 'Enter password',
                  helperText: 'Password contains minimum 6 characters',
                ),
                onChanged: (value) {
                  password.value = value;
                },
                controller: passwordTextController,
              ),
              SizedBox(height: 20.0),
              Obx(
                () => (authController.showSpinner.value)
                    ? SpinKitDoubleBounce(color: Color(0xffA3ADD8))
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          AuthButton(
                            authController: authController,
                            email: email.value,
                            password: password.value,
                            authFunction: authController.createUser,
                            buttonText: 'Sign Up',
                            infoText: 'For new user',
                            emailTextController: emailTextController,
                            passwordTextController: passwordTextController,
                          ),
                          AuthButton(
                            authController: authController,
                            email: email.value,
                            password: password.value,
                            emailTextController: emailTextController,
                            passwordTextController: passwordTextController,
                            authFunction: authController.signInUser,
                            buttonText: 'Sign In',
                            infoText: 'For existing user',
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
