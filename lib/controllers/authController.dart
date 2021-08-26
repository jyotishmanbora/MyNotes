import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:note_app/screens/home.dart';
import 'package:note_app/utils/root.dart';
import 'databaseController.dart';

class AuthController extends GetxController {
  var userUid, userEmail;
  var showSpinner = false.obs;
  void toggleSpinner() {
    showSpinner.value ? showSpinner.value = false : showSpinner.value = true;
  }

  FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseController databaseController = Get.put(DatabaseController());

  void createUser(String email, String password) async {
    try {
      UserCredential user = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      userUid = user.user?.uid;
      userEmail = user.user?.email;
      databaseController.createNote(userUid);
      toggleSpinner();
      Get.offAll(() => Home());
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", e.code, snackPosition: SnackPosition.BOTTOM);
      toggleSpinner();
    } catch (e) {
      Get.snackbar("Error", "try again", snackPosition: SnackPosition.BOTTOM);
      toggleSpinner();
    }
  }

  void signInUser(String email, String password) async {
    try {
      UserCredential user = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      userUid = user.user?.uid;
      userEmail = user.user?.email;
      toggleSpinner();
      Get.offAll(() => Home());
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", e.code, snackPosition: SnackPosition.BOTTOM);
      toggleSpinner();
    } catch (e) {
      Get.snackbar("Error", "try again", snackPosition: SnackPosition.BOTTOM);
      toggleSpinner();
    }
  }

  void signOutUser() async {
    try {
      await _auth.signOut();
      toggleSpinner();
      Get.offAll(() => Root());
    } catch (e) {
      Get.snackbar('Error', 'try again', snackPosition: SnackPosition.BOTTOM);
      toggleSpinner();
    }
  }

  bool checkUserState() {
    var currentUser = _auth.currentUser;
    if (currentUser != null) {
      userUid = _auth.currentUser?.uid;
      userEmail = _auth.currentUser?.email;
      return true;
    } else {
      return false;
    }
  }
}
