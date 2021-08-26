import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_app/components.dart';
import 'package:note_app/controllers/authController.dart';
import 'package:note_app/controllers/databaseController.dart';

class EditScreen extends StatelessWidget {
  const EditScreen({Key? key, this.title, this.body, this.docID})
      : super(key: key);

  final String? title;
  final String? body;
  final String? docID;

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final databaseController = Get.find<DatabaseController>();
    var titleText;
    var bodyText;

    if (title == null) {
      titleText = '';
    } else {
      titleText = title;
    }

    if (body == null) {
      bodyText = '';
    } else {
      bodyText = body;
    }
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
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'FAB',
        backgroundColor: Color(0xff343A54),
        elevation: 3.0,
        label: Text('Save', style: TextStyle(fontSize: 18.0)),
        icon: Icon(Icons.save),
        onPressed: () {
          if (bodyText == '') {
            Get.defaultDialog(
                title: 'Note is empty!', middleText: 'Note cannot be empty');
          } else {
            databaseController.editNote(
                docID, authController.userUid, titleText, bodyText);
          }
        },
      ),
      body: Column(
        children: [
          SizedBox(height: 30.0),
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
                    child: TextField(
                      controller: (title == null)
                          ? null
                          : TextEditingController(text: title),
                      cursorHeight: 25.0,
                      cursorColor: Color(0xff343A54),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        labelText: 'Title',
                        labelStyle: TextStyle(color: Color(0xff343A54)),
                        filled: true,
                        fillColor: Color(0xffdcdde3),
                      ),
                      onChanged: (value) {
                        titleText = value;
                      },
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.symmetric(
                          horizontal: 18.0, vertical: 20.0),
                      children: [
                        TextField(
                          controller: (body == null)
                              ? null
                              : TextEditingController(text: body),
                          cursorHeight: 25.0,
                          cursorColor: Color(0xff343A54),
                          maxLines: null,
                          minLines: 5,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            labelText: 'Note goes here...',
                            labelStyle: TextStyle(color: Color(0xff343A54)),
                            filled: true,
                            fillColor: Color(0xffdcdde3),
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                          ),
                          onChanged: (value) {
                            bodyText = value;
                          },
                        ),
                      ],
                    ),
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
