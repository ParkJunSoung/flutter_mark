import 'dart:convert';
import 'package:flutter_mask/model/stores.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

void main() {
  test('http 통신 테스트', () async {
    var uri = Uri.parse(
        'https://gist.githubusercontent.com/junsuk5/bb7485d5f70974deee920b8f0cd1e2f0/raw/063f64d9b343120c2cb01a6555cf9b38761b1d94/sample.json');
    var response = await http.get (uri);
    expect(response.statusCode, 200);
    // print('Request failed with status: ${response.body}.');
    Store result = Store.fromJson(json.decode(response.body));
    // expect(result.store[1],222);
    print(result.name);



  });
}

