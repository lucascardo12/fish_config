import 'dart:convert';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';
import '../../core/services/db_service.dart';
import 'model.fish.dart';

class ListFishes {
  final DbService dbService;

  ListFishes(this.dbService);

  Future<Response> call(Request req) async {
    var collection = dbService.db.collection(ModelFish.collectionId);
    var lakes = await collection.find(where.limit(100)).toList();
    return Response.ok(
      json.encode(lakes),
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
      },
    );
  }
}
