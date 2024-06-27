import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_image_ai_package/src/model/prediction_model.dart';
import 'package:http/http.dart' as http;

import '../../export_packages.dart';

class MLPredictionController extends GetxController {
  var url = Uri.parse(mLPredictionBaseURl);
  var headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  Future getPrediction({
    required double servingWeightGrams,
    required double calories,
    required double fat,
    required double totalCarbohydrates,
    required double protein,
    required double sugars,
    required int timeDifference,
    double startGlucose = 0,
    DateTime? timeEaten,
  }) async {
    var body = jsonEncode({
      "serving_weight_grams": servingWeightGrams,
      "calories": calories,
      "fat": fat,
      "total_carbohydrates": totalCarbohydrates,
      "protein": protein,
      "sugars": sugars,
      'time_difference': timeDifference,
      "start_glucose": startGlucose
    });
    print("sending data to prediction");

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

          if (packagePredictionList.value.length > 0) {
            packageGetChartData();
          }
          if (packageIsLoading.value == true) {
            packageIsLoading.toggle();
          }
          break;
        default:
          print("Did not get good response: $responseCode");
          if (packageIsLoading.value == true) {
            packageIsLoading.toggle();
          }
          Get.snackbar('Error', 'Something went wrong',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white);
      }
    } catch (e) {
      print("Got an Error: $e");
      if (packageIsLoading.value == true) {
        packageIsLoading.toggle();
      }
      throw Exception(e);
    }
  }
}
