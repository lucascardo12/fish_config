import 'dart:convert';

import 'package:shelf/shelf.dart';

import '../../core/services/db_service.dart';
import '../../server.dart';
import 'model.lake.dart';

class RemoveLakes {
  final DbService dbService;

  RemoveLakes(this.dbService);

  Future<Response> call(Request req) async {
    try {
      var body = await req.readAsString();
      if (body.isEmpty) {
        return Response.badRequest(
          body: json.encode({'erro': 'falta o parametro lake'}),
          headers: header,
        );
      }
      var dado = ModelLake.fromJson(json.decode(body));
      var collection = dbService.db.collection(ModelLake.collectionId);
      var map = await collection.deleteOne({'_id': dado.id});
      if (map.nRemoved > 0) {
        return Response.ok(
          json.encode({'status': 'sucesso'}),
          headers: header,
        );
      }
      return Response.ok(
        json.encode({'erro': map.writeError?.errmsg}),
        headers: header,
      );
    } catch (e, s) {
      return Response.badRequest(
        body: json.encode({'erro': e.toString(), 'stack': s.toString()}),
        headers: header,
      );
    }
  }
}
