import 'dart:convert';

import 'package:shelf/shelf.dart';

import '../../core/services/db_service.dart';
import '../../server.dart';
import 'model.lake.dart';

class CreateLake {
  final DbService dbService;

  CreateLake(this.dbService);

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
      dbService.db.collection(ModelLake.collectionId).insert(lake.toJson());
    } catch (e) {
      return Response.badRequest(
        body: json.encode({'erro': e.toString()}),
        headers: header,
      );
    }

    return Response.ok(
      json.encode({'status': 'sucesso'}),
      headers: header,
    );
  }
}
