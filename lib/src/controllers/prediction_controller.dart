import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_image_ai_package/src/model/prediction_model.dart';
import 'package:http/http.dart' as http;

import '../../export_packages.dart';

class MLPredictionController extends GetxController {
  var url = Uri.parse(mLPredictionBaseURl);
  RxBool isLoading = false.obs;
  var headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  Future getPrediction({
    required double servingWeightGrams,
    required double calories,
    required double fat,
    required double saturatedFat,
    required double sodium,
    required double totalCarbohydrates,
    required double fiber,
    required double protein,
    required double potassium,
    required double sugars,
    required double phosphorus,
    required double vitaminA,
    required double vitaminC,
    required double calcium,
    required double iron,
    required double timeDifference,
    double startGlucose = 0,
  }) async {
    isLoading.toggle();

    var body = jsonEncode({
      "serving_weight_grams": servingWeightGrams,
      "calories": calories,
      "fat": fat,
      "saturated_fat": saturatedFat,
      "sodium": sodium,
      "total_carbohydrates": totalCarbohydrates,
      "fiber": fiber,
      "protein": protein,
      "potassium": potassium,
      "sugars": sugars,
      "phosphorus": phosphorus,
      "vitamin_a": vitaminA,
      "vitamin_c": vitaminC,
      "calcium": calcium,
      "iron": iron,
      'time_difference': timeDifference,
      "start_glucose": startGlucose
    });

    var response = await http.post(url, headers: headers, body: body);

    var jsonResponse = json.decode(response.body);
    var responseCode = response.statusCode;

     try {
      switch (responseCode) {
        case 200:
          packagePredictionList.value.clear();
          for (int i = 0; i < jsonResponse.length; i++) {
            packagePredictionList.value
                .add(PredictionMlModel.fromJson(jsonResponse[i]));
          }
          packagePredictionList.value.refresh();
          isLoading.toggle();
          isLoading.value = false;
          break;
        default:
          isLoading.toggle();
          Get.snackbar('Error', 'Something went wrong',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white);
      }
    } catch (e) {
      isLoading.toggle();
      throw Exception(e);
    }
  }
}
