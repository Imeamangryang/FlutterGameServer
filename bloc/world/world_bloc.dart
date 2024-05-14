import 'package:broadcast_bloc/broadcast_bloc.dart';

import 'world.event.dart';
import 'world_state.dart';

class WorldBloc extends BroadcastBloc<WorldEvent, WorldState> {
  WorldBloc() : super(const WorldState());
}
