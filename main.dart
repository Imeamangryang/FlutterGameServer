import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

Future<HttpServer> run(Handler handler, InternetAddress ip, int port) {
  final ip = InternetAddress.tryParse('') ?? InternetAddress.anyIPv4;
  const port = 8888;
  return serve(handler, ip, port);
}
