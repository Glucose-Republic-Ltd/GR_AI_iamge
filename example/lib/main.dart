import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_image_ai_package/export_packages.dart';

void main() {
  Get.put(ImageController());
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
    return GRAiIMagePage(
      analyzeFunction: () {
        print(image.value!.path);
        Get.find<ImageController>().sendImageToAPI(image.value!.path);
      },
      widgets: [
        Text('Hello'),
        Text('World'),
      ],
    );
  }
}
