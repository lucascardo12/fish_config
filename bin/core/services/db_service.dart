import 'package:mongo_dart/mongo_dart.dart';

class DbService {
  final db = Db("mongodb://localhost:27017/fish");
  Future<void> inicialise() async {
    await db.open();
  }
}
