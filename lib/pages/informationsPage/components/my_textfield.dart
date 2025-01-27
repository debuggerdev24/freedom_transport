import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

// ignore: must_be_immutable
class InputInformation extends StatefulWidget {
  dynamic suffixIcon;
  final String title;
  final bool emptyValidation;
  final bool emailValidation;
  final bool mobileValidation;
  final bool passwordValidation;
  dynamic onTap;
  dynamic obscureText;
  dynamic controller;
  dynamic boldTitle;
  dynamic keyboardType;
  dynamic maxLength;
  dynamic autofocus;
  dynamic readonly;

  InputInformation({
    super.key,
    required this.title,
    this.onTap,
    this.controller,
    this.emptyValidation = false,
    this.emailValidation = false,
    this.mobileValidation = false,
    this.passwordValidation = false,
    this.suffixIcon,
    this.boldTitle = false,
    this.obscureText = false,
    this.autofocus = false,
    this.keyboardType = TextInputType.emailAddress,
    this.maxLength,
    this.readonly = false,
    // required this.textController,
  });

  @override
  State<InputInformation> createState() => _InputInformation();
}

class _InputInformation extends State<InputInformation> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            textAlign: TextAlign.start,
            widget.title,
            style: TextStyle(
              fontWeight: widget.boldTitle ? FontWeight.bold : FontWeight.w400,
              fontSize: media.height * 0.02,
            ),
          ),
          const Gap(2),
          TextFormField(
            validator: (value) {
              //empty validation
              if (widget.emptyValidation && (value!.trim().isEmpty)) {
                return "* Indicates that field is required!";
              }
              // email validation
              final emailRegex = RegExp(
                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
              if (widget.emailValidation && !emailRegex.hasMatch(value!)) {
                return "Please enter a valid email!";
              }

              //password validation
              if (widget.passwordValidation && (value!.length < 8)) {
                return "The password must be at least 8 characters!";
              }

              //mobile validation
              final mobileRegex = RegExp(r'^\d{9,10}$');
              if (widget.mobileValidation && !mobileRegex.hasMatch(value!)) {
                return "Please enter a valid mobile number!";
              }
              return null;
            },
            obscureText: widget.obscureText,
            textInputAction: TextInputAction.next,
            controller: widget.controller,
            keyboardType: widget.keyboardType,
            readOnly: widget.readonly,
            onTap: widget.onTap,
            maxLength: widget.maxLength,
            cursorHeight: 20,
            autofocus: widget.autofocus,
            decoration: InputDecoration(
              suffixIcon: widget.suffixIcon,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class SingleLineInputField extends StatefulWidget {
  dynamic suffixIcon;
  final String title;
  dynamic onTap;
  dynamic controller;
  dynamic keyboardType;
  dynamic maxLength;
  dynamic autofocus;
  bool? readonly;

  SingleLineInputField({
    super.key,
    required this.title,
    this.onTap,
    this.controller,
    this.suffixIcon,
    this.autofocus = false,
    this.keyboardType = TextInputType.emailAddress,
    this.maxLength,
    this.readonly = false,
    // required this.textController,
  });

  @override
  State<SingleLineInputField> createState() => _SingleLineInputFieldState();
}

class _SingleLineInputFieldState extends State<SingleLineInputField> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          widget.title,
          style: TextStyle(fontSize: height * 0.02),
        ),
        Expanded(
          child: SizedBox(
            height: 22,
            child: TextField(
              controller: widget.controller,
              cursorHeight: 25,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ),
        // Expanded(
        //   child:
        // ),
      ],
    );
  }
}
