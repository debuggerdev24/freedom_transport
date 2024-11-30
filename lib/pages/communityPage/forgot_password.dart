import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_user/functions/functions.dart';
import 'package:flutter_user/pages/communityPage/password_update.dart';
import 'package:flutter_user/pages/informationsPage/components/my_textfield.dart';
import 'package:flutter_user/styles/styles.dart';
import 'package:flutter_user/translations/translation.dart';
import 'package:flutter_user/widgets/widgets.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _txtEmail = TextEditingController();
  final TextEditingController _txtOtp = TextEditingController();
  final TextEditingController _txtPassword = TextEditingController();
  final TextEditingController _txtConfirmPassword = TextEditingController();
  final PageController _pageController = PageController();
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
  String _error = '';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  int _currentPage = 0;

  void nextPage() {
    if (_pageController.hasClients) {
      _pageController.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  void previousPage() {
    if (_pageController.hasClients) {
      _pageController.previousPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      body: Form(
        key: _formKey,
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (index) => setState(() {
            _currentPage = index;
          }),
          children: [
            // Step 1: Email Input
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 70),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InputInformation(
                    title: "*Username or email address",
                    controller: _txtEmail,
                    boldTitle: true,
                    emptyValidation: true,
                    emailValidation: true,
                  ),
                  SizedBox(height: media.width * 0.1),
                  Button(
                    onTap: () async {
                      // Send OTP
                      var val = await sendOTPtoEmail(_txtEmail.text);
                      if (val == 'success') {
                        nextPage();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Failed to send OTP. Please try again.')),
                        );
                      }
                    },
                    text: "Get OTP",
                    color: theme,
                    textcolor: buttonText,
                    borderRadius: BorderRadius.circular(10),
                    borcolor: theme,
                  ),
                ],
              ),
            ),
            // Step 2: OTP Verification
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 70),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InputInformation(
                    title: "*Enter OTP",
                    controller: _txtOtp,
                    boldTitle: true,
                    emptyValidation: true,
                  ),
                  SizedBox(height: media.width * 0.1),
                  Button(
                    onTap: () async {
                      var isVerified =
                          await emailVerify(_txtEmail.text, _txtOtp.text);

                      log("emailverify==========>${isVerified}");
                      if (isVerified == 'success') {
                        nextPage();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('OTP verified successfully!')),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Invalid OTP. Please try again.')),
                        );
                      }
                    },
                    text: "Verify OTP",
                    color: theme,
                    textcolor: buttonText,
                    borderRadius: BorderRadius.circular(10),
                    borcolor: theme,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 70),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InputInformation(
                    title: "*New Password",
                    controller: _txtPassword,
                    boldTitle: true,
                    emptyValidation: true,
                    passwordValidation: true,
                    obscureText: !showNewPassword,
                    suffixIcon: IconButton(
                      icon: Icon(showNewPassword
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          showNewPassword = !showNewPassword;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: media.width * 0.05),
                  InputInformation(
                    title: "*Confirm Password",
                    controller: _txtConfirmPassword,
                    boldTitle: true,
                    emptyValidation: true,
                    obscureText: !showPassword,
                    suffixIcon: IconButton(
                      icon: Icon(showPassword
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          showPassword = !showPassword;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: media.width * 0.1),
                  Button(
                    onTap: () async {
                      if (_txtPassword.text == _txtConfirmPassword.text) {
                        var updateResult = await updatePassword(
                          _txtEmail.text,
                          _txtPassword.text,
                          isLoginemail,
                        );
                        if (updateResult == true) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Password updated successfully!')),
                          );
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(updateResult ??
                                    'Failed to update password.')),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Passwords do not match.')),
                        );
                      }
                    },
                    text: "Update Password",
                    color: theme,
                    textcolor: buttonText,
                    borderRadius: BorderRadius.circular(10),
                    borcolor: theme,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
