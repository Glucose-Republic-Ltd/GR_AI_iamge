import 'dart:ui';

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
    return Obx(() {
      return isLoading.value
          ? CircularProgressIndicator()
          : GRAiIMainPage(
              progressIndicatorColor: Colors.blue,
              textAfterImageUpdate: "Done",
              title: "AI Image", // this is optional it defaults to AI Image
              saveMealFunction: () {
                // save the meal to Firebase
              },
              analyzeFunction: () {
                String _image =
                    "https://imgs.search.brave.com/aSYQ-a2cmuI1wh1nlJp1iTCZDpb_UohwJDvbPmOG3gw/rs:fit:860:0:0/g:ce/aHR0cHM6Ly9pbWcu/ZnJlZXBpay5jb20v/ZnJlZS1waG90by9k/ZWxpY2lvdXMtZnJp/ZWQtY2hpY2tlbi1w/bGF0ZV8xNDQ2Mjct/MjczODMuanBnP3Np/emU9NjI2JmV4dD1q/cGc";
                if (image.value != null) {
                  Get.find<GRImageController>().sendImageToAPI(_image, 5.0);
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
                Obx(() {
                  return nameOfMeal.value != ""
                      ? Text(
                          "${nameOfMeal.value}",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : Container();
                }),

                Obx(() {
                  return totalCalories.value != 0
                      ? Card(
                          child: Container(
                            width: 300,
                            child: Column(
                              children: [
                                Text("Total calories: ${totalCalories.value}"),
                                Text("Total carbs: ${totalCarbs.value}"),
                                Text("Total fat: ${totalFat.value}"),
                                Text("Total protein: ${totalProtein.value}"),
                                Text(
                                    "Total serving size: ${totalServingSize.value}"),
                                Text("Total sugar: ${totalSugar.value}"),
                              ],
                            ),
                          ),
                        )
                      : Container();
                }),
              ],
            );
    });
  }
}
