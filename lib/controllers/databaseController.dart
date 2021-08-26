import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:note_app/components.dart';
import 'package:flutter/material.dart';
import 'package:typicons_flutter/typicons_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DatabaseController extends GetxController {
  List<String> months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];

  void createNote(String uid) {
    final CollectionReference? userCollectionReference = FirebaseFirestore
        .instance
        .collection('notes')
        .doc(uid)
        .collection('notes');
    userCollectionReference?.doc(DateTime.now().toString()).set({
      'title': 'Welcome to MyNotes',
      'body': 'Welcome to MyNotes app. This is a demo note and can be deleted.',
      'starred': true,
      'dateTime': DateTime.now().toString(),
      'timeStamp': months[DateTime.now().month - 1] +
          ' ' +
          DateTime.now().day.toString() +
          ', ' +
          DateTime.now().year.toString() +
          ', ' +
          DateTime.now().hour.toString() +
          ':' +
          DateTime.now().minute.toString()
    }).catchError((e) => Get.dialog(Text('Something Went Wrong')));
  }

  void editNote(String? docID, String uid, String title, String body) async {
    if (docID == null) {
      FirebaseFirestore.instance
          .collection('notes')
          .doc(uid)
          .collection('notes')
          .doc(DateTime.now().toString())
          .set({
            'title': (title == '')
                ? months[DateTime.now().month - 1] +
                    ' ' +
                    DateTime.now().day.toString() +
                    ', ' +
                    DateTime.now().year.toString() +
                    ', ' +
                    DateTime.now().hour.toString() +
                    ':' +
                    DateTime.now().minute.toString()
                : title,
            'body': body,
            'starred': false,
            'dateTime': DateTime.now().toString(),
            'timeStamp': months[DateTime.now().month - 1] +
                ' ' +
                DateTime.now().day.toString() +
                ', ' +
                DateTime.now().year.toString() +
                ', ' +
                DateTime.now().hour.toString() +
                ':' +
                DateTime.now().minute.toString()
          })
          .then((value) => Get.back())
          .catchError((e) => Get.snackbar('Error', e));
    } else {
      await FirebaseFirestore.instance
          .collection('notes')
          .doc(uid)
          .collection('notes')
          .doc(docID)
          .update({
            'title': (title == '')
                ? months[DateTime.now().month - 1] +
                    ' ' +
                    DateTime.now().day.toString() +
                    ', ' +
                    DateTime.now().year.toString() +
                    ', ' +
                    DateTime.now().hour.toString() +
                    ':' +
                    DateTime.now().minute.toString()
                : title,
            'body': body,
            'dateTime': DateTime.now().toString(),
            'timeStamp': 'Edited ' +
                months[DateTime.now().month - 1] +
                ' ' +
                DateTime.now().day.toString() +
                ', ' +
                DateTime.now().year.toString() +
                ', ' +
                DateTime.now().hour.toString() +
                ':' +
                DateTime.now().minute.toString()
          })
          .then((value) => Get.back())
          .catchError((e) => Get.snackbar('Error', e));
    }
  }

  Future<String> getShareText(String uid, String docID) async {
    String? title, body, time, shareText;
    await FirebaseFirestore.instance
        .collection('notes')
        .doc(uid)
        .collection('notes')
        .doc(docID)
        .get()
        .then((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        title = data['title'];
        body = data['body'];
        time = data['timeStamp'];
      }
    }).catchError((e) {
      Get.defaultDialog(title: 'Error', middleText: e);
    });

    shareText = '''Here is a note form MyNotes app-
------------------------
$title
------------------------
$body
------------------------
$time''';

    return shareText;
  }

  Widget noteStream(String uid) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('notes')
          .doc(uid)
          .collection('notes')
          .orderBy('dateTime')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong at backend!');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SpinKitDoubleBounce(color: Color(0xffA3ADD8));
        }

        var notes = snapshot.data?.docs;
        List<NoteTile> notesList = [];

        if (notes == null) {
          return Text('Data not received');
        } else {
          for (var note in notes) {
            Map<String, dynamic> data = note.data() as Map<String, dynamic>;
            NoteTile noteTile = NoteTile(
                starred: data['starred'],
                title: data['title'],
                body: data['body'],
                time: data['timeStamp'],
                docID: note.id);
            notesList.add(noteTile);
          }
        }

        return Expanded(
          child: ListView.builder(
            itemBuilder: (context, index) {
              return notesList[notesList.length - 1 - index];
            },
            itemCount: notesList.length,
          ),
        );
      },
    );
  }

  Widget searchStream(String term, String uid) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('notes')
          .doc(uid)
          .collection('notes')
          .orderBy('dateTime')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong at backend!');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SpinKitThreeBounce(color: Color(0xffA3ADD8));
        }

        var notes = snapshot.data?.docs;
        List<NoteTile> notesList = [];

        if (notes == null) {
          return Text('Data not received');
        } else {
          for (var note in notes) {
            Map<String, dynamic> data = note.data() as Map<String, dynamic>;
            if (data['title']
                    .toString()
                    .toLowerCase()
                    .contains(term.toLowerCase()) ||
                data['timeStamp']
                    .toString()
                    .toLowerCase()
                    .contains(term.toLowerCase())) {
              NoteTile noteTile = NoteTile(
                  starred: data['starred'],
                  title: data['title'],
                  body: data['body'],
                  time: data['timeStamp'],
                  docID: note.id);
              notesList.add(noteTile);
            }
          }
        }

        return Expanded(
          child: ListView.builder(
            itemBuilder: (context, index) {
              return notesList[notesList.length - 1 - index];
            },
            itemCount: notesList.length,
          ),
        );
      },
    );
  }

  Widget noteScreenTitle(String uid, String docID) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('notes')
          .doc(uid)
          .collection('notes')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text(
            'Something went wrong at backend!',
            textAlign: TextAlign.start,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Color(0xff343A54),
              fontWeight: FontWeight.w800,
              fontSize: 22.0,
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SpinKitDoubleBounce(color: Color(0xffA3ADD8));
        }

        var notes = snapshot.data?.docs;
        String title = 'Data not received';

        if (notes == null) {
          title = 'Data not recieved';
        } else {
          for (var note in notes) {
            Map<String, dynamic> data = note.data() as Map<String, dynamic>;
            if (note.id == docID) {
              title = data['title'];
            }
          }
        }

        return Text(
          title,
          textAlign: TextAlign.start,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Color(0xff343A54),
            fontWeight: FontWeight.w800,
            fontSize: 22.0,
          ),
        );
      },
    );
  }

  Widget noteScreenBody(String uid, String docID) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('notes')
          .doc(uid)
          .collection('notes')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text(
            'Something went wrong at backend!',
            textAlign: TextAlign.start,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Color(0xff343A54),
              fontWeight: FontWeight.w800,
              fontSize: 22.0,
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SpinKitDoubleBounce(color: Color(0xffA3ADD8));
        }

        var notes = snapshot.data?.docs;
        String body = 'Data not received';
        String time = 'Data not received';

        if (notes == null) {
          body = 'Data not recieved';
        } else {
          for (var note in notes) {
            Map<String, dynamic> data = note.data() as Map<String, dynamic>;
            if (note.id == docID) {
              body = data['body'];
              time = data['timeStamp'];
            }
          }
        }

        return ListView(
          padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 35.0),
          children: [
            Text(
              body,
              style: TextStyle(
                  color: Color(0xff343A54),
                  height: 1.8,
                  fontWeight: FontWeight.w400),
            ),
            SizedBox(height: 60.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  time,
                  style: TextStyle(
                    color: Color(0xffA9B0CB),
                    fontSize: 12.0,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      Typicons.image_outline,
                      color: Color(0xffA9B0CB),
                    ),
                    SizedBox(width: 20.0),
                    FaIcon(
                      FontAwesomeIcons.microphone,
                      color: Color(0xffA9B0CB),
                      size: 20.0,
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget noteScreenBottomBar(String uid, String docID) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('notes')
          .doc(uid)
          .collection('notes')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text(
            'Something went wrong at backend!',
            textAlign: TextAlign.start,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Color(0xff343A54),
              fontWeight: FontWeight.w800,
              fontSize: 22.0,
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SpinKitDoubleBounce(color: Color(0xffA3ADD8));
        }

        var notes = snapshot.data?.docs;

        if (notes == null) {
          return Text('Data not received');
        } else {
          for (var note in notes) {
            Map<String, dynamic> data = note.data() as Map<String, dynamic>;
            if (note.id == docID) {
              BottomBar bar = BottomBar(
                docID: docID,
                starred: data['starred'],
                title: data['title'],
                body: data['body'],
              );
              return bar;
            }
          }
        }

        return Text(
          'Data not received',
          textAlign: TextAlign.start,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Color(0xff343A54),
            fontWeight: FontWeight.w800,
            fontSize: 22.0,
          ),
        );
      },
    );
  }
}
