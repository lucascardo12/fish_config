import 'package:mongo_dart/mongo_dart.dart';

import '../../server.dart';

class DbService {
  // mongoDB
  final String? loginDb = envs['LOGIN_DB'];
  final String? senhaDb = envs['SENHA_DB'];
  final String? hostDb = envs['HOST_DB'];
  final String? clusterDb = envs['CLUSTER_DB'];
  final String? formatDb = envs['FORMAT_DB'];

  late final Db db;

  Future<void> inicialise() async {
    db = await Db.create('$formatDb://$loginDb:$senhaDb@$hostDb/$clusterDb?retryWrites=true&w=majority');
    await db.open();
  }
}
