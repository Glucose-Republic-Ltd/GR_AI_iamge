import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:gr_image_ai_package/export_packages.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../global/random_string.dart';

class GRImageController extends GetxController {
  Future<String?> uploadImage(String filePath) async {
    File file = File(filePath);
    String randomFileName =
        generateRandomString(20); // Generate a random filename
    try {
      // Use the random filename in the path
      await firebase_storage.FirebaseStorage.instance
          .ref('meal_images/$randomFileName.jpg')
          .putFile(file);

      // Once the file upload is complete, get the download URL
      downloadURL!.value = await firebase_storage.FirebaseStorage.instance
          .ref('meal_images/$randomFileName.jpg')
          .getDownloadURL();

      return downloadURL!.value;
    } on firebase_storage.FirebaseException catch (e) {
      // Handle any errors
      print(e);
      return null;
    }
  }

  Future<Map<String, dynamic>?> sendImageToAPI(String imageUrl) async {
    var url = Uri.parse(
        'https://gptvisionfood-koovv6g3ba-uc.a.run.app/api/analyze_image'); // Your Flask API URL

    try {
      var response = await http.post(url, body: {'image_url': imageUrl});
      print("Response hit");
      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}'); // Log the raw response
      }
      print('kDebugMode: $kDebugMode');

      if (response.statusCode == 200) {
        print("response 200");
        try {
          var responseData = json.decode(response.body);
          print("response data: $responseData");
          return responseData;
        } catch (e) {
          print(e.toString());
          if (kDebugMode) {
            print('Error parsing JSON: $e');
          }
        }
      } else {
        print(response.statusCode);
        print(response.reasonPhrase);
        if (kDebugMode) {
          print('Request failed with status: ${response.statusCode}.');
        }
      }
    } catch (e) {
      print("Error 3" + e.toString());

      if (kDebugMode) {
        print('Error sending image to API: $e');
      }
    }

    return null;
  }

  //delete the image from the storage
  Future<void> deleteImage(String imageUrl) async {
    try {
      await firebase_storage.FirebaseStorage.instance
          .refFromURL(imageUrl)
          .delete();
    } on firebase_storage.FirebaseException catch (e) {
      // Handle any errors
      print(e);
    }
  }
}
