import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'dart:math';

void main() async {
  var passphrase = 'GR:Lock';
  var encryptedPassphrase = '';
  var decryptedPassphrase = '';

  String caesarCipherEncrypt(String text, int shift) {
    // Generate a random salt
    var rng = new Random();
    var frontSalt =
        String.fromCharCodes(List.generate(6, (_) => rng.nextInt(33) + 89));
    var backSalt =
        String.fromCharCodes(List.generate(8, (_) => rng.nextInt(33) + 89));

    // Add the salt to the front and end of the text
    text = frontSalt + text + backSalt;
    base64Encode(text.codeUnits);

    return String.fromCharCodes(
      text.runes.map((rune) {
        var newRune = rune + shift;

        return newRune;
      }),
    );
  }

  String caesarCipherDecrypt(String text, int shift) {
    // Subtract the shift from each character
    text = String.fromCharCodes(
      text.runes.map((rune) {
        var newRune = rune - shift;

        return newRune;
      }),
    );
    // Remove the salts from the front and end of the text
    text = text.substring(6, text.length - 8);

    return text;
  }

  group("Text the Encryption and decryption of the words", () {
    test("Testing encryption first", () {
      encryptedPassphrase = caesarCipherEncrypt(passphrase, 3);
      print(encryptedPassphrase);
    });
    test("Testing Decryption second", () {
      decryptedPassphrase = caesarCipherDecrypt(encryptedPassphrase, 3);
      expect(decryptedPassphrase, "GR:Lock");
    });
  });
}
