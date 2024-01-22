import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expense_tracker_app/provider/auth_provider.dart';

class LanguageSwitch extends StatefulWidget {
  const LanguageSwitch({super.key});

  @override
  State<LanguageSwitch> createState() => _LanguageSwitchState();
}

class _LanguageSwitchState extends State<LanguageSwitch> {
  bool isRussian = false;
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.user;
    return Padding(
      padding: const EdgeInsets.only(left: 30, top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            isRussian ? "Изменить на английский" : "Switch to Russian",
          ),
          Switch(
            value: isRussian,
            onChanged: (bool newValue) {
              if (user != null) {
                // Update the state and then update user language preference
                setState(() {
                  isRussian = newValue; // Update the local toggle state
                });
                // Call the method with both required parameters
                authProvider.updateUserLanguagePreference(
                    user.uid, newValue ? "ru" : "en");
              } else {
                // Handle the case where there is no logged in user
                print('No user logged in to update language preference.');
              }
            },
          ),
        ],
      ),
    );
  }
}
