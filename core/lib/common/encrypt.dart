import 'package:encrypt/encrypt.dart' as enc;

String encrypt(String text) {
  final key = enc.Key.fromUtf8('my 32 length key................');
  final iv = enc.IV.fromLength(16);

  final encrypter = enc.Encrypter(enc.AES(key));
  final encrypted = encrypter.encrypt(text, iv: iv);

  return encrypted.base64;
}
