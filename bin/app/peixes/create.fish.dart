import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';

import '../../core/services/db_service.dart';
import '../oceans/ocean.model.dart';
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
      var fish = FishModel.fromJson(json.decode(body));
      if (await verificarOceano(fish.idOcean)) {
        return Response.badRequest(
          body: json.encode({'erro': 'não encontrei o oceano'}),
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
      dbService.db.collection(FishModel.collectionId).insert(fish.toJson());
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

  Future<bool> verificarOceano(String idOcean) async {
    var ocean = await dbService.db.collection(OceanModel.collectionId).modernFindOne(
          selector: where.id(ObjectId.parse(idOcean)),
        );
    return ocean == null;
  }

  Future<bool> verificarCampoFish(String fieldName) async {
    var dados = await dbService.db.collection(FishModel.collectionId).modernFindOne(
          selector: where.eq('name', fieldName),
        );
    return dados != null;
  }
}
