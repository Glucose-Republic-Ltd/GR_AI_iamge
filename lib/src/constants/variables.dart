import 'dart:io';
import 'package:get/get.dart';

import '../model/prediction_model.dart';

Rx<File?> image = Rx<File?>(null);
String mLPredictionBaseURl = 'https://aa-api-7hrpnkb23q-nw.a.run.app/predict';
var packagePredictionList = RxList<PredictionMlModel>().obs;
String imageName = "";

// response from database
RxString nameOfMeal = "".obs;
RxBool isMeal = false.obs;
RxBool packageIsLoading = false.obs;
dynamic responseData;
RxString? downloadURL = "".obs;
RxList<Map<String, dynamic>> packageChartDataList =
    <Map<String, dynamic>>[].obs;

// final totals of the meals.
RxDouble totalCalories = 0.0.obs;
RxDouble totalCarbs = 0.0.obs;
RxDouble totalFat = 0.0.obs;
RxDouble totalProtein = 0.0.obs;
RxDouble totalServingSize = 0.0.obs;
RxDouble totalSugar = 0.0.obs;


// clear all 
packageClearAll() {
      image.value = null;
      downloadURL = "".obs;
      packagePredictionList.value.clear();
      nameOfMeal.value = "";
      totalCalories.value = 0;
      totalCarbs.value = 0;
      totalFat.value = 0;
      totalProtein.value = 0;
      totalServingSize.value = 0;
      totalSugar.value = 0;
      packageChartDataList.clear();
    }