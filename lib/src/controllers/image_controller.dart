import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_image_ai_package/export_packages.dart';
import 'package:gr_image_ai_package/src/controllers/prediction_controller.dart';
import 'package:gr_image_ai_package/src/model/meal_model.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../global/random_string.dart';

class GRImageController extends GetxController {
  // Function to upload an image to Firebase Storage
  Future<String?> uploadImage(
      String filePath, double startingGlucoseUnit, String isMeal) async {
    packageIsLoading.toggle(); // Start loading
    File file = File(filePath);
    String randomFileName =
        generateRandomString(20); // Generate a random filename
    try {
      // Upload the file to Firebase Storage
      await firebase_storage.FirebaseStorage.instance
          .ref('meal_images/$randomFileName')
          .putFile(file,
              firebase_storage.SettableMetadata(contentType: 'image/jpg'));
      print("sending image to firebase");
      // Get the download URL of the uploaded file
      downloadURL!.value = await firebase_storage.FirebaseStorage.instance
          .ref('meal_images/$randomFileName')
          .getDownloadURL()
          .then((value) {
        imageName = randomFileName;
        // If the download URL is not empty, send the image to the API
        if (value != "") {
          print("sending image to api");
          sendImageToAPI(
            value,
            startingGlucoseUnit,
            isMeal,
          );
        }
        return value;
      });
      return downloadURL!.value;
    } on firebase_storage.FirebaseException catch (e) {
      if (packageIsLoading.value == true) {
        packageIsLoading.toggle(); // Stop loading
      }
      print(e);
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
  Future<Map<String, dynamic>?> sendImageToAPI(
      String imageUrl, double startingGlucoseUnit, String isMeal) async {
    var url = Uri.parse(
        'https://open-ai-recipe-r5gvld6y7q-nw.a.run.app/api/analyze_image'); // Your Flask API URL

    try {
      var response = await http
          .post(url, body: {'image_url': imageUrl, "is_meal": isMeal});

      if (response.statusCode == 200) {
        try {
          responseData = json.decode(response.body);
          Map<String, dynamic> content = responseData['content'];
          nameOfMeal.value = responseData['meal_name'];

          content.entries.forEach((entry) {
            FoodItem item = FoodItem.fromJson(entry.key, entry.value);
            // Add the values of the current item to the total
            totalCalories.value += item.calories;
            totalCarbs.value += item.carbs;
            totalFat.value += item.fat;
            totalProtein.value += item.protein;
            totalServingSize.value += item.servingSize;
            totalSugar.value += item.sugar;
          });
          if (totalCalories.value != 0) {
            MLPredictionController().getPrediction(
              servingWeightGrams: totalServingSize.value,
              calories: totalCalories.value,
              fat: totalFat.value,
              saturatedFat: 0,
              sodium: 0,
              totalCarbohydrates: totalCarbs.value,
              fiber: 0,
              protein: totalProtein.value,
              potassium: 0,
              sugars: totalSugar.value,
              phosphorus: 0,
              vitaminA: 0,
              vitaminC: 0,
              calcium: 0,
              iron: 0,
              timeDifference: 0,
              startGlucose: startingGlucoseUnit,
            );
          }

          return responseData;
        } catch (e) {
          if (packageIsLoading.value == true) {
            packageIsLoading.toggle(); // Stop loading
          } // Stop loading
          print(e);

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
      print(e);

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
      if (packageIsLoading.value == true) {
        packageIsLoading.toggle(); // Stop loading
      }
      print("image deleted successfully!");
    } on firebase_storage.FirebaseException catch (e) {
      // Show an error message
      print(e);

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
