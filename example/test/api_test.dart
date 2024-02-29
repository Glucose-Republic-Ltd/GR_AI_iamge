import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

void main() async {
  String imageUrl =
      "https://imgs.search.brave.com/dYJfnWNdptqNPNfSA_sBujyw6U3DFJ1gi2TgzSy9BDM/rs:fit:860:0:0/g:ce/aHR0cHM6Ly9tZWRp/YS5pc3RvY2twaG90/by5jb20vaWQvMTE0/NzQ5NzE2MC9waG90/by9jb2ZmZWUtY3Vw/LmpwZz9zPTYxMng2/MTImdz0wJms9MjAm/Yz1sb202dTlPbVhQ/UU9XTHNld0xrTmsz/NU1Sb2xEWThYbDMx/RFZ3LVZGd1A4PQ";

  var url = Uri.parse(
      'https://open-ai-recipe-r5gvld6y7q-nw.a.run.app/api/analyze_image');

  var response = await http.post(url, body: {'image_url': imageUrl, "is_meal": "true"});

  group('Testing the api', () {
    test('Test for 200', () {
      int responseCode = response.statusCode;
      print(response.body);
      expect(responseCode, 200,
          reason: "Expected 200, but got: $responseCode , ${response.body}");
    });
  });
}
