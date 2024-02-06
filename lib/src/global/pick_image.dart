import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../constants/variables.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

Future<File?> pickImage(ImageSource source) async {
  final ImagePicker _picker = ImagePicker();

  XFile? xFile = await _picker.pickImage(source: source);
  if (xFile != null) {
    File file = File(xFile.path);

    // Check if the file size is larger than 200KB
    if (await file.length() > 200 * 1024) {
      // Compress the file
      final Uint8List? compressedData =
          await FlutterImageCompress.compressWithFile(
        file.absolute.path,
        minWidth: 1024,
        minHeight: 1024,
        quality: 88,
      );

      if (compressedData != null) {
        final String dir = file.parent.path;
        final String newPath =
            '$dir/${DateTime.now().millisecondsSinceEpoch}.jpg';
        file = await File(newPath).writeAsBytes(compressedData);
      }
    }

    image.value = file; // Set the picked and possibly compressed image
    return file;
  }
  return null;
}

void showImageSourceDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Pick an image from:'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.camera),
              title: const Text('Camera'),
              onTap: () async {
                Navigator.of(context).pop();
                image.value = await pickImage(ImageSource.camera);
                // Use the image
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_album),
              title: const Text('Gallery'),
              onTap: () async {
                Navigator.of(context).pop();
                image.value = await pickImage(ImageSource.gallery);
                // Use the image
              },
            ),
          ],
        ),
      );
    },
  );
}
