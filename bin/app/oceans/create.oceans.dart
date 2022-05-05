import 'dart:convert';

import 'package:shelf/shelf.dart';

import '../../core/services/db_service.dart';
import 'ocean.model.dart';

class CreateOcean {
  final DbService dbService;

  CreateOcean(this.dbService);

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
    try {
      var ocean = OceanModel.fromJson(json.decode(body));
      dbService.db.collection(OceanModel.collectionId).insert(ocean.toJson());
    } catch (e) {
      return Response.ok(
        json.encode({'status': e.toString()}),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
        },
      );
    }

    return Response.ok(
      json.encode({'status': 'sucesso'}),
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
      },
    );
  }
}
