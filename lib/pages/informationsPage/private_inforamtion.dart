import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_user/pages/communityPage/onbording.dart';
import 'package:flutter_user/pages/communityPage/signup.dart';
import 'package:flutter_user/pages/informationsPage/components/my_textfield.dart';
import 'package:flutter_user/pages/informationsPage/services/api_service.dart';
import 'package:gap/gap.dart';
import '../../styles/styles.dart';
import '../../widgets/widgets.dart';
import 'components/button.dart';

bool _hasHealthConditions = false;
bool _privatetransport = false;
TextEditingController _txtHealthInformation = TextEditingController();
TextEditingController _txtOtherInformation = TextEditingController();

GlobalKey<FormState> _formKey = GlobalKey();

class PrivateInformation extends StatefulWidget {
  const PrivateInformation({super.key});

  @override
  State<PrivateInformation> createState() => _PrivateInformationState();
}

class _PrivateInformationState extends State<PrivateInformation> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: width * 0.062, vertical: height * 0.02),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back,
                            color: inputfocusedUnderline),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                  MyText(
                    text: "Private Information",
                    size: height * 0.020,
                    fontweight: FontWeight.bold,
                    color: textColor,
                  ),
                  Gap(height * 0.02),
                  MyText(
                    text: "*Health Information",
                    size: height * 0.020,
                    fontweight: FontWeight.bold,
                    color: textColor,
                  ),
                  const Text(
                      "Do you have any health conditions that we should be aware of?"),
                  Row(
                    children: [
                      Row(
                        children: [
                          Radio(
                            value: true,
                            groupValue: _hasHealthConditions,
                            onChanged: (value) {
                              setState(() {
                                _hasHealthConditions = value!;
                              });
                            },
                            activeColor: theme,
                          ),
                          const Text("Yes"),
                          Radio(
                            value: false,
                            groupValue: _hasHealthConditions,
                            onChanged: (value) {
                              setState(() {
                                _hasHealthConditions = value!;
                              });
                            },
                            activeColor: theme,
                          ),
                          const Text("No"),
                        ],
                      ),
                    ],
                  ),
                  InputInformation(
                      emptyValidation: true,
                      title: "If yes, please provide details:",
                      controller: _txtHealthInformation),
                  Gap(width * 0.04),
                  MyText(
                      text: "Important Considerations",
                      size: height * 0.020,
                      fontweight: FontWeight.bold,
                      color: textColor),
                  const Text("Things I don’t like or make me uncomfortable:"),
                  const Text("How can we tell when you are not okay?"),
                  const Text(
                      "Other important things we should know about you:"),
                  TextField(
                    controller: _txtOtherInformation,
                  ),
                  Gap(width * 0.04),
                  MyText(
                      text: "*Confirmation",
                      size: height * 0.020,
                      fontweight: FontWeight.bold,
                      color: textColor),
                  Row(
                    children: [
                      Checkbox(
                        value: privateTransport,
                        onChanged: (bool? value) {
                          setState(() {
                            privateTransport = value!;
                          });
                        },
                        activeColor: theme,
                      ),
                      Text(
                        "I confirm that the information provided \nis accurate and up-to-date.",
                        style: TextStyle(color: verifyDeclined),
                      ),
                    ],
                  ),
                  const Gap(15),
                  CustomButton(
                    title: "Submit",
                    onTap: () {
                      if (!_formKey.currentState!.validate()) {
                        if ((_hasHealthConditions == null ||
                            !_hasHealthConditions)) {
                          showSnackBar(context,
                              "You must select 'Yes' as Participant to proceed.");
                          return;
                        }

                        showSnackBar(
                            context, "Please fill all the required fields.");
                        return;
                      }
                      if (!privateTransport) {
                        showSnackBar(
                            context, "You must confirm the information");
                        return;
                      }

                      requestData["user_private_details"] = [
                        {
                          "health_awareness":
                              _hasHealthConditions == true ? 1 : 0,
                          "health_details": _txtHealthInformation.text,
                          "other": _txtOtherInformation.text,
                          "terms_condition": privateTransport == true ? 1 : 0,
                        }
                      ];

                      log("requestData======>${requestData}");

                      ApiService.apiService
                          .sendUserDataToApi(requestData, context);
                      _clearFormData();
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row customRadio(String title) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio(
          value: "",
          onChanged: (value) {},
          groupValue: "null",
        ),
        Text(title),
      ],
    );
  }

  Row customCheckBox(String title) {
    return Row(
      children: [
        Checkbox(value: false, onChanged: (value) {}),
        Text(title),
      ],
    );
  }

  Future<void> _clearFormData() async {
    _txtHealthInformation.clear();
    _txtOtherInformation.clear();
    _hasHealthConditions = false;
    privateTransport = false;
  }
}
