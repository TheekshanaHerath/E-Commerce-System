import 'dart:io';
import 'package:http/io_client.dart';

class ApiService {
  static IOClient getClient() {
    final HttpClient client = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;

    return IOClient(client);
  }
}