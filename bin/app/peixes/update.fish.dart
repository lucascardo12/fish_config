import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';

import '../../core/services/db_service.dart';
import '../../server.dart';
import '../lakes/model.lake.dart';
import 'model.fish.dart';

class UpdateFish {
  final DbService dbService;

  UpdateFish(this.dbService);

  Future<Response> call(Request req) async {
    var body = await req.readAsString();
    if (body.isEmpty) {
      return Response.badRequest(
        body: json.encode({'erro': 'Falta o fish'}),
        headers: header,
      );
    }
    try {
      var fish = ModelFish.fromJson(json.decode(body));
      if (await verificarLake(fish.idLake)) {
        return Response.badRequest(
          body: json.encode({'erro': 'Não encontrei o lake'}),
          headers: header,
        );
      }
      dbService.db
          .collection(ModelFish.collectionId)
          .modernUpdate(where.id(ObjectId.parse(fish.id!)), fish.toJson());
    } catch (e) {
      dynamic erro = e;
      return Response.badRequest(
        body: json.encode({'erro': e.toString(), 'stack': erro.stackTrace.toString()}),
        headers: header,
      );
    }

    return Response.ok(
      json.encode({'status': 'sucesso'}),
      headers: header,
    );
  }

  Future<bool> verificarLake(String idLake) async {
    var lake = await dbService.db.collection(ModelLake.collectionId).modernFindOne(
          selector: where.id(ObjectId.parse(idLake)),
        );
    return lake == null;
  }

  Future<bool> verificarCampoFish(String fieldName) async {
    var dados = await dbService.db.collection(ModelFish.collectionId).modernFindOne(
          selector: where.eq('name', fieldName),
        );
    return dados != null;
  }
}
