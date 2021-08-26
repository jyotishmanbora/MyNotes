import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_app/constants.dart';
import 'package:note_app/controllers/authController.dart';
import 'package:note_app/controllers/databaseController.dart';
import 'package:note_app/components.dart';
import 'package:note_app/screens/editScreen.dart';
import 'package:note_app/screens/searchScreen.dart';

class Home extends StatelessWidget {
  final authController = Get.find<AuthController>();
  final databaseController = Get.find<DatabaseController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('MyNotes', style: appBarTextStyle),
        leading: Builder(
          builder: (context) => AppBarButton(
              icon: Icons.menu,
              onTap: () {
                Scaffold.of(context).openDrawer();
              }),
        ),
        actions: [
          AppBarButton(
            icon: Icons.search,
            onTap: () {
              Get.to(() => SearchScreen());
            },
          ),
        ],
        leadingWidth: 76.0,
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        centerTitle: true,
      ),
      drawer: DrawerMenu(authController: authController),
      floatingActionButton: FloatingActionButton(
        heroTag: 'FAB',
        backgroundColor: Color(0xff343A54),
        elevation: 0.0,
        onPressed: () {
          Get.to(() => EditScreen());
        },
        child: Icon(Icons.add_rounded, size: 38.0),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 30.0,
          ),
          databaseController.noteStream(authController.userUid),
        ],
      ),
    );
  }
}
