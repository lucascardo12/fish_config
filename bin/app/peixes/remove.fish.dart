import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';

import '../../core/services/db_service.dart';
import '../../server.dart';
import 'model.fish.dart';

class RemoveFishes {
  final DbService dbService;

  RemoveFishes(this.dbService);

  Future<Response> call(Request req) async {
    try {
      var body = await req.readAsString();
      if (body.isEmpty) {
        return Response.badRequest(
          body: json.encode({'erro': 'falta o parametro fish'}),
          headers: header,
        );
      }
      var fish = ModelFish.fromJson(json.decode(body));
      var collection = dbService.db.collection(ModelFish.collectionId);
      var map = await collection.deleteOne({'_id': fish.id});
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
