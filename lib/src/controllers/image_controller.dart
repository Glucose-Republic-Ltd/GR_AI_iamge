import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_image_ai_package/export_packages.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../global/random_string.dart';

class GRImageController extends GetxController {
  // Function to upload an image to Firebase Storage
  Future<String?> uploadImage(String filePath) async {
    isLoading.toggle(); // Start loading
    File file = File(filePath);
    String randomFileName =
        generateRandomString(20); // Generate a random filename
    try {
      // Upload the file to Firebase Storage
      await firebase_storage.FirebaseStorage.instance
          .ref('meal_images/$randomFileName.jpg')
          .putFile(file,
              firebase_storage.SettableMetadata(contentType: 'image/jpg'));

      // Get the download URL of the uploaded file
      downloadURL!.value = await firebase_storage.FirebaseStorage.instance
          .ref('meal_images/$randomFileName.jpg')
          .getDownloadURL()
          .whenComplete(() {
        // If the download URL is not empty, send the image to the API
        if (downloadURL!.value != "") {
          sendImageToAPI(downloadURL!.value);
        }
      });
      return downloadURL!.value;
    } on firebase_storage.FirebaseException catch (e) {
      isLoading.toggle(); // Stop loading
      // Show an error message
      Get.snackbar(
        "Error: ",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.white,
        backgroundColor: Colors.red.withOpacity(.7),
      );
      return null;
    }
  }

  // Function to send the image to the API
  Future<Map<String, dynamic>?> sendImageToAPI(String imageUrl) async {
    var url = Uri.parse(
        'https://open-ai-recipe-r5gvld6y7q-nw.a.run.app/api/analyze_image'); // Your Flask API URL


    try {
      var response = await http.post(url, body: {'image_url': imageUrl});

      if (response.statusCode == 200) {
        try {
          isLoading.toggle(); // Stop loading
          responseData = json.decode(response.body);
          return responseData;
        } catch (e) {
          isLoading.toggle(); // Stop loading
          // Show an error message
          Get.snackbar(
            "Error: ",
            e.toString(),
            snackPosition: SnackPosition.BOTTOM,
            colorText: Colors.white,
            backgroundColor: Colors.red.withOpacity(.7),
          );
        }
      }
    } catch (e) {
      // Show an error message
      Get.snackbar(
        "Error: ",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.white,
        backgroundColor: Colors.red.withOpacity(.7),
      );
    }

    return null;
  }

  // Function to delete the image from Firebase Storage
  Future<void> deleteImage(String imageUrl) async {
    try {
      await firebase_storage.FirebaseStorage.instance
          .refFromURL(imageUrl)
          .delete();
    } on firebase_storage.FirebaseException catch (e) {
      // Show an error message
      Get.snackbar(
        "Error: ",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.white,
        backgroundColor: Colors.red.withOpacity(.7),
      );
    }
  }
}
