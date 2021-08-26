import 'package:flutter/material.dart';
import 'package:focused_menu/modals.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:note_app/screens/editScreen.dart';
import 'package:note_app/screens/noteScreen.dart';
import 'package:typicons_flutter/typicons_flutter.dart';
import 'controllers/authController.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share_plus/share_plus.dart';
import 'controllers/databaseController.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({
    Key? key,
    required this.authController,
  }) : super(key: key);

  final AuthController authController;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Container(
          child: Column(
            children: [
              Card(
                margin: EdgeInsets.all(10.0),
                elevation: 2.0,
                child: ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Sign Out'),
                  onTap: () {
                    authController.toggleSpinner();
                    authController.signOutUser();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppBarButton extends StatelessWidget {
  const AppBarButton(
      {@required this.icon, @required this.onTap, this.leftPadding = 0.0});

  final IconData? icon;
  final onTap;
  final double leftPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 37.0,
      margin: EdgeInsets.symmetric(horizontal: 18.0, vertical: 10.0),
      decoration: BoxDecoration(
          color: Color(0xffF3F4FA),
          borderRadius: BorderRadius.all(Radius.circular(8.0))),
      child: IconButton(
        padding: EdgeInsets.only(left: leftPadding),
        icon: Icon(icon, color: Color(0xff343A54), size: 22.0),
        onPressed: onTap,
      ),
    );
  }
}

class AuthButton extends StatelessWidget {
  const AuthButton({
    Key? key,
    required this.authController,
    required this.email,
    required this.password,
    required this.emailTextController,
    required this.passwordTextController,
    required this.authFunction,
    required this.buttonText,
    required this.infoText,
  }) : super(key: key);

  final AuthController authController;
  final TextEditingController emailTextController;
  final TextEditingController passwordTextController;
  final String email;
  final String password;
  final String buttonText;
  final String infoText;
  final Function authFunction;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
          onPressed: () {
            authController.toggleSpinner();
            authFunction(email, password);
            emailTextController.clear();
            passwordTextController.clear();
          },
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            child: Text(buttonText),
          ),
          style: TextButton.styleFrom(
            primary: Colors.white,
            backgroundColor: Color(0xff343A54),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 5.0),
          margin: EdgeInsets.only(top: 5.0),
          width: 100.0,
          decoration: BoxDecoration(
              border: Border(
                  top: BorderSide(width: 1.0, color: Color(0xff69708D)))),
          child: Text(
            infoText,
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xff69708D), fontSize: 13.0),
          ),
        ),
      ],
    );
  }
}

class NoteTile extends StatelessWidget {
  const NoteTile(
      {Key? key,
      this.starred = false,
      required this.title,
      required this.body,
      required this.time,
      required this.docID})
      : super(key: key);

  final bool starred;
  final String title;
  final String body;
  final String time;
  final String docID;

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    return Container(
      padding:
          EdgeInsets.only(right: 18.0, left: 18.0, bottom: 15.0, top: 30.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 0.8, color: Color(0xffC2C2C2)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Get.to(() => NoteScreen(
                    docId: docID,
                  ));
            },
            child: Container(
              width: 230.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Color(0xff343A54),
                        fontWeight: FontWeight.w800,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  Text(
                    body,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                      color: Color(0xff808080),
                      fontSize: 13.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  starred
                      ? Transform.translate(
                          offset: Offset(19.0, -17.0),
                          child: IconButton(
                            onPressed: () async {
                              await FirebaseFirestore.instance
                                  .collection('notes')
                                  .doc(authController.userUid)
                                  .collection('notes')
                                  .doc(docID)
                                  .update({'starred': false}).catchError(
                                      (e) => Get.snackbar('Error', e));
                            },
                            icon: Icon(
                              Icons.star,
                              size: 22.0,
                            ),
                            color: Color(0xffF2A005),
                          ),
                        )
                      : Transform.translate(
                          offset: Offset(19.0, -17.0),
                          child: IconButton(
                            onPressed: () async {
                              await FirebaseFirestore.instance
                                  .collection('notes')
                                  .doc(authController.userUid)
                                  .collection('notes')
                                  .doc(docID)
                                  .update({'starred': true}).catchError(
                                      (e) => Get.snackbar('Error', e));
                            },
                            icon: Icon(
                              Icons.star_border_outlined,
                              size: 22.0,
                            ),
                            color: Color(0xff343A54),
                          ),
                        ),
                  Transform.translate(
                    offset: Offset(19.0, -17.0),
                    child: FocusedMenuHolder(
                      menuWidth: 150.0,
                      blurSize: 5.0,
                      menuItemExtent: 45,
                      menuBoxDecoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius:
                              BorderRadius.all(Radius.circular(15.0))),
                      duration: Duration(milliseconds: 100),
                      animateMenuItems: true,
                      openWithTap: true,
                      menuOffset: 0.0,
                      bottomOffsetHeight: 10.0,
                      menuItems: [
                        FocusedMenuItem(
                          title: Text('Edit'),
                          trailingIcon: Icon(Icons.edit),
                          onPressed: () {
                            Get.to(() => EditScreen(
                                  title: title,
                                  body: body,
                                  docID: docID,
                                ));
                          },
                        ),
                        FocusedMenuItem(
                          title: Text('Delete',
                              style: TextStyle(color: Colors.white)),
                          backgroundColor: Colors.redAccent,
                          trailingIcon: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                          onPressed: () async {
                            await FirebaseFirestore.instance
                                .collection('notes')
                                .doc(authController.userUid)
                                .collection('notes')
                                .doc(docID)
                                .delete()
                                .then((value) => Get.snackbar(
                                    'Deleted', 'Note deleted',
                                    snackPosition: SnackPosition.BOTTOM))
                                .catchError((e) => Get.snackbar('Error', e));
                          },
                        ),
                      ],
                      onPressed: () {},
                      blurBackgroundColor: Colors.black54,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 13.0,
                          vertical: 13.0,
                        ),
                        child: Icon(
                          Icons.more_vert,
                          size: 22.0,
                          color: Color(0xff343A54),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                width: 95.0,
                child: Text(
                  time,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    color: Color(0xff616161),
                    fontSize: 11.0,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BottomBar extends StatelessWidget {
  const BottomBar(
      {Key? key,
      required this.docID,
      required this.starred,
      required this.title,
      required this.body})
      : super(key: key);

  final String docID;
  final bool starred;
  final String title;
  final String body;
  @override
  Widget build(BuildContext context) {
    AuthController authController = Get.find<AuthController>();
    DatabaseController databaseController = Get.find<DatabaseController>();
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 8.0,
          ),
        ],
      ),
      child: BottomAppBar(
        color: Color(0xffEAEDFA),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {
                Get.to(() => EditScreen(
                      title: title,
                      body: body,
                      docID: docID,
                    ));
              },
              icon: Icon(Typicons.pencil),
              color: Color(0xff343A54),
              iconSize: 30.0,
            ),
            starred
                ? IconButton(
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection('notes')
                          .doc(authController.userUid)
                          .collection('notes')
                          .doc(docID)
                          .update({'starred': false}).catchError(
                              (e) => Get.snackbar('Error', e));
                    },
                    icon: FaIcon(FontAwesomeIcons.solidStar),
                    color: Color(0xffF2A005),
                    iconSize: 25.0,
                  )
                : IconButton(
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection('notes')
                          .doc(authController.userUid)
                          .collection('notes')
                          .doc(docID)
                          .update({'starred': true}).catchError(
                              (e) => Get.snackbar('Error', e));
                    },
                    icon: FaIcon(FontAwesomeIcons.star),
                    color: Color(0xff343A54),
                    iconSize: 25.0,
                  ),
            IconButton(
              onPressed: () async {
                String shareText = await databaseController.getShareText(
                    authController.userUid, docID);
                Share.share(shareText);
              },
              icon: Icon(Icons.share_outlined),
              color: Color(0xff343A54),
              iconSize: 30.0,
            ),
            FocusedMenuHolder(
              menuWidth: 150.0,
              blurSize: 5.0,
              menuItemExtent: 45,
              menuBoxDecoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.all(Radius.circular(15.0))),
              duration: Duration(milliseconds: 100),
              animateMenuItems: true,
              openWithTap: true,
              menuOffset: 0.0,
              bottomOffsetHeight: 10.0,
              menuItems: [
                FocusedMenuItem(
                  title: Text('Delete', style: TextStyle(color: Colors.white)),
                  backgroundColor: Colors.redAccent,
                  trailingIcon: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection('notes')
                        .doc(authController.userUid)
                        .collection('notes')
                        .doc(docID)
                        .delete()
                        .then((value) => Get.back())
                        .catchError((e) => Get.snackbar('Error', e));
                  },
                ),
              ],
              onPressed: () {},
              blurBackgroundColor: Colors.black54,
              child: IconButton(
                onPressed: null,
                icon: Icon(Icons.more_vert),
                color: Color(0xff343A54),
                disabledColor: Color(0xff343A54),
                iconSize: 30.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
