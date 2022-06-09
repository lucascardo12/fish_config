import 'dart:convert';
import 'package:shelf/shelf.dart';

import '../../core/services/db_service.dart';
import '../../server.dart';
import 'model.lake.dart';

class UpdateLake {
  final DbService dbService;

  UpdateLake(this.dbService);

  Future<Response> call(Request req) async {
    var body = await req.readAsString();
    if (body.isEmpty) {
      return Response.badRequest(
        body: json.encode({'erro': 'falta o parametro lake'}),
        headers: header,
      );
    }
    try {
      var lake = ModelLake.fromJson(json.decode(body));
      var map = await dbService.db.collection(ModelLake.collectionId).replaceOne(
        {'_id': lake.id},
        lake.toJson(),
      );
      if (map.nModified > 0) {
        return Response.ok(
          json.encode({'status': 'sucesso'}),
          headers: header,
        );
      }
      return Response.ok(
        json.encode({'erro': map.errmsg}),
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
