import 'dart:io';
import 'package:get/get.dart';

import '../model/prediction_model.dart';

Rx<File?> image = Rx<File?>(null);
String mLPredictionBaseURl = 'https://aa-api-7hrpnkb23q-nw.a.run.app/predict';
var predictionList = RxList<PredictionMlModel>().obs;


// response from database
RxString nameOfMeal = "".obs;
RxBool isMeal = false.obs;
RxBool isLoading = false.obs;
dynamic responseData;
RxString? downloadURL = "".obs;

// final totals of the meals.
RxDouble totalCalories = 0.0.obs;
RxDouble totalCarbs = 0.0.obs;
RxDouble totalFat = 0.0.obs;
RxDouble totalProtein = 0.0.obs;
RxDouble totalServingSize = 0.0.obs;
RxDouble totalSugar = 0.0.obs;
