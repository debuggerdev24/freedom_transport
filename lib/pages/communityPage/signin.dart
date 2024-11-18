import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_user/functions/functions.dart';
import 'package:flutter_user/pages/communityPage/signup.dart';
import 'package:flutter_user/pages/informationsPage/components/my_textfield.dart';
import 'package:flutter_user/pages/informationsPage/services/api_service.dart';
import 'package:flutter_user/pages/onTripPage/map_page.dart';
import 'package:flutter_user/styles/styles.dart';
import 'package:flutter_user/widgets/widgets.dart';
import 'package:http/http.dart' as http;

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  // Local keys inside stateful widget to avoid duplication
  TextEditingController _txtEmail = TextEditingController();
  TextEditingController _txtPassword = TextEditingController();
  GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();

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
                ),
                SizedBox(
                  height: media.width * 0.1,
                ),
                Button(
                  onTap: () async {
                    if (_formKey2.currentState!.validate()) {
                      Map requestData = {
                        "email": _txtEmail.text,
                        "password": _txtPassword.text
                      };

                      //http://65.1.206.228/
                      try {
                        Uri uri = Uri.parse('${url}api/v1/user/login');
                        http.Response response = await http.post(
                          uri,
                          headers: {"Content-Type": "application/json"},
                          body: jsonEncode(requestData),
                        );
                        showSnackBar(
                            context, "Status code : ${response.statusCode}");
                        debugPrint("Response Status: ${response.statusCode}");
                        debugPrint("Map: ${requestData}");
                        debugPrint("Response Body: ${response.body}");

                        print(response.statusCode);
                        if (response.statusCode == 200 ||
                            response.statusCode == 201) {
                          showSnackBar(context,
                              "User Details goes to api successfully.");
                          saveLoginStatus(_txtEmail.text);
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const Maps()));
                        } else if (response.statusCode == 422) {
                          var errorData = jsonDecode(response.body);
                          print("Failed to register: ${errorData['message']}");
                        } else if (response.statusCode == 500) {
                          print("You have already account go to sign in!");
                        } else {
                          // status codes when error comes
                          print(
                              "${response.statusCode} You can't filled this cause you have allready have an account");
                        }
                      } catch (e) {
                        log("error: $e");
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
                  onTap: () {},
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