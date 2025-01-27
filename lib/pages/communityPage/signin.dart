import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_user/functions/functions.dart';
import 'package:flutter_user/pages/communityPage/forgot_password.dart';

import 'package:flutter_user/pages/communityPage/signup.dart';
import 'package:flutter_user/pages/informationsPage/components/my_textfield.dart';
import 'package:flutter_user/pages/informationsPage/services/api_service.dart';
import 'package:flutter_user/pages/onTripPage/invoice.dart';
import 'package:flutter_user/pages/onTripPage/map_page.dart';
import 'package:flutter_user/styles/styles.dart';
import 'package:flutter_user/translations/translation.dart';
import 'package:flutter_user/widgets/widgets.dart';
import 'package:http/http.dart' as http;

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  String _error = '';
  TextEditingController _txtEmail = TextEditingController();
  TextEditingController _newpassword = TextEditingController();
  TextEditingController _txtPassword = TextEditingController();
  GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  bool loginLoading = true;
  int signIn = 0;
  var searchVal = '';
  bool isLoginemail = true;
  bool withOtp = false;
  bool showPassword = false;
  bool showNewPassword = false;
  bool otpSent = false;
  bool _resend = false;
  int resendTimer = 60;
  bool mobileVerified = false;
  dynamic resendTime;
  bool forgotPassword = false;
  bool newPassword = false;

  navigate(verify) {
    if (verify == true) {
      if (userRequestData.isNotEmpty && userRequestData['is_completed'] == 1) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Invoice()),
            (route) => false);
      } else {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Maps()),
            (route) => false);
      }
    } else if (verify == false) {
      setState(() {
        _error =
            'User Doesn\'t exist with this number, please Signup to continue';
      });
    } else {
      _error = verify.toString();
    }
    loginLoading = false;
    valueNotifierLogin.incrementNotifier();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      body: Form(
        key: _formKey2,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 70),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyText(
                  textAlign: TextAlign.center,
                  text: "Welcome Back!",
                  size: media.height * 0.020,
                  color: textColor,
                ),
                MyText(
                  textAlign: TextAlign.center,
                  text: "Sign In",
                  size: media.height * 0.040,
                  fontweight: FontWeight.w400,
                  color: textColor,
                ),
                SizedBox(
                  height: media.width * 0.4,
                ),
                InputInformation(
                    title: "*Username or email address",
                    controller: _txtEmail,
                    boldTitle: true,
                    emptyValidation: true,
                    emailValidation: true),
                SizedBox(
                  height: media.width * 0.04,
                ),
                InputInformation(
                  title: "*Password",
                  controller: _txtPassword,
                  boldTitle: true,
                  emptyValidation: true,
                  passwordValidation: true,
                  obscureText: !showPassword,
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          if (showPassword) {
                            showPassword = false;
                          } else {
                            showPassword = true;
                          }
                        });
                      },
                      icon: Icon(
                        Icons.remove_red_eye_sharp,
                        color: (showPassword == true)
                            ? const Color(0xff60b0b2)
                            : null,
                      )),
                ),
                SizedBox(
                  height: media.width * 0.1,
                ),
                Button(
                  onTap: () async {
                    if (_formKey2.currentState!.validate()) {
                      Map requestData = {
                        "email": _txtEmail.text,
                        "password": _txtPassword.text,
                      };

                      try {
                        Uri uri = Uri.parse('${url}api/v1/user/login');
                        http.Response response = await http.post(
                          uri,
                          headers: {"Content-Type": "application/json"},
                          body: jsonEncode(requestData),
                        );

                        debugPrint("Response Status: ${response.statusCode}");
                        debugPrint("Map: ${requestData}");
                        debugPrint("Response Body: ${response.body}");

                        if (response.statusCode == 200 ||
                            response.statusCode == 201) {
                          var responseBody = jsonDecode(response.body);

                          // Successful login
                          showSnackBar(context, "Login successfully");
                          var val = await verifyUser(
                              _txtEmail.text,
                              (isLoginemail == true) ? 1 : 0,
                              _txtPassword.text,
                              '',
                              withOtp,
                              forgotPassword);

                          navigate(val);
                        } else if (response.statusCode == 404) {
                          showSnackBar(
                              context, "User does not exist. Please sign up.");
                        } else if (response.statusCode == 422) {
                          var errorData = jsonDecode(response.body);
                          showSnackBar(context, "User does not exist");
                          log("errorData ==========>${errorData}");
                        } else if (response.statusCode == 500) {
                          showSnackBar(
                              context, "Server error! Please try again later.");
                        } else {
                          showSnackBar(
                              context, "Unknown error: ${response.statusCode}");
                        }
                      } catch (e) {
                        log("Error: $e");
                        showSnackBar(context,
                            "An unexpected error occurred. Please try again.");
                      }
                    }
                  },
                  text: "Submit",
                  color: theme,
                  textcolor: buttonText,
                  borderRadius: BorderRadius.circular(10),
                  borcolor: theme,
                ),
                SizedBox(
                  height: media.width * 0.04,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ForgotPassword()));
                  },
                  child: Text(
                    'Forgot your password?',
                    style: TextStyle(
                      decorationColor: theme,
                      decoration: TextDecoration.underline,
                      fontSize: 14,
                      color: theme,
                    ),
                  ),
                ),
                SizedBox(
                  height: media.width * 0.3,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don’t have an account yet? ",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUpScreen()));
                  },
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      decorationColor: theme,
                      decoration: TextDecoration.underline,
                      fontSize: 14,
                      color: theme,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
