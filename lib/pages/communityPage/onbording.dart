import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_user/functions/functions.dart';
import 'package:flutter_user/pages/communityPage/signup.dart';
import 'package:flutter_user/pages/informationsPage/aged_care_information.dart';
import 'package:flutter_user/pages/informationsPage/components/my_textfield.dart';
import 'package:flutter_user/pages/informationsPage/ndis_information.dart';
import 'package:flutter_user/pages/informationsPage/niisq_information.dart';
import 'package:flutter_user/pages/informationsPage/private_inforamtion.dart';
import 'package:flutter_user/pages/informationsPage/services/api_service.dart';
import 'package:flutter_user/styles/styles.dart';
import 'package:flutter_user/widgets/widgets.dart';
import 'package:gap/gap.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:intl/intl.dart';

import '../informationsPage/components/button.dart';

bool ndisTransport = false;
bool agedCareTransport = false;
bool niisqTransport = false;
bool privateTransport = false;
bool loginLoading = true;
int signIn = 0;
var searchVal = '';
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

GlobalKey<FormState> _formKey = GlobalKey();

TextEditingController _txtCusPhoneNumber = TextEditingController();
TextEditingController _txtCusAddress = TextEditingController();
TextEditingController _txtCusBirthDate = TextEditingController();
TextEditingController _txtEmgName = TextEditingController();
TextEditingController _txtEmgPhone = TextEditingController();
TextEditingController _txtEmgEmail = TextEditingController();
String _selectedGender = "male";
String selectedTransport = '';
bool isFormedclear = false;

class StepPageView extends StatefulWidget {
  const StepPageView({super.key});

  @override
  _StepPageViewState createState() => _StepPageViewState();
}

class _StepPageViewState extends State<StepPageView> {
  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        _txtCusBirthDate.text = DateFormat("yyyy-MM-dd").format(pickedDate);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (isFormedclear) {
      _clearFormData();
      isFormedclear = false;
    }
  }

  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      body: Form(
        key: _formKey,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: MyText(
                            text: "Let's get started",
                            size: media.height * 0.040,
                            fontweight: FontWeight.w400,
                            color: textColor,
                          ),
                        ),
                        Gap(media.height * 0.04),
                        MyText(
                          textAlign: TextAlign.start,
                          text: "Customer Information",
                          size: media.height * 0.020,
                          fontweight: FontWeight.bold,
                          color: textColor,
                        ),
                        const Text(
                          "*Address:",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        GooglePlaceAutoCompleteTextField(
                          isCrossBtnShown: false,
                          textEditingController: _txtCusAddress,
                          googleAPIKey:
                              'AIzaSyDVd-7a3rcvyfeCqNH0zojzZx6FQsOpyD0',
                          inputDecoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          debounceTime: 800,
                          isLatLngRequired: true,
                          getPlaceDetailWithLatLng: (prediction) {},
                          itemClick: (prediction) {
                            _txtCusAddress.text = prediction.description!;
                            _txtCusAddress.selection =
                                TextSelection.fromPosition(
                              TextPosition(
                                  offset: prediction.description!.length),
                            );
                          },
                        ),

                        const Gap(3),
                        Text(
                          textAlign: TextAlign.start,
                          "*Date of Birth",
                          style: TextStyle(
                            fontSize: media.height * 0.02,
                          ),
                        ),
                        const Gap(2),
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "* Indicates that field is required";
                            }
                            return null;
                          },
                          controller: _txtCusBirthDate,
                          readOnly: true,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(Icons.calendar_today),
                              onPressed: () => _selectDate(context),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onTap: () => _selectDate(context),
                        ),
                        Gap(media.width * 0.04),
                        //---------------------> Gender Selection
                        Align(
                          alignment: Alignment.topLeft,
                          child: MyText(
                            textAlign: TextAlign.start,
                            text: "*Gender:",
                            size: media.height * 0.02,
                            color: textColor,
                          ),
                        ),
                        Wrap(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Radio(
                                  activeColor: theme,
                                  value: "male",
                                  groupValue: _selectedGender,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedGender = value!;
                                    });
                                  },
                                ),
                                MyText(text: "Male", size: media.height * 0.02)
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Radio(
                                  activeColor: theme,
                                  value: "non-bi",
                                  groupValue: _selectedGender,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedGender = value!;
                                    });
                                  },
                                ),
                                MyText(
                                    text: "Non - Binary",
                                    size: media.height * 0.02)
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Radio(
                                  activeColor: theme,
                                  value: "fe-male",
                                  groupValue: _selectedGender,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedGender = value!;
                                    });
                                  },
                                ),
                                MyText(
                                    text: "Female", size: media.height * 0.02)
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Radio(
                                  activeColor: theme,
                                  value: "others",
                                  groupValue: _selectedGender,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedGender = value!;
                                    });
                                  },
                                ),
                                MyText(
                                    text: "Prefer not to say",
                                    size: media.height * 0.02)
                              ],
                            ),
                          ],
                        ),
                        Gap(media.width * 0.04),
                        MyText(
                          textAlign: TextAlign.start,
                          text: "Emergency Contact",
                          size: media.height * 0.020,
                          fontweight: FontWeight.bold,
                          color: textColor,
                        ),
                        InputInformation(
                            title: "*Name:",
                            controller: _txtEmgName,
                            emptyValidation: true),
                        Gap(media.width * 0.04),
                        InputInformation(
                          title: "*Phone Number:",
                          controller: _txtEmgPhone,
                          keyboardType: TextInputType.phone,
                          mobileValidation: true,
                          emptyValidation: true,
                        ),
                        Gap(media.width * 0.04),
                        InputInformation(
                            title: "*Email:",
                            controller: _txtEmgEmail,
                            emailValidation: true,
                            emptyValidation: true),
                        Gap(media.width * 0.04),
                        MyText(
                          text: "Service Information",
                          size: media.height * 0.020,
                          fontweight: FontWeight.bold,
                          color: textColor,
                        ),
                        const Text(
                            "*Please indicate the services you currently have:"),

                        Align(
                          alignment: Alignment.topLeft,
                          child: MyText(
                            textAlign: TextAlign.start,
                            text: "*Service Transport:",
                            size: media.height * 0.02,
                            color: textColor,
                          ),
                        ),
                        Row(
                          children: [
                            Radio(
                              activeColor: theme,
                              value: "ndis",
                              groupValue: selectedTransport,
                              onChanged: (value) {
                                setState(() {
                                  selectedTransport = value!;
                                });
                              },
                            ),
                            MyText(
                                text: "NDIS Transport",
                                size: media.height * 0.02)
                          ],
                        ),
                        Row(
                          children: [
                            Radio(
                              activeColor: theme,
                              value: "agedCare",
                              groupValue: selectedTransport,
                              onChanged: (value) {
                                setState(() {
                                  selectedTransport = value!;
                                });
                              },
                            ),
                            MyText(
                                text: "Aged Care Transport",
                                size: media.height * 0.02)
                          ],
                        ),
                        Row(
                          children: [
                            Radio(
                              activeColor: theme,
                              value: "niisq",
                              groupValue: selectedTransport,
                              onChanged: (value) {
                                setState(() {
                                  selectedTransport = value!;
                                });
                              },
                            ),
                            MyText(
                                text: "NIISQ Transport",
                                size: media.height * 0.02)
                          ],
                        ),
                        Row(
                          children: [
                            Radio(
                              activeColor: theme,
                              value: "private",
                              groupValue: selectedTransport,
                              onChanged: (value) {
                                setState(() {
                                  selectedTransport = value!;
                                });
                              },
                            ),
                            MyText(
                                text: "Private Transport",
                                size: media.height * 0.02)
                          ],
                        ),
                      ],
                    ),
                  ),
                )),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                  child: CustomButton(
                      title: "Continue →",
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          if (selectedTransport.isEmpty) {
                            showSnackBar(context,
                                "Please Select a Service Transport Option.");
                            return;
                          }

                          requestData.addAll({
                            "address": _txtCusAddress.text,
                            "dob": _txtCusBirthDate.text,
                            "gender": _selectedGender,
                            "emg_name": _txtEmgName.text,
                            "emg_email": _txtEmgEmail.text,
                          });

                          log("requestData=======>${requestData}");

                          if (selectedTransport == "ndis" ||
                              selectedTransport == "agedCare" ||
                              selectedTransport == "niisq" ||
                              selectedTransport == "private") {
                            isFormedclear = true;
                          }

                          if (selectedTransport == "ndis") {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const NDISInformation(),
                              ),
                            );
                          } else if (selectedTransport == "agedCare") {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    const AgedCareInformation(),
                              ),
                            );
                          } else if (selectedTransport == "niisq") {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const NIISQInformation(),
                              ),
                            );
                          } else if (selectedTransport == "private") {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    const PrivateInformation(),
                              ),
                            );
                          } else {
                            await ApiService.apiService
                                .sendUserDataToApi(requestData, context);
                          }
                        } else {
                          showSnackBar(context,
                              "User verification failed. Please try again.");
                        }
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _clearFormData() {
    _txtCusAddress.clear();
    _txtCusBirthDate.clear();
    _txtEmgName.clear();
    _txtEmgEmail.clear();
    _txtEmgPhone.clear();
    selectedTransport = "";
    _selectedGender = "male";
  }
}
