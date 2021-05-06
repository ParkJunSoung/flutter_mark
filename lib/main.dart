import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_mask/model/stores.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // ignore: deprecated_member_use
  final List<Store> stores = List<Store>();
  var isLoading = true;

  Future fetch() async {
    setState(() {
      isLoading = true;
    });
    var uri = Uri.parse(
        'https://gist.githubusercontent.com/junsuk5/bb7485d5f70974deee920b8f0cd1e2f0/raw/063f64d9b343120c2cb01a6555cf9b38761b1d94/sample.json');
    var response = await http.get(uri);
    final jsonResult = jsonDecode(response.body);
    final jsonstores = jsonResult['stores'];
    setState(() {
      stores.clear();
      jsonstores.forEach((e) {
        Store.fromJson(e);
        stores.add(Store.fromJson(e));
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    fetch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            '마스크재고 있는곳 : ${stores.where((e) => e.remainStat == 'plenty' || e.remainStat == 'some' || e.remainStat == 'few').length}곳'),
        actions: [
          IconButton(icon: Icon(Icons.refresh), onPressed: fetch),
        ],
      ),
      body: isLoading == true
          ? loadingWidget()
          : ListView(
              children: stores
                  .where((e) =>
                      e.remainStat == 'plenty' ||
                      e.remainStat == 'some' ||
                      e.remainStat == 'few')
                  .map((e) {
                return ListTile(
                  title: Text(e.name),
                  subtitle: Text(e.addr),
                  trailing: _buildRemainStatWidget(e),
                );
              }).toList(),
            ),
    );
  }

  Widget _buildRemainStatWidget(Store store) {
    var remainstat = '판매중지';
    var description = '판매중지';
    var color = Colors.black;
    if (store.remainStat == 'plenty') {
      remainstat = '충분';
      description = '100개 이상';
      color = Colors.green;
    }
    switch (store.remainStat) {
      case 'plenty':
        remainstat = '충분';
        description = '100개 이상';
        color = Colors.green;
        break;
      case 'some':
        remainstat = '보통';
        description = '30 ~ 100개 이상';
        color = Colors.yellow;
        break;
      case 'few':
        remainstat = '부족';
        description = '2 ~ 30개 이상';
        color = Colors.red;
        break;
      case 'empty':
        remainstat = '소진임박';
        description = '1개 이하';
        color = Colors.grey;
        break;
      default:
    }

    return Column(
      children: [
        Text(remainstat,
            style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        Text(description, style: TextStyle(color: color)),
      ],
    );
  }

  Widget loadingWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('정보를 가져오는중'),
          CircularProgressIndicator(),
        ],
      ),
    );
  }
}
