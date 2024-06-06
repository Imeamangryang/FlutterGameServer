import 'dart:convert';

import 'package:database/player.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

const playerlist = 'Player_list';
List<Player> players = [];

void main() async {
  await Hive.initFlutter('./FlutterHiveDatabase');
  await Hive.openBox<String>(playerlist);
  await Hive.openBox<List>('eventlog');
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Box<String> playerbox;
  late Box<List> eventbox;
  late final WebSocketChannel channel;

  @override
  void initState() {
    super.initState();
    playerbox = Hive.box(playerlist);
    eventbox = Hive.box('eventlog');
    channel = WebSocketChannel.connect(Uri.parse('ws://218.55.63.234:8888/ws'));

    // Listen to server
    channel.stream.listen((message) {
      final data = jsonDecode(message);
      print('Received message: $message');

      setState(() {
        switch (data['Event']) {
          case 'AddPlayer':
            players.add(Player(playerID: data['PlayerID'], playerName: data['PlayerName']));
            playerbox.put(data['PlayerID'], data['PlayerName'] + " - " + data['PlayerID']);
            break;
          default:
            break;
        }

        for (final player in players) {
          if (player.playerID == data['PlayerID']) {
            player.eventLists.add(data.toString());
            List<String> events =
                eventbox.get(player.playerID, defaultValue: [])?.cast<String>() ?? [];
            events.add(data.toString());
            eventbox.put(player.playerID, events);
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Database',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Player List'),
        ),
        body: ValueListenableBuilder(
          valueListenable: playerbox.listenable(),
          builder: (context, Box<String> box, _) {
            return ListView.builder(
              itemCount: box.length,
              itemBuilder: (context, listIndex) {
                final playerID = box.keyAt(listIndex) as String;
                final playerName = box.get(playerID) as String;

                return ExpansionTile(
                  title: Text(playerName),
                  children: (eventbox.get(playerID, defaultValue: []) as List).map((event) {
                    return ListTile(
                      title: Text(event, style: const TextStyle(fontSize: 10)),
                    );
                  }).toList(),
                );
              },
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }
}
