import 'package:flutter/material.dart';
import 'package:flutter_user/pages/communityPage/signup.dart';
import 'package:flutter_user/pages/informationsPage/aged_care_information.dart';
import 'package:flutter_user/pages/informationsPage/components/my_textfield.dart';
import 'package:flutter_user/pages/informationsPage/niisq_information.dart';
import 'package:flutter_user/pages/informationsPage/private_inforamtion.dart';
import 'package:flutter_user/pages/informationsPage/services/api_service.dart';
import 'package:flutter_user/widgets/widgets.dart';
import 'package:gap/gap.dart';
import '../../styles/styles.dart';
import '../communityPage/onbording.dart';
import 'components/button.dart';

// Variables to store the selected values for radio buttons and checkboxes
bool _isNdisParticipant = false; // For NDIS Participant (Yes/No)
bool _hasHealthCondition = false; // For Health Condition (Yes/No)

// Plan values
String _planType = "AGENCY";
GlobalKey<FormState> _formKey = GlobalKey();

TextEditingController _txtNdisNumber = TextEditingController();
TextEditingController _txtName = TextEditingController();
TextEditingController _txtPhone = TextEditingController();
TextEditingController _txtEmail = TextEditingController();
TextEditingController _txtHealthInformation = TextEditingController();
TextEditingController _txtOtherInformation = TextEditingController();

class NDISInformation extends StatefulWidget {
  const NDISInformation({super.key});

  @override
  State<NDISInformation> createState() => _NDISInformationState();
}

class _NDISInformationState extends State<NDISInformation> {
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
                  //todo heading style text
                  MyText(
                    text: "NDIS Information (if applicable)",
                    size: height * 0.020,
                    fontweight: FontWeight.bold,
                    color: textColor,
                  ),
                  SingleChildScrollView(
                    child: Row(
                      children: [
                        //todo normal text
                        MyText(
                          text: "*NDIS Participant:",
                          size: height * 0.020,
                          color: textColor,
                        ),
                        Row(
                          children: [
                            Radio(
                              value: true,
                              groupValue: _isNdisParticipant,
                              onChanged: (value) {
                                setState(() {
                                  _isNdisParticipant = value!;
                                });
                              },
                              activeColor: theme,
                            ),
                            const Text("Yes"),
                          ],
                        ),
                        Row(
                          children: [
                            Radio(
                              value: false,
                              groupValue: _isNdisParticipant,
                              onChanged: (value) {
                                setState(() {
                                  _isNdisParticipant = value!;
                                });
                              },
                              activeColor: theme,
                            ),
                            const Text("No"),
                          ],
                        ),
                      ],
                    ),
                  ),
                  InputInformation(
                    title: "*NDIS Number",
                    controller: _txtNdisNumber,
                    emptyValidation: true,
                  ),
                  const Gap(5),
                  MyText(
                    text: "*Plan Type:",
                    size: height * 0.020,
                    color: textColor,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Radio(
                              value: "AGENCY",
                              groupValue: _planType,
                              onChanged: (value) {
                                setState(() {
                                  _planType = value!;
                                });
                              },
                              activeColor: theme,
                            ),
                            const Text("Agency Managed"),
                          ],
                        ),
                        Row(
                          children: [
                            Radio(
                              value: "SELF",
                              groupValue: _planType,
                              onChanged: (value) {
                                setState(() {
                                  _planType = value!;
                                });
                              },
                              activeColor: theme,
                            ),
                            const Text("Self-Manage"),
                          ],
                        ),
                        Row(
                          children: [
                            Radio(
                              value: "PLAN",
                              groupValue: _planType,
                              onChanged: (value) {
                                setState(() {
                                  _planType = value!;
                                });
                              },
                              activeColor: theme,
                            ),
                            const Text("Plan Managed"),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Gap(width * 0.02),
                  MyText(
                    text: "Plan Manager Contact:",
                    size: height * 0.020,
                    fontweight: FontWeight.bold,
                  ),
                  InputInformation(
                    title: "*Name",
                    controller: _txtName,
                    emptyValidation: true,
                  ),
                  InputInformation(
                    title: "*Phone",
                    controller: _txtPhone,
                    keyboardType: TextInputType.phone,
                    mobileValidation: true,
                    emptyValidation: true,
                  ),
                  InputInformation(
                    title: "*Email",
                    controller: _txtEmail,
                    emptyValidation: true,
                    emailValidation: true,
                  ),
                  Gap(width * 0.04),
                  MyText(
                    text: "*Health Information",
                    size: height * 0.020,
                    fontweight: FontWeight.bold,
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
                      title: "If yes, please provide details:",
                      controller: _txtHealthInformation),
                  Gap(width * 0.04),
                  MyText(
                    text: "Important Considerations",
                    size: height * 0.020,
                    fontweight: FontWeight.bold,
                  ),
                  const Text("Things I don’t like or make me uncomfortable:"),
                  const Text("How can we tell when you are not okay?"),
                  const Text(
                      "Other important things we should know about you:"),
                  TextField(controller: _txtOtherInformation),
                  Gap(width * 0.04),
                  MyText(
                    text: "*Confirmation",
                    size: height * 0.020,
                    fontweight: FontWeight.bold,
                  ),
                  const Text(
                      "I confirm that the information provided is accurate and up-to-date."),
                  const Gap(15),
                  CustomButton(
                    title: "Submit",
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        requestData["user_ndis_details"] = {
                          "participant": _isNdisParticipant,
                          "number": _txtNdisNumber.text, //"NDIS-12345",
                          "type": _planType, // must be this - AGENCY,SELF,PLAN
                          "plan_manager_name": _txtName.text, //"Jane Smith",
                          "plan_manager_phone":
                              _txtPhone.text, //"987-654-3210",
                          "plan_manager_email":
                              _txtEmail.text, //"janesmith@example.com",
                          "health_awareness": _hasHealthCondition, //true,
                          "health_details": _hasHealthCondition
                              ? _txtHealthInformation.text
                              : "Nothing any health conditions",
                          "other": _txtOtherInformation.text,
                        };
                        print(requestData);
                        if (agedCareTransport) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  const AgedCareInformation()));
                        } else if (niisqTransport) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const NIISQInformation()));
                        } else if (privateTransport) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  const PrivateInformation()));
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

  Row customCheckBox(String title, bool value, ValueChanged<bool?> onChanged) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          activeColor: theme,
          value: value,
          onChanged: onChanged,
        ),
        Text(title),
      ],
    );
  }
}