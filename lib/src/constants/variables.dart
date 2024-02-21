import 'dart:io';
import 'package:get/get.dart';
import 'package:gr_image_ai_package/src/model/meal_model.dart';

Rx<File?> image = Rx<File?>(null);

// response from database
RxString nameOfMeal = "".obs;
RxBool isMeal = false.obs;
RxBool isLoading = false.obs;
dynamic responseData;
RxString? downloadURL = "".obs;
RxList<FoodItem> foodItems = <FoodItem>[].obs;
