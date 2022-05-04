import 'dart:async';

import 'package:shelf/shelf.dart';
import '../configs/credenciais.dart';

class Authorize {
  FutureOr<Response> Function(Request) call(innerHandler) {
    return (request) async {
      final authorizationHeader = request.headers['Authorization'] ?? request.headers['authorization'];

      if (authorizationHeader == null) {
        return Response(401);
      }

      if (!authorizationHeader.startsWith('Bearer ')) {
        return Response(401);
      }

      final token = authorizationHeader.replaceFirst('Bearer', '').trim();

      if (!token.trim().contains(Credenciais.tokenbaere)) {
        return Response(401);
      }

      return Future.sync(() => innerHandler(request)).then((response) {
        return response;
      });
    };
  }
}
