import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'expenses_provider.dart';

class AuthProvider extends ChangeNotifier {
  String _language = "en";
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user;

  User? get user => _user;

  bool get isAuthenticated => _user != null;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String _userCurrency = "UZS";

  String get userCurrency => _userCurrency;

  String get language => _language;

  Future<void> signUp(String username, String password, String displayName,
      String currency) async {
    try {
      _isLoading = true;
      notifyListeners();
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: username,
        password: password,
      );
      FirebaseFirestore.instance
          .collection("users")
          .doc(userCredential.user!.uid)
          .set(
        {
          "currency": currency,
        },
      );
      await userCredential.user!.updateDisplayName(displayName);

      // After updating, reload the user data
      await userCredential.user!.reload();
      _user = _firebaseAuth.currentUser;
      _userCurrency = currency;

      _isLoading = false;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      notifyListeners();
      throw e;
    }
  }

  Future<void> logIn(String username, String password) async {
    try {
      _isLoading = true;
      notifyListeners();
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: username, password: password);
      _user = userCredential.user;

      _isLoading = false;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      notifyListeners();
      throw e;
    }
  }

  Future<void> signOut(BuildContext context) async {
    await _firebaseAuth.signOut();
    Provider.of<ExpensesProvider>(context, listen: false).clearExpenditures();
    _user = null;

    notifyListeners();
  }

  void initializeUser() {
    _user = _firebaseAuth.currentUser;
    notifyListeners();
  }

  Future<void> updateUserLanguagePreference(
      String userId, String languageCode) async {
    await _firestore.collection("users").doc(userId).update({
      "language": languageCode,
    });
    _language = languageCode;
    notifyListeners();
  }

  Future<void> fetchUserLanguagePreference(String userId) async {
    DocumentSnapshot userDoc =
        await _firestore.collection("users").doc(userId).get();
    _language = (userDoc.data() as Map<String, dynamic>)['language'] ?? "en";
    notifyListeners();
  }
}
