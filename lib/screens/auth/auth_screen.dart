import 'package:currency_picker/currency_picker.dart';
import 'package:expense_tracker_app/provider/auth_provider.dart';
import 'package:expense_tracker_app/screens/auth/auth_input_widget.dart';
import 'package:expense_tracker_app/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  String _selectedCurrency = "UZS";
  bool isSignIn = true;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _showCurrencyPicker() async {
    showCurrencyPicker(
      currencyFilter: <String>[
        'EUR',
        'GBP',
        'USD',
        'AUD',
        'CAD',
        'JPY',
        'HKD',
        'CHF',
        'SEK',
        'ILS',
        'UZS',
        'RUB',
      ],
      context: context,
      showFlag: true,
      favorite: <String>[
        'USD',
        "UZS",
      ],
      onSelect: (Currency currency) {
        setState(
          () {
            _selectedCurrency = currency.code;
          },
        );
      },
    );
  }

  void _resetCurrency() {
    setState(() {
      _selectedCurrency = "UZS";
    });
  }

  void authenticate() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    try {
      if (isSignIn) {
        await auth.logIn(
          emailController.text,
          passwordController.text,
        );
      } else {
        await auth.signUp(
          emailController.text,
          passwordController.text,
          nameController.text,
          _selectedCurrency,
        );
      }
      if (auth.isAuthenticated) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) {
              return const MainScreen();
            },
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "Invalid credentials",
            style: GoogleFonts.robotoFlex(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              if (!isSignIn)
                AuthInputWidget(
                  controller: nameController,
                  textCapitalization: TextCapitalization.characters,
                  obscureText: false,
                  textInputType: TextInputType.name,
                  text: "Enter your name",
                ),
              AuthInputWidget(
                controller: emailController,
                textCapitalization: TextCapitalization.none,
                obscureText: false,
                textInputType: TextInputType.emailAddress,
                text: "Enter your email address",
              ),
              AuthInputWidget(
                controller: passwordController,
                textCapitalization: TextCapitalization.none,
                obscureText: true,
                textInputType: TextInputType.visiblePassword,
                text: "Enter password",
              ),
              if (!isSignIn)
                GestureDetector(
                  onTap: _showCurrencyPicker,
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.deepPurple[
                          50], // Use a lighter shade of your primary color
                      borderRadius:
                          BorderRadius.circular(25), // Soften the edges
                      boxShadow: [
                        BoxShadow(
                          color: Colors.deepPurple[
                              200]!, // Use a darker shade for the shadow
                          blurRadius: 5,
                          offset: Offset(0, 3), // Slight shadow for depth
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        "Selected Currency :  $_selectedCurrency",
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              if (!isSignIn)
                const SizedBox(
                  height: 10,
                ),
              if (!isSignIn)
                ElevatedButton(
                  onPressed: _resetCurrency,
                  child: Text(
                    "Reset to Default Currency",
                    style: GoogleFonts.roboto(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple[200],
                  ),
                ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  auth.isLoading ? null : authenticate();
                },
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(
                      0xff492A53,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: auth.isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : Center(
                          child: Text(
                            isSignIn ? "Login" : "Sign Up",
                            style: GoogleFonts.dmSans(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    isSignIn = !isSignIn;
                  });
                },
                child: Text(
                  isSignIn
                      ? "Don't have an account? Create one!"
                      : "Already have an account? Log in!",
                  style: GoogleFonts.openSans(
                    fontSize: 14,
                    decoration: TextDecoration.underline,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
