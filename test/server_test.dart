import 'dart:convert';

import 'package:http/http.dart';
import 'package:test/test.dart';
import 'package:test_process/test_process.dart';

void main() {
  final lake = {'name': "lago loko"};
  final port = '8080';
  final host = 'http://localhost:$port';

  setUp(() async {
    await TestProcess.start(
      'dart',
      ['run', 'bin/server.dart'],
      environment: {'PORT': port},
    );
  });

  test('lakes', () async {
    final response = await get(Uri.parse(host + '/lakes'));
    print(response.body);
    expect(response.statusCode, 200);
    expect(json.decode(response.body), []);
  });
  test('fishes', () async {
    final response = await get(Uri.parse(host + '/fishes'));
    print(response.body);
    expect(response.statusCode, 200);
    expect(json.decode(response.body), []);
  });
  test('lake.create', () async {
    final response = await post(Uri.parse(host + '/lake.create'), body: json.encode(lake));
    print(response.body);
    expect(response.statusCode, 200);
    expect(json.decode(response.body)['status'], 'sucesso');
  });
  test('fish.create', () async {
    final response = await get(Uri.parse(host + '/'));
    expect(response.statusCode, 200);
    expect(response.body, 'Hello, World!\n');
  });
  test('fish.remove', () async {
    final response = await get(Uri.parse(host + '/'));
    expect(response.statusCode, 200);
    expect(response.body, 'Hello, World!\n');
  });
  test('lake.remove', () async {
    final response = await get(Uri.parse(host + '/'));
    expect(response.statusCode, 200);
    expect(response.body, 'Hello, World!\n');
  });
}
