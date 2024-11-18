import 'package:flutter/material.dart';
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
import 'package:intl/intl.dart';

import '../informationsPage/components/button.dart';

bool ndisTransport = false;
bool agedCareTransport = false;
bool niisqTransport = false;
bool privateTransport = false;

GlobalKey<FormState> _formKey = GlobalKey();

TextEditingController _txtCusPhoneNumber = TextEditingController();
TextEditingController _txtCusAddress = TextEditingController();
TextEditingController _txtCusBirthDate = TextEditingController();
TextEditingController _txtEmgName = TextEditingController();
TextEditingController _txtEmgPhone = TextEditingController();
TextEditingController _txtEmgEmail = TextEditingController();
String _selectedGender = "male";

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
      // Format the selected date and update the controller
      setState(() {
        _txtCusBirthDate.text = DateFormat("yyyy-MM-dd").format(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
          child: SafeArea(
            child: SingleChildScrollView(
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
                  InputInformation(
                    title: "*Phone Number:",
                    controller: _txtCusPhoneNumber,
                    keyboardType: TextInputType.phone,
                    mobileValidation: true,
                    emptyValidation: true,
                  ),
                  InputInformation(
                    emptyValidation: true,
                    title: "*Address:",
                    controller: _txtCusAddress,
                  ),
                  const Gap(2),
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
                        onPressed: () => _selectDate(
                            context), // Open date picker on icon tap
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onTap: () =>
                        _selectDate(context), // Open date picker on field tap
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
                              text: "Non - Binary", size: media.height * 0.02)
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
                          MyText(text: "Female", size: media.height * 0.02)
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
                  Gap(
                    media.width * 0.04,
                  ),
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
                  CheckboxListTile(
                    activeColor: theme,
                    value: ndisTransport,
                    onChanged: (bool? value) {
                      setState(() {
                        ndisTransport = value ?? false;
                      });
                    },
                    title: const Text('NDIS Transport'),
                  ),
                  CheckboxListTile(
                    activeColor: theme,
                    value: agedCareTransport,
                    onChanged: (bool? value) {
                      setState(() {
                        agedCareTransport = value ?? false;
                      });
                    },
                    title: const Text("Aged Care Transport"),
                  ),
                  CheckboxListTile(
                    activeColor: theme,
                    value: niisqTransport,
                    onChanged: (bool? value) {
                      setState(() {
                        niisqTransport = value ?? false;
                      });
                    },
                    title: const Text("NIISQ Transport"),
                  ),
                  CheckboxListTile(
                    activeColor: theme,
                    value: privateTransport,
                    onChanged: (bool? value) {
                      setState(() {
                        privateTransport = value ?? false;
                      });
                    },
                    title: const Text(" Private Transport"),
                  ),
                  CustomButton(
                    title: "Continue →",
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        requestData.addAll({
                          "address": _txtCusAddress.text,
                          "dob": _txtCusBirthDate.text,
                          "gender":
                              _selectedGender,
                          "emg_name": _txtEmgName.text,
                          "emg_number": _txtEmgPhone.text,
                          "emg_email": _txtEmgEmail.text,
                        });
                        print(requestData);
                        if (ndisTransport) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const NDISInformation()));
                        } else if (agedCareTransport) {
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
}