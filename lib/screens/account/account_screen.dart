import 'package:expense_tracker_app/provider/auth_provider.dart';
import 'package:expense_tracker_app/screens/account/account_widget.dart';
import 'package:expense_tracker_app/screens/account/language_switcher_widget.dart';
import 'package:expense_tracker_app/screens/auth/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   elevation: 0,
      //   backgroundColor: Colors.white,
      //   title: Text(
      //     "Account",
      //     style: GoogleFonts.robotoCondensed(
      //       color: Colors.black,
      //       fontSize: 24,
      //       fontWeight: FontWeight.w400,
      //     ),
      //   ),
      // ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    Text(
                      auth.user?.displayName ?? "Null",
                      style: GoogleFonts.robotoCondensed(
                        fontSize: 16,
                      ),
                    )
                  ],
                ),
              ),
              Column(
                children: [
                  AccountWidget(
                    icon: Icons.logout,
                    text: "Logout",
                    function: () async {
                      await auth.signOut(context);
                      if (!auth.isAuthenticated) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) {
                              return const AuthScreen();
                            },
                          ),
                        );
                      }
                    },
                  ),
                  AccountWidget(
                    icon: Icons.logout,
                    text: "Logout",
                    function: () async {
                      await auth.signOut(context);
                      if (!auth.isAuthenticated) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) {
                              return const AuthScreen();
                            },
                          ),
                        );
                      }
                    },
                  ),
                  LanguageSwitch(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
