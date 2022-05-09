import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';

import '../../core/services/db_service.dart';
import '../lakes/model.lake.dart';
import 'model.fish.dart';

class CreateFish {
  final DbService dbService;

  CreateFish(this.dbService);

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
    try {
      var fish = ModelFish.fromJson(json.decode(body));
      if (await verificarLake(fish.idLake)) {
        return Response.badRequest(
          body: json.encode({'erro': 'não encontrei o lakeo'}),
          headers: {
            'Content-Type': 'application/json; charset=utf-8',
          },
        );
      }
      if (await verificarCampoFish(fish.name)) {
        return Response.badRequest(
          body: json.encode({'erro': 'Fish já existe'}),
          headers: {
            'Content-Type': 'application/json; charset=utf-8',
          },
        );
      }
      dbService.db.collection(ModelFish.collectionId).insert(fish.toJson());
    } catch (e) {
      dynamic erro = e;
      return Response.badRequest(
        body: json.encode({'erro': e.toString(), 'stack': erro.stackTrace.toString()}),
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
