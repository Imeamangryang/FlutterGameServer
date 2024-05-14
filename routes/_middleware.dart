import 'package:dart_frog/dart_frog.dart';

import '../bloc/world/world_bloc.dart';

final _world = WorldBloc();
final worldProvider = provider<WorldBloc>((_) => _world);

Handler middleware(Handler handler) {
  return handler.use(worldProvider);
}
