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
              "http://cms.freedomtransport.com.au/storage/uploadwebfrontfiles/oUS5sVVTmUDTzPutfWWD6rx9Uk9eCUEXu0E1XgOj.png"),
          MyText(
            textAlign: TextAlign.center,
            text: "Welcome to Our community",
            size: media.height * 0.040,
            color: theme,
          ),
          SizedBox(
            height: media.width * 0.2,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.network(
                "https://media.licdn.com/dms/image/C4D0BAQFkL8o_7Rd5Zg/company-logo_200_200/0/1656464950465/niisq_agency_logo?e=2147483647&v=beta&t=fksBPChxw3lH5ghCH7dtzbgm2fPlXb9r3vjQuAzn6V8",
                width: media.width * 0.2,
              ),
              Image.network(
                "https://lifetec.org.au/wp-content/uploads/2021/03/ndis-01.png",
                width: media.width * 0.2,
              ),
              Image.network(
                "https://banner2.cleanpng.com/20180329/yzq/aviyg52z3.webp",
                width: media.width * 0.1,
              ),
            ],
          ),
          SizedBox(
            height: media.width * 0.1,
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
            height: media.width * 0.1,
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
