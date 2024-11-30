import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_user/functions/functions.dart';
import 'package:flutter_user/pages/informationsPage/components/my_textfield.dart';
import 'package:flutter_user/styles/styles.dart';
import 'package:flutter_user/translations/translation.dart';
import 'package:flutter_user/widgets/widgets.dart';

class UpadatePasswordScreen extends StatefulWidget {
  const UpadatePasswordScreen({super.key});

  @override
  State<UpadatePasswordScreen> createState() => _UpadatePasswordScreenState();
}

class _UpadatePasswordScreenState extends State<UpadatePasswordScreen> {
  final TextEditingController _txtPassword = TextEditingController();
  final TextEditingController _txtEmail = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      body: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 70),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InputInformation(
                      title: "*Enter the Password",
                      controller: _txtPassword,
                      boldTitle: true,
                      emptyValidation: true,
                    ),
                    SizedBox(height: media.width * 0.1),
                    Button(
                      onTap: () async {
                        var val = await updatePassword(
                          _txtEmail.text,
                          _txtPassword.text,
                          isLoginemail,
                        );
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
          )),
    );
  }
}
