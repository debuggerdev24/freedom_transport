import 'dart:convert';
import 'dart:developer';

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

bool _isNdisParticipant = false;
bool _hasHealthCondition = false;
bool ndisTransport = false;

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
                horizontal: width * 0.060, vertical: height * 0.02),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      icon:
                          Icon(Icons.arrow_back, color: inputfocusedUnderline),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        MyText(
                          text: "NDIS Information (if applicable)",
                          size: height * 0.020,
                          fontweight: FontWeight.bold,
                          color: textColor,
                        ),
                        Row(
                          children: [
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
                                  const Text("Self-Managed"),
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
                              if (_planType == "AGENCY" ||
                                  _planType == "PLAN") ...[
                                Gap(width * 0.03),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: MyText(
                                    text: _planType == "AGENCY"
                                        ? "Agency Manager Contact:"
                                        : _planType == "PLAN"
                                            ? "Plan Manager Contact:"
                                            : "",
                                    size: height * 0.020,
                                    fontweight: FontWeight.bold,
                                  ),
                                ),
                                Gap(width * 0.03),
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
                              ],
                              Gap(width * 0.04),
                            ],
                          ),
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
                              value: false,
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
                              value: true,
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
                        const Text(
                            "Things I don’t like or make me uncomfortable:"),
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
                        Row(
                          children: [
                            Checkbox(
                              value: ndisTransport,
                              onChanged: (bool? value) {
                                setState(() {
                                  ndisTransport = value!;
                                });
                              },
                              activeColor: theme,
                            ),
                            Text(
                              "I confirm that the information provided is\n accurate and up-to-date.",
                              style: TextStyle(color: verifyDeclined),
                            ),
                          ],
                        ),
                        const Gap(15),
                      ],
                    ),
                  ),
                ),
                CustomButton(
                  title: "Submit",
                  onTap: () async {
                    if (!_formKey.currentState!.validate()) {
                      showSnackBar(
                          context, "Please fill all the required fields.");
                      return;
                    }

                    if ((_isNdisParticipant == null || !_isNdisParticipant)) {
                      showSnackBar(context,
                          "You must select 'Yes' as Participant to proceed.");
                      return;
                    }
                    if (!ndisTransport) {
                      showSnackBar(context,
                          "You must confirm the information by checking the box.");
                      return;
                    }

                    requestData["user_ndis_details"] = [
                      {
                        "participant": _isNdisParticipant == true ? 1 : 0,
                        "number": _txtNdisNumber.text,
                        "type": _planType,
                        "plan_manager_name": _txtName.text,
                        "plan_manager_phone": _txtPhone.text,
                        "plan_manager_email": _txtEmail.text,
                        "health_awareness": _hasHealthCondition == true ? 1 : 0,
                        "health_details": _hasHealthCondition
                            ? _txtHealthInformation.text
                            : "Nothing any health conditions",
                        "other": _txtOtherInformation.text,
                      }
                    ];

                    log("ndisdetails======>${requestData}");

                    if (agedCareTransport) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const AgedCareInformation()));
                    } else if (niisqTransport) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const NIISQInformation()));
                    } else if (privateTransport) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const PrivateInformation()));
                    } else {
                      await ApiService.apiService
                          .sendUserDataToApi(requestData, context);
                      _clearFormData();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _clearFormData() async {
    _txtNdisNumber.clear();
    _txtName.clear();
    _txtPhone.clear();
    _txtEmail.clear();
    _txtHealthInformation.clear();
    _txtOtherInformation.clear();
    _isNdisParticipant = false;
    _hasHealthCondition = false;
    _planType.isNotEmpty;
    ndisTransport = false;
  }
}
