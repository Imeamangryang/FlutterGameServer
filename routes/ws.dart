import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';

Future<Response> onRequest(RequestContext context) async {
  final handler = webSocketHandler(
    (channel, protocol) {
      print('Connected');

      // Send Message
      channel.sink.add('Hello from the server');

      // Received Message
      channel.stream.listen(
        (message) {
          print(message);
          channel.sink.add(message);
        },
        onDone: () => print('disconnected'),
      );
    },
  );

  return handler(context);
}
