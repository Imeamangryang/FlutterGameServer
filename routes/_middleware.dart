import 'package:dart_frog/dart_frog.dart';

import '../bloc/world/world_bloc.dart';
import '../core/websocketmanager.dart';

final _world = WorldBloc();
final worldProvider = provider<WorldBloc>((_) => _world);

final _webSocketManager = WebSocketManager();
final webSocketManagerProvider = provider<WebSocketManager>((_) => _webSocketManager);

Handler middleware(Handler handler) {
  return handler.use(webSocketManagerProvider);
}
