import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

import 'app/lakes/create.lake.dart';
import 'app/lakes/lakes.list.dart';
import 'app/lakes/remove.lake.dart';
import 'app/lakes/update.lake.dart';
import 'app/peixes/create.fish.dart';
import 'app/peixes/list.fishes.dart';
import 'app/peixes/remove.fish.dart';
import 'app/peixes/update.fish.dart';
import 'core/middlewares/authorize.dart';
import 'core/services/db_service.dart';

final db = DbService();
Map<String, String> envs = Platform.environment;
const Map<String, String> header = {
  'Content-Type': 'application/json; charset=utf-8',
};
void main(List<String> args) async {
  await db.inicialise();
  // Configure routes.
  final _router = Router()
    ..get('/lakes', ListLakes(db))
    ..get('/fishes', ListFishes(db))
    ..post('/lake.create', CreateLake(db))
    ..put('/lake.update', UpdateLake(db))
    ..post('/fish.create', CreateFish(db))
    ..put('/fish.update', UpdateFish(db))
    ..delete('/fish.remove', RemoveFishes(db))
    ..delete('/lake.remove', RemoveLakes(db));
  // Configure a pipeline that logs requests.
  final _handler = Pipeline().addMiddleware(logRequests()).addMiddleware(Authorize()).addHandler(_router);
  // For running in containers, we respect the PORT environment variable.
  final server = await serve(_handler, InternetAddress.anyIPv4, int.parse(envs['PORT'] ?? '80'));
  print('Server listening on port ${server.port}');
}
