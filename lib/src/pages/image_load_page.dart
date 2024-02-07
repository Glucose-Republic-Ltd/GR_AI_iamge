import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_image_ai_package/export_packages.dart';

// This is a stateless widget for the AI Image page.
class GRAiIMagePage extends StatelessWidget {
  // Constructor for this widget. It takes several parameters including widgets, 
  // analyzeFunction, saveMealFunction, title, and saveIcon.
  const GRAiIMagePage({
    super.key,
    required this.widgets,
    required this.analyzeFunction,
    required this.saveMealFunction,
    this.title,
    this.saveIcon,
  });

  // Optional title for the page.
  final String? title;
  // Optional icon for the save button.
  final IconData? saveIcon;
  // List of widgets to display on the page.
  final List<Widget> widgets;
  // Function to save the meal.
  final VoidCallback saveMealFunction;
  // Function to analyze the image.
  final VoidCallback analyzeFunction;

  @override
  Widget build(BuildContext context) {
    // Use PopScope to handle the back button press.
    return PopScope(
      canPop: true,
      // When the back button is pressed, delete the image from Firebase Storage 
      // and clear the image and download URL.
      onPopInvoked: (didPop) {
        if (didPop) {
          if (downloadURL?.value != "") {
            Get.find<GRImageController>().deleteImage(downloadURL!.value);
          }
          image.value = null;
          downloadURL = "".obs;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          // Set the title of the page.
          title: Text(title ?? 'AI Image'),
          actions: [
            IconButton(
              // When the refresh button is pressed, delete the image from Firebase Storage 
              // and clear the image and download URL.
              onPressed: () {
                if (downloadURL?.value != "") {
                  Get.find<GRImageController>().deleteImage(downloadURL!.value);
                }
                image.value = null;
                downloadURL = "".obs;
              },
              icon: Icon(
                Icons.refresh,
                color: Colors.red,
              ),
            )
          ],
        ),
        body: Center(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(height: 20),
                      // Display the uploaded image or a text message if no image is uploaded.
                      Obx(() {
                        return image.value != null
                            ? CircleAvatar(
                                radius: 100, // Half of your desired size 500
                                backgroundImage:
                                    FileImage(File(image.value!.path)),
                              )
                            : const Text('No image uploaded yet');
                      }),
                      SizedBox(height: 20),
                      // Button to analyze the image.
                      ElevatedButton(
                          onPressed: analyzeFunction,
                          child: Text("Analyze Image")),
                      const SizedBox(height: 30),
                      // Display the widgets passed to the constructor.
                      Column(
                        children: widgets,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        // Floating action button to save the meal. It's enabled only when responseData is not null.
        floatingActionButton: Obx(
          () {
            return FloatingActionButton(
              onPressed: responseData.value != null ? saveMealFunction : () {},
              child: Icon(saveIcon ?? Icons.save),
            );
          },
        ),
      ),
    );
  }
}