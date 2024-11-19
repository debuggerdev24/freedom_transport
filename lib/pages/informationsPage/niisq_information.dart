import 'package:flutter/material.dart';
import 'package:flutter_user/pages/communityPage/signup.dart';
import 'package:flutter_user/pages/informationsPage/components/my_textfield.dart';
import 'package:flutter_user/pages/informationsPage/private_inforamtion.dart';
import 'package:flutter_user/pages/informationsPage/services/api_service.dart';
import 'package:gap/gap.dart';
import '../../styles/styles.dart';
import '../../widgets/widgets.dart';
import '../communityPage/onbording.dart';
import 'components/button.dart';

bool _isNIISQParticipant = false;
bool _hasHealthCondition = false;

TextEditingController _txtNiisqNumber = TextEditingController();
TextEditingController _txtManagerName = TextEditingController();
TextEditingController _txtManagerPhone = TextEditingController();
TextEditingController _txtManagerEmail = TextEditingController();
TextEditingController _txtHealthInformation = TextEditingController();
TextEditingController _txtOtherInformation = TextEditingController();

GlobalKey<FormState> _formKey = GlobalKey();

class NIISQInformation extends StatefulWidget {
  const NIISQInformation({super.key});

  @override
  State<NIISQInformation> createState() => _NIISQInformationState();
}

class _NIISQInformationState extends State<NIISQInformation> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Form(
        key: _formKey,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: width * 0.062, vertical: height * 0.02),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  MyText(
                    text: "NIISQ Information (if applicable)",
                    size: height * 0.020,
                    fontweight: FontWeight.bold,
                    color: textColor,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        MyText(
                          text: "*NIISQ Participant:",
                          size: height * 0.020,
                          color: textColor,
                        ),
                        Row(
                          children: [
                            Radio(
                              value: true,
                              onChanged: (value) {
                                setState(() {
                                  _isNIISQParticipant = value!;
                                });
                              },
                              activeColor: theme,
                              groupValue: _isNIISQParticipant,
                            ),
                            const Text("Yes"),
                          ],
                        ),
                        Row(
                          children: [
                            Radio(
                              value: false,
                              onChanged: (value) {
                                setState(() {
                                  _isNIISQParticipant = value!;
                                });
                              },
                              activeColor: theme,
                              groupValue: _isNIISQParticipant,
                            ),
                            const Text("No"),
                          ],
                        ),
                      ],
                    ),
                  ),
                  InputInformation(
                    title: "*NIISQ Number",
                    controller: _txtNiisqNumber,
                    emptyValidation: true,
                  ),
                  const Gap(5),
                  MyText(
                    text: "*Plan Manager Contact:",
                    size: height * 0.020,
                    color: textColor,
                  ),
                  InputInformation(
                    title: "*Name",
                    controller: _txtManagerName,
                    emptyValidation: true,
                  ),
                  InputInformation(
                    title: "*Phone",
                    controller: _txtManagerPhone,
                    keyboardType: TextInputType.phone,
                    mobileValidation: true,
                    emptyValidation: true,
                  ),
                  InputInformation(
                    title: "*Email",
                    controller: _txtManagerEmail,
                    emailValidation: true,
                    emptyValidation: true,
                  ),
                  Gap(width * 0.04),
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
                      Radio(
                        value: true,
                        groupValue: _hasHealthCondition,
                        onChanged: (value) {
                          setState(() {
                            _hasHealthCondition = value!;
                          });
                        },
                        activeColor: theme,
                      ),
                      const Text("Yes"),
                      Radio(
                        value: false,
                        groupValue: _hasHealthCondition,
                        onChanged: (value) {
                          setState(() {
                            _hasHealthCondition = value!;
                          });
                        },
                        activeColor: theme,
                      ),
                      const Text("No"),
                    ],
                  ),
                  InputInformation(
                      title: "If yes, please provide details",
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
                        value: niisqTransport,
                        onChanged: (bool? value) {
                          setState(() {
                            niisqTransport = value!;
                          });
                        },
                        activeColor: theme,
                      ),
                      const Text(
                          "I confirm that the information provided is\n accurate and up-to-date."),
                    ],
                  ),
                  const Gap(15),
                  CustomButton(
                    title: "Submit",
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        requestData["user_niisq_details"] = {
                          "participant": _isNIISQParticipant,
                          "number": _txtNiisqNumber.text,
                          "plan_manager_name": _txtManagerName.text,
                          "plan_manager_phone": _txtManagerPhone.text,
                          "plan_manager_email": _txtManagerEmail.text,
                          "health_awareness": _hasHealthCondition,
                          "health_details": _hasHealthCondition
                              ? _txtHealthInformation.text
                              : "Nothing any health conditions",
                          "other": _txtOtherInformation.text,
                        };
                        print(requestData);
                        if (privateTransport) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const PrivateInformation(),
                            ),
                          );
                        } else {
                          ApiService.apiService
                              .sendUserDataToApi(requestData, context);
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row customCheckBox(
      String title, bool isChecked, ValueChanged<bool?> onChanged) {
    return Row(
      children: [
        Checkbox(
          value: isChecked,
          activeColor: theme,
          onChanged: onChanged,
        ),
        Text(title),
      ],
    );
  }
}
