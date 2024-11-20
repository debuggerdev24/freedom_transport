import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_user/functions/functions.dart';
import 'package:flutter_user/pages/communityPage/signin.dart';
import 'package:http/http.dart' as http;
import '../../onTripPage/map_page.dart';

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ApiService {
  ApiService._();
  static ApiService apiService = ApiService._();

  Future<void> sendUserDataToApi(
      Map<String, dynamic> requestData, BuildContext context) async {
    clearToken();
    Uri uri = Uri.parse("${url}api/v1/user/register");
    try {
      http.Response response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestData),
      );

      debugPrint("Response Status: ${response.statusCode}");
      debugPrint("Map: $requestData");
      debugPrint("Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseBody = jsonDecode(response.body);
        log('adding token');

        bearerToken.add(BearerClass(
            type: responseBody['token_type'].toString(),
            token: responseBody['access_token'].toString()));
        pref.setString('Bearer', bearerToken[0].token);
        await getUserDetails();
        log('fetched user details.');
        showSnackBar(context, "Registration successful!");

        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const Maps()));
      } else if (response.statusCode == 422) {
        var errorData = jsonDecode(response.body);

        showSnackBar(context, "Failed to register: ${errorData['message']}");
      } else if (response.statusCode == 500) {
        var errorData = jsonDecode(response.body);
        showSnackBar(context, " ${errorData['message']}");
      }
    } catch (e) {
      showSnackBar(context, "Error: $e");
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
