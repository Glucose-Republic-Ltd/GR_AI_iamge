import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_image_ai_package/export_packages.dart';

void main() {
  Get.put(GRImageController());
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    // initialRoute: Routes.SPLASH,
    // theme: appThemeData,
    defaultTransition: Transition.fade,
    // initialBinding: SplashBinding(),
    // getPages: AppPages.pages,
    home: Home(),
  ));
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return GRAiIMainPage(
      progressIndicatorColor: Colors.blue,
      textAfterImageUpdate: "Done",
      title: "AI Image", // this is optional it defaults to AI Image
      saveMealFunction: () {
        // save the meal to Firebase
      },
      analyzeFunction: () {
        if (image.value != null) {
          Get.find<GRImageController>().uploadImage(image.value!.path);
        } else {
          Get.snackbar(
            "Error: ",
            "No image selected",
            snackPosition: SnackPosition.BOTTOM,
            colorText: Colors.white,
            backgroundColor: Colors.red.withOpacity(.7),
          );
        }
      },
      widgets: [
        // show containers with the results
      ],
    );
  }
}
