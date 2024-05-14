import 'package:equatable/equatable.dart';

import '../../core/player.dart';

class WorldState extends Equatable {
  const WorldState({this.players = const {}, this.id});

  final String? id;
  final Map<String, Player> players;

  @override
  // TODO: implement props
  List<Object?> get props => [id, players];
}
