# GRAiIMainPage Widget

`GRAiIMainPage` is a stateless widget that provides an interface for users to upload an image of a meal or recipe, analyze it using AI, and save the results.

## Features

- Upload an image from the gallery or take a new photo.
- Analyze the uploaded image using AI.
- Save the analyzed data.
- Clear the uploaded image and analyzed data.

## Usage

To use this widget, you need to pass the following parameters:

- `widgets`: A list of widgets to display on the page.
- `analyzeFunction`: A function to analyze the uploaded image.
- `saveMealFunction`: A function to save the analyzed data.
- `textAfterImageUpdate`: Text to display after the image is updated.
- `title` (optional): The title of the page.
- `saveIcon` (optional): The icon for the save button.
- `instructionStyle` (optional): The text style for the instruction text.
- `littleIconColor` (optional): The color for the small icon in the CircleAvatar in the InkWell widget.
- `floatingActionColor` (optional): The color for the FloatingActionButton.
- `avatarColor` (optional): The color for the CircleAvatar that displays the selected image.
- `spaceColor` (optional): The color for the space around the CircleAvatar.

Here's an example of how to use it:

```dart
GRAiIMainPage(
	widgets: [Text('Widget 1'), Text('Widget 2')],
	analyzeFunction: () {
		// Your code to analyze the image
	},
	saveMealFunction: () {
		// Your code to save the analyzed data
	},
	textAfterImageUpdate: 'Image has been updated',
	title: 'AI Image',
	saveIcon: Icons.save,
	instructionStyle: TextStyle(color: Colors.black),
	littleIconColor: Colors.grey,
	floatingActionColor: Colors.blue,
	avatarColor: Colors.grey[300],
	spaceColor: Colors.white,
)
