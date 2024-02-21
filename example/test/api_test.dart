import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

void main() async {
  String imageUrl =
      "https://firebasestorage.googleapis.com/v0/b/grmo-mvp-staging.appspot.com/o/meal_images%2F159kAT7JsgXMijeIdgIs.jpg?alt=media&token=c42faeb9-eb7b-4b93-b1fa-60ad3a08bf05";

  var url = Uri.parse(
      'https://open-ai-recipe-r5gvld6y7q-nw.a.run.app/api/analyze_image');

  var response = await http.post(url, body: {'image_url': imageUrl});

  group('Testing the api', () {
    test('Test for 200', () {
      int responseCode = response.statusCode;
      print(response.body);
      expect(responseCode, 200,
          reason: "Expected 200, but got: $responseCode , ${response.body}");
    });
  });
}
