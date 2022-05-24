import 'dart:convert';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';
import '../../core/services/db_service.dart';
import '../../server.dart';
import 'model.lake.dart';

class ListLakes {
  final DbService dbService;

  ListLakes(this.dbService);

  Future<Response> call(Request req) async {
    var collection = dbService.db.collection(ModelLake.collectionId);
    var lakes = await collection.find(where.limit(100)).toList();
    return Response.ok(
      json.encode(lakes),
      headers: header,
    );
  }
}
