import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';

import '../bloc/world/world_bloc.dart';

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

class WebSocketManager {
  final List<WebSocketChannel> _channels = [];

  void handleConnection(WebSocketChannel channel) {
    _channels.add(channel);

    channel.stream.listen(
      (message) {
        print('Received message: $message');
        broadcast(message);
      },
      onDone: () {
        print('Connection closed');
        _channels.remove(channel);
      },
    );
  }

  void broadcast(dynamic message) {
    for (final channel in _channels) {
      channel.sink.add(message);
    }
  }
}
