import 'dart:convert';

import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';

import 'player.dart';

class WebSocketManager {
  final List<WebSocketChannel> _channels = [];
  final List<Player> _players = [];
  final Map<WebSocketChannel, Player> _clients = {};

  void handleConnection(WebSocketChannel channel) {
    _channels.add(channel);

    channel.stream.listen(
      (message) {
        final data = jsonDecode(message as String);
        // ignore: avoid_dynamic_calls
        final event = data['Event'];

        final sender = channel;

        switch (event) {
          case 'JoinPlayer':
            // 참여한 클라이언트에게 모든 플레이어 정보 전달
            for (final otherplayer in _players) {
              channel.sink.add(sendMessage('AddPlayer', otherplayer));
            }

            Player player = Player();
            player.playerID = data['PlayerID'] as String;
            player.playername = data['PlayerName'] as String;
            player.character = data['Message'] as String;
            player.posx = data['PosX'] as double;
            player.posy = data['PosY'] as double;

            _players.add(player);
            _clients[sender] = player;

            // 다른 클라이언트들에게 플레이어 정보 전달
            broadcast(sendMessage('AddPlayer', player), sender);

          case 'MovePlayer':
            for (final otherplayer in _players) {
              if (data['PlayerID'] == otherplayer.playerID) {
                otherplayer
                  ..posx = data['PosX'] as double
                  ..posy = data['PosY'] as double;
              }
            }
            broadcast(message, sender);

          case 'MessageSend':
            broadcast(message, sender);
        }

        print('Received message: $message');
      },
      onDone: () {
        print('Connection closed');
        if (_clients[channel] != null) {
          final player = _clients[channel]!;
          broadcast(sendMessage('RemovePlayer', player), channel);
        }
        final targetplayer = _clients.remove(channel);
        _players.removeWhere((player) => player == targetplayer);
        _channels.remove(channel);
      },
    );
  }

  void broadcast(dynamic message, WebSocketChannel channel) {
    for (final otherchannel in _channels) {
      if (otherchannel != channel) {
        otherchannel.sink.add(message);
      }
    }
  }

  String sendMessage(String event, Player player) {
    final message = jsonEncode({
      'Event': event,
      'PlayerID': player.playerID,
      'PlayerName': player.playername,
      'PosX': player.posx,
      'PosY': player.posy,
      'Message': player.character
    });
    return message;
  }
}
