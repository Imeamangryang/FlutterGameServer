import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';

import '../core/websocketmanager.dart';

final webSocketManager = WebSocketManager();

Future<Response> onRequest(RequestContext context) async {
  final handler = webSocketHandler(
    (channel, protocol) {
      print('Connected');
      //final bloc = context.read<WorldBloc>()..subscribe(channel);

      // Send Message
      // channel.sink.add('Hello from the server');
      // channel.sink.add(bloc.state.toString());

      webSocketManager.handleConnection(channel);
    },
  );

  return handler(context);
}
