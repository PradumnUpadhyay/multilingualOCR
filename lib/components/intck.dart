import 'dart:io';

class Intcker {
  static bool connect = false;
  static Future<void> checkConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        connect = true;
        print('connected');
      }
    } on SocketException catch (_) {
      connect = false;
      print('not connected');
    }
  }
}
