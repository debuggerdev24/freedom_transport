import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_user/functions/functions.dart';
import 'package:flutter_user/pages/communityPage/signin.dart';
import 'package:http/http.dart' as http;
import '../../onTripPage/map_page.dart';

class ApiService {
  ApiService._();
  static ApiService apiService = ApiService._();

  Future<void> sendUserDataToApi(
      Map<String, dynamic> requestData, BuildContext context) async {
    Uri uri = Uri.parse("${url}api/v1/user/register");
    try {
      http.Response response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestData),
      );
      debugPrint("Response Status: ${response.statusCode}");
      debugPrint("Map: ${requestData}");
      debugPrint("Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const SignInScreen()));
      } else if (response.statusCode == 422) {
        var errorData = jsonDecode(response.body);
        print("Failed to register: ${errorData['message']}");
      } else {
        // status codes when error comes
        print("${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }
}

void showSnackBar(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(msg),
      duration: const Duration(seconds: 5),
    ),
  );
}