import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_user/functions/functions.dart';
import 'package:flutter_user/pages/communityPage/onbording.dart';
import 'package:flutter_user/pages/communityPage/signin.dart';
import 'package:flutter_user/pages/informationsPage/components/my_textfield.dart';
import 'package:flutter_user/pages/informationsPage/services/api_service.dart';
import 'package:flutter_user/pages/onTripPage/invoice.dart';
import 'package:flutter_user/pages/onTripPage/map_page.dart';
import 'package:flutter_user/styles/styles.dart';
import 'package:flutter_user/translations/translation.dart';
import 'package:flutter_user/widgets/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

GlobalKey<FormState> _formKey = GlobalKey();

Map<String, dynamic> requestData = {};
dynamic proImageFile1;
ImagePicker picker = ImagePicker();
bool pickImage = false;
late StreamController profilepicturecontroller;
StreamSink get profilepicturesink => profilepicturecontroller.sink;
Stream get profilepicturestream => profilepicturecontroller.stream;
TextEditingController _txtEmail = TextEditingController();
TextEditingController _txtPhone = TextEditingController();
TextEditingController _txtCountryCode = TextEditingController(text: "+61");
TextEditingController _txtFirstName = TextEditingController();
TextEditingController _txtLastName = TextEditingController();
TextEditingController _txtEmailPassword = TextEditingController();
TextEditingController _txtReTypePassword = TextEditingController();
final TextEditingController _newPassword = TextEditingController();

Map<String, dynamic> userDetails = {};
bool showPassword = false;
bool _retypepassword = false;
bool newPassword = false;

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  void initState() {
    super.initState();
    proImageFile1 = null;
    profilepicturecontroller = StreamController.broadcast();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  getGalleryPermission() async {
    dynamic status;
    if (platform == TargetPlatform.android) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt <= 32) {
        status = await Permission.storage.status;
        if (status != PermissionStatus.granted) {
          status = await Permission.storage.request();
        }
      } else {
        status = await Permission.photos.status;
        if (status != PermissionStatus.granted) {
          status = await Permission.photos.request();
        }
      }
    } else {
      status = await Permission.photos.status;
      if (status != PermissionStatus.granted) {
        status = await Permission.photos.request();
      }
    }
    return status;
  }

  getCameraPermission() async {
    var status = await Permission.camera.status;
    if (status != PermissionStatus.granted) {
      status = await Permission.camera.request();
    }
    return status;
  }

  pickImageFromGallery() async {
    var permission = await getGalleryPermission();
    if (permission == PermissionStatus.granted) {
      final pickedFile =
          await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
      log("pickfile ======>${pickedFile!.path}");
      if (pickedFile != null) {
        setState(() {
          proImageFile1 = pickedFile.path;
        });
      }
      pickImage = false;
      valueNotifierLogin.incrementNotifier();
      profilepicturesink.add('');
    } else {
      valueNotifierLogin.incrementNotifier();
      profilepicturesink.add('');
    }
  }

  pickImageFromCamera() async {
    var permission = await getCameraPermission();
    if (permission == PermissionStatus.granted) {
      final pickedFile =
          await picker.pickImage(source: ImageSource.camera, imageQuality: 50);

      proImageFile1 = pickedFile?.path;
      pickImage = false;
      valueNotifierLogin.incrementNotifier();
      profilepicturesink.add('');
    } else {
      valueNotifierLogin.incrementNotifier();
      profilepicturesink.add('');
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      body: Form(
        key: _formKey,
        child: ValueListenableBuilder(
            valueListenable: valueNotifierLogin.value,
            builder: (context, value, child) {
              return Stack(
                children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 90),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MyText(
                            textAlign: TextAlign.center,
                            text: "Welcome!",
                            size: media.height * 0.020,
                            color: textColor,
                          ),
                          MyText(
                            textAlign: TextAlign.center,
                            text: "Create an Account",
                            size: media.height * 0.040,
                            fontweight: FontWeight.w400,
                            color: textColor,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                pickImage = true;
                              });
                            },
                            child: Stack(
                              children: [
                                Container(
                                  height: media.width * 0.3,
                                  width: media.width * 0.3,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                      image: (proImageFile1 == null)
                                          ? const DecorationImage(
                                              image: AssetImage(
                                                'assets/images/default-profile-picture.jpeg',
                                              ),
                                              fit: BoxFit.cover)
                                          : DecorationImage(
                                              image: FileImage(
                                                  File(proImageFile1)),
                                              fit: BoxFit.cover)),
                                ),
                                Positioned(
                                    bottom: 6,
                                    right: 3,
                                    child: Container(
                                        padding:
                                            EdgeInsets.all(media.width * 0.030),
                                        decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.grey),
                                        child: Icon(
                                          Icons.edit,
                                          size: media.width * 0.035,
                                        )))
                              ],
                            ),
                          ),
                          InputInformation(
                              title: "*First name",
                              controller: _txtFirstName,
                              boldTitle: true,
                              emptyValidation: true),
                          SizedBox(
                            height: media.width * 0.02,
                          ),
                          InputInformation(
                              title: "*Last name",
                              controller: _txtLastName,
                              boldTitle: true,
                              emptyValidation: true),
                          SizedBox(
                            height: media.width * 0.02,
                          ),
                          InputInformation(
                              title: "*Email address",
                              controller: _txtEmail,
                              emailValidation: true,
                              boldTitle: true,
                              emptyValidation: true),
                          SizedBox(
                            height: media.width * 0.02,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              textAlign: TextAlign.start,
                              "*Mobile Number",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: media.height * 0.02,
                              ),
                            ),
                          ),
                          const SizedBox(height: 2),
                          CustomMobileNumberField(mobileController: _txtPhone),
                          SizedBox(
                            height: media.width * 0.02,
                          ),
                          InputInformation(
                            title: "*Password",
                            controller: _txtEmailPassword,
                            boldTitle: true,
                            passwordValidation: true,
                            emptyValidation: true,
                            obscureText: !showPassword,
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    if (showPassword) {
                                      showPassword = false;
                                    } else {
                                      showPassword = true;
                                    }
                                  });
                                },
                                icon: Icon(
                                  Icons.remove_red_eye_sharp,
                                  color: (showPassword == true)
                                      ? const Color(0xff60b0b2)
                                      : null,
                                )),
                          ),
                          SizedBox(
                            height: media.width * 0.02,
                          ),
                          InputInformation(
                              title: "*Re-type passowrd",
                              emptyValidation: true,
                              obscureText: !_retypepassword,
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      if (_retypepassword) {
                                        _retypepassword = false;
                                      } else {
                                        _retypepassword = true;
                                      }
                                    });
                                  },
                                  icon: Icon(
                                    Icons.remove_red_eye_sharp,
                                    color: (_retypepassword == true)
                                        ? const Color(0xff60b0b2)
                                        : null,
                                  )),
                              boldTitle: true,
                              controller: _txtReTypePassword),
                          SizedBox(
                            height: media.width * 0.1,
                          ),
                          Button(
                              onTap: () async {
                                if (_formKey.currentState!.validate()) {
                                  if (_txtEmailPassword.text ==
                                      _txtReTypePassword.text) {
                                    requestData = {
                                      "name": _txtFirstName.text,
                                      "email": _txtEmail.text,
                                      "password": _txtEmailPassword.text,
                                      "last_name": _txtLastName.text,
                                      "country": _txtCountryCode.text,
                                      "mobile": _txtPhone.text,
                                      "terms_condition": 1,
                                      "profile_picture": proImageFile1
                                    };
                                    log("requestData=======>${requestData}");

                                    _txtFirstName.clear();
                                    _txtEmail.clear();
                                    _txtEmailPassword.clear();
                                    _txtLastName.clear();
                                    _txtPhone.clear();
                                    _txtReTypePassword.clear();
                                    proImageFile1 = null;

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const StepPageView(),
                                      ),
                                    );
                                  } else {
                                    showSnackBar(
                                        context, "Passwords do not match");
                                  }
                                }
                              },
                              text: "Submit",
                              color: theme,
                              textcolor: buttonText,
                              borderRadius: BorderRadius.circular(10),
                              borcolor: theme),
                          SizedBox(
                            height: media.width * 0.04,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignInScreen(),
                                ),
                              );
                            },
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                text: "Already have an account? \n ",
                                style: TextStyle(
                                    fontSize: media.height * 0.017,
                                    color: const Color(0xff7C7D7E)),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'Sign In to your account',
                                    style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        fontSize: media.height * 0.017,
                                        color: theme),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  (pickImage == true)
                      ? Positioned(
                          bottom: 0,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                pickImage = false;
                              });
                            },
                            child: Container(
                              height: media.height * 1,
                              width: media.width * 1,
                              color: Colors.transparent.withOpacity(0.6),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(media.width * 0.05),
                                    width: media.width * 1,
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(25),
                                            topRight: Radius.circular(25)),
                                        border: Border.all(
                                          color: borderLines,
                                          width: 1.2,
                                        ),
                                        color: page),
                                    child: Column(
                                      children: [
                                        Container(
                                          height: media.width * 0.02,
                                          width: media.width * 0.15,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                media.width * 0.01),
                                            color: Colors.grey,
                                          ),
                                        ),
                                        SizedBox(
                                          height: media.width * 0.05,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Column(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    pickImageFromCamera();
                                                  },
                                                  child: Container(
                                                      height:
                                                          media.width * 0.171,
                                                      width:
                                                          media.width * 0.171,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color:
                                                                  borderLines,
                                                              width: 1.2),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      12)),
                                                      child: Icon(
                                                        Icons
                                                            .camera_alt_outlined,
                                                        size:
                                                            media.width * 0.064,
                                                        color: textColor,
                                                      )),
                                                ),
                                                SizedBox(
                                                  height: media.width * 0.02,
                                                ),
                                                MyText(
                                                  text:
                                                      languages[choosenLanguage]
                                                          ['text_camera'],
                                                  size: media.width * ten,
                                                  color: textColor
                                                      .withOpacity(0.4),
                                                )
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    pickImageFromGallery();
                                                  },
                                                  child: Container(
                                                      height:
                                                          media.width * 0.171,
                                                      width:
                                                          media.width * 0.171,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color:
                                                                  borderLines,
                                                              width: 1.2),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      12)),
                                                      child: Icon(
                                                        Icons.image_outlined,
                                                        size:
                                                            media.width * 0.064,
                                                        color: textColor,
                                                      )),
                                                ),
                                                SizedBox(
                                                  height: media.width * 0.02,
                                                ),
                                                MyText(
                                                  text:
                                                      languages[choosenLanguage]
                                                          ['text_gallery'],
                                                  size: media.width * ten,
                                                  color: textColor
                                                      .withOpacity(0.4),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ))
                      : Container(),
                ],
              );
            }),
      ),
    );
  }
}

class CustomMobileNumberField extends StatefulWidget {
  final TextEditingController mobileController;

  const CustomMobileNumberField({super.key, required this.mobileController});

  @override
  State<CustomMobileNumberField> createState() =>
      _CustomMobileNumberFieldState();
}

class _CustomMobileNumberFieldState extends State<CustomMobileNumberField> {
  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    return Container(
      height: 56,
      width: media.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
              width: 42,
              child: TextField(
                onTap: () => _showCountryCodeDropdown(context),
                textAlign: TextAlign.center,
                controller: _txtCountryCode,
                readOnly: true,
                decoration: const InputDecoration(border: InputBorder.none),
              )),
          const VerticalDivider(
            indent: 10,
            endIndent: 10,
          ),
          const SizedBox(width: 8),
          // Mobile Number Text Field
          Expanded(
            child: TextFormField(
              controller: widget.mobileController,
              keyboardType: TextInputType.phone,
              maxLength: 10,
              decoration: const InputDecoration(
                counterText: "",
                border: InputBorder.none,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "* This field is required!";
                }
                final mobileRegex = RegExp(r'^\d{9,10}$');
                if (!mobileRegex.hasMatch(value)) {
                  return "Please enter a valid mobile number";
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showCountryCodeDropdown(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          child: ListView(
            children: _countryCodes.map((Map<String, String> country) {
              return ListTile(
                title: Text("${country["country"]} (${country["code"]})"),
                onTap: () {
                  setState(() {
                    _txtCountryCode.text = country["code"]!;
                    print(country["code"]);
                  });
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

final List<Map<String, String>> _countryCodes = [
  {"code": "+1", "country": "USA/Canada"},
  {"code": "+7", "country": "Russia/Kazakhstan"},
  {"code": "+20", "country": "Egypt"},
  {"code": "+27", "country": "South Africa"},
  {"code": "+30", "country": "Greece"},
  {"code": "+31", "country": "Netherlands"},
  {"code": "+32", "country": "Belgium"},
  {"code": "+33", "country": "France"},
  {"code": "+34", "country": "Spain"},
  {"code": "+36", "country": "Hungary"},
  {"code": "+39", "country": "Italy"},
  {"code": "+40", "country": "Romania"},
  {"code": "+41", "country": "Switzerland"},
  {"code": "+43", "country": "Austria"},
  {"code": "+44", "country": "United Kingdom"},
  {"code": "+45", "country": "Denmark"},
  {"code": "+46", "country": "Sweden"},
  {"code": "+47", "country": "Norway"},
  {"code": "+48", "country": "Poland"},
  {"code": "+49", "country": "Germany"},
  {"code": "+51", "country": "Peru"},
  {"code": "+52", "country": "Mexico"},
  {"code": "+53", "country": "Cuba"},
  {"code": "+54", "country": "Argentina"},
  {"code": "+55", "country": "Brazil"},
  {"code": "+56", "country": "Chile"},
  {"code": "+57", "country": "Colombia"},
  {"code": "+58", "country": "Venezuela"},
  {"code": "+60", "country": "Malaysia"},
  {"code": "+61", "country": "Australia"},
  {"code": "+62", "country": "Indonesia"},
  {"code": "+63", "country": "Philippines"},
  {"code": "+64", "country": "New Zealand"},
  {"code": "+65", "country": "Singapore"},
  {"code": "+66", "country": "Thailand"},
  {"code": "+81", "country": "Japan"},
  {"code": "+82", "country": "South Korea"},
  {"code": "+84", "country": "Vietnam"},
  {"code": "+86", "country": "China"},
  {"code": "+90", "country": "Turkey"},
  {"code": "+91", "country": "India"},
  {"code": "+92", "country": "Pakistan"},
  {"code": "+93", "country": "Afghanistan"},
  {"code": "+94", "country": "Sri Lanka"},
  {"code": "+95", "country": "Myanmar"},
  {"code": "+98", "country": "Iran"},
  {"code": "+211", "country": "South Sudan"},
  {"code": "+212", "country": "Morocco"},
  {"code": "+213", "country": "Algeria"},
  {"code": "+216", "country": "Tunisia"},
  {"code": "+218", "country": "Libya"},
  {"code": "+220", "country": "Gambia"},
  {"code": "+221", "country": "Senegal"},
  {"code": "+222", "country": "Mauritania"},
  {"code": "+223", "country": "Mali"},
  {"code": "+224", "country": "Guinea"},
  {"code": "+225", "country": "Ivory Coast"},
  {"code": "+226", "country": "Burkina Faso"},
  {"code": "+227", "country": "Niger"},
  {"code": "+228", "country": "Togo"},
  {"code": "+229", "country": "Benin"},
  {"code": "+230", "country": "Mauritius"},
  {"code": "+231", "country": "Liberia"},
  {"code": "+232", "country": "Sierra Leone"},
  {"code": "+233", "country": "Ghana"},
  {"code": "+234", "country": "Nigeria"},
  {"code": "+235", "country": "Chad"},
  {"code": "+236", "country": "Central African Republic"},
  {"code": "+237", "country": "Cameroon"},
  {"code": "+238", "country": "Cape Verde"},
  {"code": "+239", "country": "São Tomé and Príncipe"},
  {"code": "+240", "country": "Equatorial Guinea"},
  {"code": "+241", "country": "Gabon"},
  {"code": "+242", "country": "Congo"},
  {"code": "+243", "country": "DR Congo"},
  {"code": "+244", "country": "Angola"},
  {"code": "+245", "country": "Guinea-Bissau"},
  {"code": "+246", "country": "British Indian Ocean Territory"},
  {"code": "+248", "country": "Seychelles"},
  {"code": "+249", "country": "Sudan"},
  {"code": "+250", "country": "Rwanda"},
  {"code": "+251", "country": "Ethiopia"},
  {"code": "+252", "country": "Somalia"},
  {"code": "+253", "country": "Djibouti"},
  {"code": "+254", "country": "Kenya"},
  {"code": "+255", "country": "Tanzania"},
  {"code": "+256", "country": "Uganda"},
  {"code": "+257", "country": "Burundi"},
  {"code": "+258", "country": "Mozambique"},
  {"code": "+260", "country": "Zambia"},
  {"code": "+261", "country": "Madagascar"},
  {"code": "+262", "country": "Réunion"},
  {"code": "+263", "country": "Zimbabwe"},
  {"code": "+264", "country": "Namibia"},
  {"code": "+265", "country": "Malawi"},
  {"code": "+266", "country": "Lesotho"},
  {"code": "+267", "country": "Botswana"},
  {"code": "+268", "country": "Eswatini"},
  {"code": "+269", "country": "Comoros"},
  {"code": "+27", "country": "South Africa"},
  {"code": "+290", "country": "Saint Helena"},
  {"code": "+291", "country": "Eritrea"},
  {"code": "+297", "country": "Aruba"},
  {"code": "+298", "country": "Faroe Islands"},
  {"code": "+299", "country": "Greenland"},
  {"code": "+350", "country": "Gibraltar"},
  {"code": "+351", "country": "Portugal"},
  {"code": "+352", "country": "Luxembourg"},
  {"code": "+353", "country": "Ireland"},
  {"code": "+354", "country": "Iceland"},
  {"code": "+355", "country": "Albania"},
  {"code": "+356", "country": "Malta"},
  {"code": "+357", "country": "Cyprus"},
  {"code": "+358", "country": "Finland"},
  {"code": "+359", "country": "Bulgaria"},
  {"code": "+370", "country": "Lithuania"},
  {"code": "+371", "country": "Latvia"},
  {"code": "+372", "country": "Estonia"},
  {"code": "+373", "country": "Moldova"},
  {"code": "+374", "country": "Armenia"},
  {"code": "+375", "country": "Belarus"},
  {"code": "+376", "country": "Andorra"},
  {"code": "+377", "country": "Monaco"},
  {"code": "+378", "country": "San Marino"},
  {"code": "+380", "country": "Ukraine"},
  {"code": "+381", "country": "Serbia"},
  {"code": "+382", "country": "Montenegro"},
  {"code": "+383", "country": "Kosovo"},
  {"code": "+385", "country": "Croatia"},
  {"code": "+386", "country": "Slovenia"},
  {"code": "+387", "country": "Bosnia and Herzegovina"},
  {"code": "+389", "country": "North Macedonia"},
  {"code": "+420", "country": "Czech Republic"},
  {"code": "+421", "country": "Slovakia"},
  {"code": "+423", "country": "Liechtenstein"},
];
