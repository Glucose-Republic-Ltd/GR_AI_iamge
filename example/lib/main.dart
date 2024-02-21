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
                  Get.find<GRImageController>().sendImageToAPI(_image);
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
                  return foodItems.length > 0
                      ? ListView.builder(
                          itemCount: foodItems.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15.0),
                                child: BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                  child: Container(
                                    height: 150, // Set as needed
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(15.0),
                                      border: Border.all(
                                        width: 1.5,
                                        color: Colors.white.withOpacity(0.3),
                                      ),
                                    ),
                                    child: Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Column(
                                          children: [
                                            Text(
                                                "Name: ${foodItems[index].name}"),
                                            Text(
                                                "Calories: ${foodItems[index].calories}"),
                                            Text(
                                                "Carbs: ${foodItems[index].carbs}"),
                                            Text(
                                                "Fat: ${foodItems[index].fat}"),
                                            Text(
                                                "Protein: ${foodItems[index].protein}"),
                                            Text(
                                                "Serving Size: ${foodItems[index].servingSize}"),
                                            Text(
                                                "Sugar: ${foodItems[index].sugar}"),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          })
                      : Container();
                }),
              ],
            );
    });
  }
}
