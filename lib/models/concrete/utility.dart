import 'dart:convert';
import 'dart:typed_data';

class Utility {

  static Uint8List convertToUint8List(String base64String) {
    return base64Decode(base64String);
  } // Resim İçin Buradan Data Gelecek

  static String convertToString(Uint8List data) {
    return base64Encode(data);
  } // Resimden Stringe
}