import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';

import '../../core/services/db_service.dart';
import 'ocean.model.dart';

class RemoveOceans {
  final DbService dbService;

  RemoveOceans(this.dbService);

  Future<Response> call(Request req) async {
    var body = await req.readAsString();
    if (body.isEmpty) {
      return Response.badRequest(
        body: json.encode({'erro': 'falta o parametro ocean'}),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
        },
      );
    }
    var dado = OceanModel.fromJson(json.decode(body));
    var collection = dbService.db.collection(OceanModel.collectionId);
    var oceans = await collection.remove(where.id(ObjectId.parse(dado.id!)));
    return Response.ok(
      json.encode(oceans),
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
      },
    );
  }
}
