import 'dart:io';
import 'package:path/path.dart' as p;

import 'package:http/http.dart'; // Contains a client for making API calls
import 'package:html/parser.dart'; // Contains HTML parsers to generate a Document object
import 'package:html/dom.dart'; // Contains DOM related classes for extracting data from elements
import 'package:csv/csv.dart';
initiate() async {
  var client = Client();
  Response response = await client.get(
    'https://prosettings.net/best-fortnite-settings-list/'
  );
  var document = parse(response.body);
  List<List<String>> rows = List<List<String>>();
  List <Element> players = document.querySelector('#table_1').querySelector('tbody').querySelectorAll('tr');
  for (var player in players) {
    List<Element> pds = player.querySelectorAll('td');
    List<String> row = List<String>();
    for (var pd in pds) {
      row.add(pd.text != null ? pd.text : '');
    }
    rows.add(row);
  }

  String csv = const ListToCsvConverter().convert(rows);
  File f = new File('players.csv');
  var sink = f.openWrite();
  sink.write(csv);
  await f.writeAsString(csv);
  await sink.close();
  return '';
}
