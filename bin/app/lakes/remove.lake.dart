import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';

import '../../core/services/db_service.dart';
import 'model.lake.dart';

class RemoveLakes {
  final DbService dbService;

  RemoveLakes(this.dbService);

  Future<Response> call(Request req) async {
    var body = await req.readAsString();
    if (body.isEmpty) {
      return Response.badRequest(
        body: json.encode({'erro': 'falta o parametro lake'}),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
        },
      );
    }
    var dado = ModelLake.fromJson(json.decode(body));
    var collection = dbService.db.collection(ModelLake.collectionId);
    var lakes = await collection.remove(where.id(ObjectId.parse(dado.id!)));
    return Response.ok(
      json.encode(lakes),
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
      },
    );
  }
}
