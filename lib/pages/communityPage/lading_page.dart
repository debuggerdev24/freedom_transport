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
          Image.network(
            "http://cms.freedomtransport.com.au/storage/uploadwebfrontfiles/oUS5sVVTmUDTzPutfWWD6rx9Uk9eCUEXu0E1XgOj.png",
            width: media.width * 0.9,
          ),
          SizedBox(
            height: media.width * 0.05,
          ),
          MyText(
            textAlign: TextAlign.center,
            text: "Welcome to Our community",
            size: media.height * 0.040,
            color: theme,
          ),
          SizedBox(
            height: media.width * 0.20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset(
                "assets/images/niisq.png",
                width: media.width * 0.40,
              ),
              Image.asset(
                "assets/images/ndis.png",
                width: media.width * 0.30,
              ),
              Image.asset(
                "assets/images/private.png",
                width: media.width * 0.30,
              ),
            ],
          ),
          SizedBox(
            height: media.width * 0.10,
          ),
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
          )
        ],
      ),
    );
  }
}
