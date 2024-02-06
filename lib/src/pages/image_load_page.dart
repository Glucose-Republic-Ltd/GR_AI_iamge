import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_image_ai_package/src/global/pick_image.dart';
import '../constants/variables.dart';

class GRAiIMagePage extends StatelessWidget {
  const GRAiIMagePage({
    super.key,
    required this.topWidgets,
    required this.bottomWidgets,
    required this.analyzeFunction,
  });

  final List<Widget> bottomWidgets;
  final List<Widget> topWidgets;

  final VoidCallback analyzeFunction;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GR:eat vision'),
      ),
      body: Center(
        child: Stack(
          children: [
            Column(
              children: topWidgets,
            ),
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
                    Obx(() {
                      return image.value != null
                          ? ElevatedButton(
                              onPressed: analyzeFunction,
                              child: Text("Analyze Image"))
                          : // Add onPressed function to analyze image
                          ElevatedButton(
                              onPressed: () async {
                                showImageSourceDialog(context);
                              },
                              child: const Text('Upload Image'),
                            );
                    }),
                    const SizedBox(height: 30),
                    Column(
                      children: bottomWidgets,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
