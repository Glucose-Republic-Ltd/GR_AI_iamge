import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_image_ai_package/export_packages.dart';
import '../constants/variables.dart';

class GRAiIMagePage extends StatelessWidget {
  const GRAiIMagePage({
    super.key,

    required this.widgets,
    required this.analyzeFunction,
    required this.saveMealFunction,
  });

  final List<Widget> widgets;
  final VoidCallback saveMealFunction;
  final VoidCallback analyzeFunction;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
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
          title: const Text('AI Image'),
          actions: [
            IconButton(
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
                      ElevatedButton(
                          onPressed: analyzeFunction,
                          child: Text("Analyze Image"))
                      // Add onPressed function to analyze image
                      ,
                      const SizedBox(height: 30),
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
        floatingActionButton: Obx(
          () {
            return FloatingActionButton(
              onPressed: responseData.value != null ? saveMealFunction : () {},
              child: const Icon(Icons.save),
            );
          },
        ),
      ),
    );
  }
}
