import 'dart:convert';
import 'dart:math';
import 'package:encrypt/encrypt.dart' as encrypt;

void main() {
  var randomStringPrepend = generateRandomString(8);
  var randomStringAppend = generateRandomString(6);
  var passphrase = 'GR:Lock';

  var password = randomStringPrepend + passphrase + randomStringAppend;

  final key = encrypt.Key.fromUtf8(password);
  final iv = encrypt.IV.fromLength(16);

  final encrypter = encrypt.Encrypter(encrypt.AES(key));

  final encryptedPassword = encrypter.encrypt(password, iv: iv);

  print(encryptedPassword.base64);
}

String generateRandomString(int length) {
  var random = Random.secure();
  var values = List<int>.generate(length, (i) => random.nextInt(256));
  return base64UrlEncode(values);
}