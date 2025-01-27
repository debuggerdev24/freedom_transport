import 'package:flutter/material.dart';
import 'package:flutter_user/pages/communityPage/signin.dart';
import 'package:flutter_user/pages/communityPage/signup.dart';
import 'package:flutter_user/styles/styles.dart';
import 'package:flutter_user/widgets/widgets.dart';

class LadingPage extends StatelessWidget {
  const LadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: media.width * 0.3,
          ),
          Image.asset(
            "assets/images/signuplogo.png",
            width: media.width * 0.9,
          ),
          SizedBox(
            height: media.width * 0.3,
          ),
          MyText(
            textAlign: TextAlign.center,
            text: "Welcome to Our Community",
            size: media.height * 0.040,
            color: theme,
          ),
          const Spacer(),
          Button(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SignUpScreen()));
            },
            text: "Sign Up",
            color: theme,
            textcolor: buttonText,
            borderRadius: BorderRadius.circular(12),
            borcolor: theme,
          ),
          SizedBox(
            height: media.width * 0.05,
          ),
          Button(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SignInScreen()));
            },
            text: "Sign In",
            color: Colors.transparent,
            textcolor: theme,
            borderRadius: BorderRadius.circular(12),
            borcolor: theme,
          ),
          SizedBox(
            height: media.width * 0.2,
          ),
        ],
      ),
    );
  }
}
