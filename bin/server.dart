import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

import 'app/lakes/create.lake.dart';
import 'app/lakes/lakes.list.dart';
import 'app/lakes/remove.lake.dart';
import 'app/peixes/create.fish.dart';
import 'app/peixes/list.fishes.dart';
import 'app/peixes/remove.fish.dart';
import 'core/middlewares/authorize.dart';
import 'core/services/db_service.dart';

final db = DbService();
void main(List<String> args) async {
  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;
  await db.inicialise();
// Configure routes.
  final _router = Router()
    ..get('/lakes', ListLakes(db))
    ..get('/fishes', ListFishes(db))
    ..post('/lake.create', CreateLake(db))
    ..post('/fish.create', CreateFish(db))
    ..delete('/fish.remove', RemoveFishes(db))
    ..delete('/lake.remove', RemoveLakes(db));

  // Configure a pipeline that logs requests.
  final _handler = Pipeline().addMiddleware(logRequests()).addMiddleware(Authorize()).addHandler(_router);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(_handler, ip, port);
  print('Server listening on port ${server.port}');
}
