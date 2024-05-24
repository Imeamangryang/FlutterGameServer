import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';

import '../core/websocketmanager.dart';

final webSocketManager = WebSocketManager();

List<String> berryList = [
  'belue-berry',
  'bluk-berry',
  'cheri-berry',
  'chesto-berry',
  'durin-berry',
  'enigma-berry',
  'figy-berry',
  'grepa-berry',
  'leppa-berry',
  'lum-berry',
  'mago-berry',
  'oran-berry',
  'pamtre-berry',
  'pecha-berry',
  'persim-berry',
  'rawst-berry',
  'sitrus-berry',
  'wiki-berry',
  'yache-berry'
];
bool timerStarted = false;

Future<Response> onRequest(RequestContext context) async {
  final handler = webSocketHandler(
    (channel, protocol) {
      print('Connected');
      //final bloc = context.read<WorldBloc>()..subscribe(channel);

      // Send Message
      // channel.sink.add('Hello from the server');
      // channel.sink.add(bloc.state.toString());

      // 10초마다 메시지 전송 타이머 설정
      if (!timerStarted) {
        timerStarted = true;
        Timer.periodic(const Duration(seconds: 10), (timer) {
          // 랜덤 값 생성
          final double posx = Random().nextInt(200) + 200;
          final double posy = Random().nextInt(200) + 200;
          final berry = berryList[Random().nextInt(berryList.length)];

          // 메시지 생성 및 전송
          final message = jsonEncode({
            'Event': 'SpawnBerry', // 이벤트명 설정 (예시)
            'PosX': posx,
            'PosY': posy,
            'Message': berry,
          });
          webSocketManager.broadcastAll(message);
        });
      }

      webSocketManager.handleConnection(channel);
    },
  );

  return handler(context);
}
