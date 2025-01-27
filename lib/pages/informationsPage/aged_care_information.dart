import 'package:flutter/material.dart';
import 'package:flutter_user/pages/communityPage/signup.dart';
import 'package:flutter_user/pages/informationsPage/niisq_information.dart';
import 'package:flutter_user/pages/informationsPage/private_inforamtion.dart';
import 'package:flutter_user/pages/informationsPage/services/api_service.dart';
import 'package:gap/gap.dart';
import '../../styles/styles.dart';
import '../../widgets/widgets.dart';
import '../communityPage/onbording.dart';
import 'components/button.dart';
import 'components/my_textfield.dart';

String _selectedCareLevel = "LEVEL_1";
bool _isAgedCareParticipant = false;
bool _isChspSupport = false;
bool _hasHealthCondition = false;
bool _agecaretransport = false;

GlobalKey<FormState> _formKey = GlobalKey();

TextEditingController _txtAgedCareNumber = TextEditingController();
TextEditingController _txtServiceProvideName = TextEditingController();
TextEditingController _txtName = TextEditingController();
TextEditingController _txtPhone = TextEditingController();
TextEditingController _txtEmail = TextEditingController();
TextEditingController _txtAgedHealthInformation = TextEditingController();
TextEditingController _txtOtherInformation = TextEditingController();

class AgedCareInformation extends StatefulWidget {
  const AgedCareInformation({super.key});

  @override
  State<AgedCareInformation> createState() => _AgedCareInformationState();
}

class _AgedCareInformationState extends State<AgedCareInformation> {
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
            child: Column(
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
                      children: [
                        MyText(
                          text: "Aged Care Information (if applicable)",
                          size: height * 0.020,
                          fontweight: FontWeight.bold,
                          color: textColor,
                        ),
                        Row(
                          children: [
                            MyText(
                              text: "Aged Care Participant:",
                              size: height * 0.020,
                              color: textColor,
                            ),
                            Radio(
                              value: true,
                              groupValue: _isAgedCareParticipant,
                              onChanged: (value) {
                                setState(() {
                                  _isAgedCareParticipant = value!;
                                });
                              },
                              activeColor: theme,
                            ),
                            const Text("Yes"),
                            Radio(
                              value: false,
                              groupValue: _isAgedCareParticipant,
                              onChanged: (value) {
                                setState(() {
                                  _isAgedCareParticipant = value!;
                                });
                              },
                              activeColor: theme,
                            ),
                            const Text("No"),
                          ],
                        ),
                        InputInformation(
                          title: "*Aged Care Number:",
                          controller: _txtAgedCareNumber,
                          emptyValidation: true,
                        ),
                        InputInformation(
                          title: "*Service Provider Name:",
                          controller: _txtServiceProvideName,
                          emptyValidation: true,
                        ),
                        const Gap(10),
                        MyText(
                          text: "Care Package Level:",
                          size: height * 0.020,
                          color: textColor,
                        ),
                        RadioListTile(
                          title: const Text("Level 1 (Basic Care Needs)"),
                          value: "LEVEL_1",
                          groupValue: _selectedCareLevel,
                          onChanged: (value) {
                            setState(() {
                              _selectedCareLevel = value!;
                            });
                          },
                          activeColor: theme,
                        ),
                        RadioListTile(
                          title: const Text("Level 2 (Low Care Needs)"),
                          value: "LEVEL_2",
                          groupValue: _selectedCareLevel,
                          onChanged: (value) {
                            setState(() {
                              _selectedCareLevel = value!;
                            });
                          },
                          activeColor: theme,
                        ),
                        RadioListTile(
                          title:
                              const Text("Level 3 (Intermediate Care Needs)"),
                          value: "LEVEL_3",
                          groupValue: _selectedCareLevel,
                          onChanged: (value) {
                            setState(() {
                              _selectedCareLevel = value!;
                            });
                          },
                          activeColor: theme,
                        ),
                        RadioListTile(
                          title: const Text("Level 4 (High Care Needs)"),
                          value: "LEVEL_4",
                          groupValue: _selectedCareLevel,
                          onChanged: (value) {
                            setState(() {
                              _selectedCareLevel = value!;
                            });
                          },
                          activeColor: theme,
                        ),
                        Gap(width * 0.02),
                        MyText(
                          text: "Support Coordinator/Case Manager:",
                          size: height * 0.020,
                          fontweight: FontWeight.bold,
                          color: textColor,
                        ),
                        const Gap(4),
                        InputInformation(
                            title: "*Name:",
                            controller: _txtName,
                            emptyValidation: true),
                        InputInformation(
                          title: "*Phone:",
                          controller: _txtPhone,
                          keyboardType: TextInputType.phone,
                          mobileValidation: true,
                          emptyValidation: true,
                        ),
                        InputInformation(
                            title: "*Email:",
                            controller: _txtEmail,
                            emailValidation: true,
                            emptyValidation: true),
                        Gap(height * 0.03),
                        const Text(
                            "Do you receive Commonwealth Home Support Program (CHSP) services?"),
                        Row(
                          children: [
                            Radio(
                              value: true,
                              groupValue: _isChspSupport,
                              onChanged: (value) {
                                setState(() {
                                  _isChspSupport = value!;
                                });
                              },
                              activeColor: theme,
                            ),
                            const Text("Yes"),
                            Radio(
                              value: false,
                              groupValue: _isChspSupport,
                              onChanged: (value) {
                                setState(() {
                                  _isChspSupport = value!;
                                });
                              },
                              activeColor: theme,
                            ),
                            const Text("No"),
                          ],
                        ),
                        Gap(width * 0.02),
                        MyText(
                          text: "Health Information",
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
                          title: "If yes, please provide details:",
                          controller: _txtAgedHealthInformation,
                        ),
                        Gap(width * 0.04),
                        MyText(
                          text: "Important Considerations",
                          size: height * 0.020,
                          fontweight: FontWeight.bold,
                          color: textColor,
                        ),
                        const Text(
                            "Things I don’t like or make me uncomfortable:"),
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
                          color: textColor,
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: _agecaretransport,
                              onChanged: (bool? value) {
                                setState(() {
                                  _agecaretransport = value!;
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

                    if ((_isAgedCareParticipant == null ||
                        !_isAgedCareParticipant)) {
                      showSnackBar(context,
                          "You must select 'Yes' as Participant to proceed.");
                      return;
                    }

                    if (!_agecaretransport) {
                      showSnackBar(context,
                          "You must confirm the information by checking the box.");
                      return;
                    }

                    requestData["user_aged_details"] = [
                      {
                        "participant": _isAgedCareParticipant == true ? 1 : 0,
                        "number": _txtAgedCareNumber.text,
                        "provider_name": _txtServiceProvideName.text,
                        "care_package": _selectedCareLevel,
                        "case_manager_name": _txtName.text,
                        "case_manager_phone": _txtPhone.text,
                        "case_manager_email": _txtEmail.text,
                        "chsp_support": _isChspSupport == true ? 1 : 0,
                        "health_awareness": _hasHealthCondition == true ? 1 : 0,
                        "health_details": _hasHealthCondition
                            ? _txtAgedHealthInformation.text
                            : "Nothing any health conditions",
                        "other": _txtOtherInformation.text,
                      }
                    ];
                    print(requestData);

                    if (niisqTransport) {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const NIISQInformation(),
                      ));
                    } else if (privateTransport) {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const PrivateInformation(),
                      ));
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
    _txtAgedCareNumber.clear();
    _txtServiceProvideName.clear();
    _selectedCareLevel.isEmpty;
    _txtAgedHealthInformation.clear();
    _txtEmail.clear();
    _txtName.clear();
    _txtPhone.clear();
    _txtOtherInformation.clear();
    _isChspSupport = false;
    _hasHealthCondition = false;
    _isAgedCareParticipant = false;
    _agecaretransport = false;
  }
}
