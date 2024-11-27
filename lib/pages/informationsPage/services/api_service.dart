import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_user/functions/functions.dart';
import 'package:flutter_user/pages/communityPage/signin.dart';
import 'package:flutter_user/pages/communityPage/signup.dart';
import 'package:http/http.dart' as http;
import '../../onTripPage/map_page.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ApiService {
  ApiService._();
  static ApiService apiService = ApiService._();

  Future sendUserDataToApi(
      Map<String, dynamic> requestData, BuildContext context) async {
    clearToken();
    Uri uri = Uri.parse("${url}api/v1/user/register");
    try {
      var request = http.MultipartRequest('POST', uri)
        ..headers.addAll({"Content-Type": "multipart/form-data"});

      // requestData.forEach((key, value) {
      //   request.fields[key] = value.toString();
      // });

      requestData.forEach((key, value) {
        if (key == "user_ndis_details" && value is List) {
          // Handle user_ndis_details as a list with one object
          if (value.isNotEmpty && value[0] is Map<String, dynamic>) {
            value[0].forEach((nestedKey, nestedValue) {
              request.fields["$key[$nestedKey]"] = nestedValue.toString();
            });
          }
        } else if (key == "user_niisq_details" &&
            value is List) {
          // Flatten user_niisq_details
           if (value.isNotEmpty && value[0] is Map<String, dynamic>) {
            value[0].forEach((nestedKey, nestedValue) {
              request.fields["$key[$nestedKey]"] = nestedValue.toString();
            });
          }
        } else if (key == "user_private_details" &&
              value is List) {
          // Flatten user_private_details
           if (value.isNotEmpty && value[0] is Map<String, dynamic>) {
            value[0].forEach((nestedKey, nestedValue) {
              request.fields["$key[$nestedKey]"] = nestedValue.toString();
            });
          }
        } else if (key == "user_aged_details" && value is List) {
          // Flatten user_aged_details
          if (value.isNotEmpty && value[0] is Map<String, dynamic>) {
            value[0].forEach((nestedKey, nestedValue) {
              request.fields["$key[$nestedKey]"] = nestedValue.toString();
            });
          }
        } else {
          // Add other fields normally
          request.fields[key] = value.toString();
        }
      });

      // Function to flatten a nested map into key-value pairs with a base key
      // void flattenNestedFields(Map<String, dynamic> data, String baseKey,
      //     Map<String, String> output) {
      //   data.forEach((key, value) {
      //     output["$baseKey[$key]"] = value.toString();
      //   });
      // }

// Add requestData fields to request.fields
      // requestData.forEach((key, value) {
      //   if (key == "user_ndis_details" && value is List) {
      //     // Handle user_ndis_details as a list with one object
      //     if (value.isNotEmpty && value[0] is Map<String, dynamic>) {
      //       flattenNestedFields(value[0], key, request.fields);
      //     }
      //   } else if (key == "user_aged_details" &&
      //       value is Map<String, dynamic>) {
      //     // Flatten user_aged_details
      //     flattenNestedFields(value, key, request.fields);
      //   } else if (key == "user_niisq_details" &&
      //       value is Map<String, dynamic>) {
      //     // Flatten user_niisq_details
      //     flattenNestedFields(value, key, request.fields);
      //   } else if (key == "user_private_details" &&
      //       value is Map<String, dynamic>) {
      //     // Flatten user_private_details
      //     flattenNestedFields(value, key, request.fields);
      //   } else {
      //     // Add other fields normally
      //     request.fields[key] = value.toString();
      //   }
      // });

      log("prffile======>${requestData}");

      if (requestData["profile_picture"] != null) {
        request.files.add(await http.MultipartFile.fromPath(
            'profile_picture', requestData["profile_picture"]));
      }
      log("data======>${requestData["profile_picture"]}");

      var response = await request.send();

      var responseBody = await http.Response.fromStream(response);
      debugPrint("Response Status: ${response.statusCode}");
      debugPrint("Response Body: ${responseBody.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseJson = jsonDecode(responseBody.body);

        bearerToken.add(BearerClass(
            type: responseJson['token_type'].toString(),
            token: responseJson['access_token'].toString()));
        pref.setString('Bearer', bearerToken[0].token);
        log('adding token ======>${bearerToken[0].token}');
        await getUserDetails();
        log('fetched user details.');
        showSnackBar(context, "Registration successful!");

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Maps()),
            (route) => false);
      } else if (response.statusCode == 422) {
        var errorData = jsonDecode(responseBody.body);
        showSnackBar(context, "Failed to register: ${errorData['message']}");
      } else if (response.statusCode == 500) {
        var errorData = jsonDecode(responseBody.body);
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
