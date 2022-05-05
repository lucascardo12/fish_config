import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';

import '../../core/services/db_service.dart';
import 'model.fish.dart';

class RemoveFishes {
  final DbService dbService;

  RemoveFishes(this.dbService);

  Future<Response> call(Request req) async {
    var body = await req.readAsString();
    if (body.isEmpty) {
      return Response.badRequest(
        body: json.encode({'erro': 'falta o parametro fish'}),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
        },
      );
    }
    var fish = FishModel.fromJson(json.decode(body));
    var collection = dbService.db.collection(FishModel.collectionId);
    var oceans = await collection.remove(where.id(ObjectId.parse(fish.id!)));
    return Response.ok(
      json.encode(oceans),
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
      },
    );
  }
}
