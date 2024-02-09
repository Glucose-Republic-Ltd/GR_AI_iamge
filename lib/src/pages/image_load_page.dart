import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_image_ai_package/export_packages.dart';
import 'package:gr_image_ai_package/src/global/pick_image.dart';

// This is a stateless widget for the AI Image page.
class GRAiIMainPage extends StatelessWidget {
  // Constructor for this widget. It takes several parameters including widgets,
  // analyzeFunction, saveMealFunction, title, and saveIcon.
  const GRAiIMainPage({
    super.key,
    required this.widgets,
    required this.analyzeFunction,
    required this.saveMealFunction,
    required this.textAfterImageUpdate,
    this.instructionStyle,
    this.title,
    this.saveIcon,
    this.littleIconColor,
    this.floatingActionColor,
    this.avatarColor,
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
  // Text style
  final TextStyle? instructionStyle;
  // Optional color for the small icon in the CircleAvatar in the InkWell widget.
  final Color? littleIconColor;

  // Optional color for the FloatingActionButton.
  final Color? floatingActionColor;

  // Optional color for the CircleAvatar that displays the selected image.
  final Color? avatarColor;

  // Text once the image is updated
  final String textAfterImageUpdate;

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
        body: Padding(
          padding: EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  image.value != null
                      ? CircleAvatar(
                          backgroundColor: avatarColor ?? Colors.grey,
                          radius: 100, // Half of your desired size 500
                          backgroundImage: FileImage(File(image.value!.path)),
                        )
                      : InkWell(
                          onTap: () {
                            showImageSourceDialog(context);
                          },
                          child: Stack(
                            children: <Widget>[
                              CircleAvatar(
                                radius: 70,
                                child: Icon(
                                  Icons.camera_sharp,
                                  size: 70,
                                  color: Colors.white,
                                ),
                              ),
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: CircleAvatar(
                                  backgroundColor:
                                      littleIconColor ?? Colors.grey,
                                  radius: 20,
                                  child: Icon(
                                    Icons.add,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                  const SizedBox(height: 30),
                  // Display the uploaded image or a text message if no image is uploaded.
                  Obx(
                    () {
                      return image.value == null
                          ? Text(
                              '''
Take a photo or select an image of your meal or recipe
from the gallery to and let the AI do the rest.
            ''',
                              textAlign: TextAlign.center,
                              style: instructionStyle,
                            )
                          : Text(
                              textAfterImageUpdate,
                              textAlign: TextAlign.center,
                            );
                    },
                  ),
                  SizedBox(height: 20),
                  // Button to analyze the image.
                  Obx(() => ElevatedButton(
                      onPressed: image.value != null ? analyzeFunction : null,
                      child: Text("Analyze Image"))),
                  SizedBox(height: 30),
                  // Display the widgets passed to the constructor.
                  Column(
                    children: widgets,
                  )
                ],
              ),
            ),
          ),
        ),
        // Floating action button to save the meal. It's enabled only when responseData is not null.
        floatingActionButton: Obx(
          () {
            return FloatingActionButton(
              backgroundColor: floatingActionColor ?? Colors.blue,
              onPressed: downloadURL?.value != "" ? saveMealFunction : null,
              child: Icon(
                saveIcon ?? Icons.save,
                color: Colors.white,
              ),
            );
          },
        ),
      ),
    );
  }
}
