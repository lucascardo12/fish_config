import 'dart:async';
import 'dart:convert';

import 'package:shelf/shelf.dart';

import '../../server.dart';

class Authorize {
  FutureOr<Response> Function(Request) call(innerHandler) {
    return (request) async {
      final authorizationHeader = request.headers['Authorization'] ?? request.headers['authorization'];

      if (authorizationHeader == null) {
        return Response.ok(json.encode({'erro': 'Sem acesso'}));
      }

      if (!authorizationHeader.startsWith('Bearer ')) {
        return Response.ok(json.encode({'erro': 'Sem acesso'}));
      }

      final token = authorizationHeader.replaceFirst('Bearer', '').trim();

      if (!token.trim().contains(envs['TOKEN_API'] ?? '')) {
        return Response.ok(json.encode({'erro': 'Sem acesso'}));
      }

      return Future.sync(() => innerHandler(request)).then((response) {
        return response;
      });
    };
  }
}
