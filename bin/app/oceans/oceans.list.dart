import 'dart:convert';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';
import '../../core/services/db_service.dart';
import 'ocean.model.dart';

class ListOceans {
  final DbService dbService;

  ListOceans(this.dbService);

  Future<Response> call(Request req) async {
    var collection = dbService.db.collection(OceanModel.collectionId);
    var oceans = await collection.find(where.limit(100)).toList();
    return Response.ok(
      json.encode(oceans),
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
      },
    );
  }
}
