import 'dart:io';
import 'package:get/get.dart';

Rx<File?> image = Rx<File?>(null);
RxString? downloadURL = "".obs;
dynamic responseData;
RxBool isLoading = false.obs;
