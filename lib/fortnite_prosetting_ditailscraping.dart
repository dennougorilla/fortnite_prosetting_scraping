import 'dart:io';

import 'package:http/http.dart'; // Contains a client for making API calls
import 'package:html/parser.dart'; // Contains HTML parsers to generate a Document object
import 'package:html/dom.dart'; // Contains DOM related classes for extracting data from elements
import 'package:csv/csv.dart';

getLink() async {
  var client = Client();
  Response response =
      await client.get('https://prosettings.net/best-fortnite-settings-list/');
  var document = parse(response.body);
  List<List<String>> linkList = List<List<String>>();
  List<Element> players = document
      .querySelector('#table_1')
      .querySelector('tbody')
      .querySelectorAll('tr');
  for (var player in players) {
    List<Element> pds = player.querySelectorAll('td');
    Element link = pds[2].querySelector('a');

    try {
      linkList.add([link.text, link.attributes['href']]);
    } catch (e) {}
  }

  return linkList;
}

getDitail() async {
  var playerLinkList = await getLink();
  List<Map<String, String>> settingList = List<Map<String, String>>();
  for (List<String> playerLink in playerLinkList) {
    var client = Client();
    Response response = await client.get(playerLink[1]);
    var document = parse(response.body);
    Element settingColumn = document.querySelector('div.x-column.x-sm.x-2-3');
    List<Element> settings =
        settingColumn.querySelectorAll('.x-block-grid-item');
    Map<String, String> row = {
 'player': '',
 'DPI': '', 
 'Sensitivity X': '', 
 'Sensitivity Y': '', 
 'Hz': '', 
 'Targeting Sensitivity': '', 
 'Scope Sensitivity': '', 
 'Wall': '', 
 'Floor': '', 
 'Stairs': '', 
 'Roof': '', 
 'Trap': '', 
 'Use': '', 
 'Building Edit': '', 
 'Reload / Rotate': '', 
 'Crouch': '', 
 'Sprint By Default': '', 
 'Inventory': '', 
 'Map': '', 
 'HUD Scale': '', 
 'Brightness': '', 
 'Color Blind Mode': '', 
 'NVIDIA Settings': '', 
 'Switch Quickbar': '', 
 'Jump': '', 
 'Slot 6': '', 
 'L-Shift': '', 
 'ADS': '', 
 'Targeting Sens.': '', 
 'Scope Sens.': '', 
 'Building Sens.': '', 
 'Edit Sens.': '', 
 'Edit Hold Time': '', 
 'Deadzone': '', 
 'L2': '', 
 'L1': '', 
 'R2': '', 
 'R1': '', 
 'D-Pad Up': '', 
 'D-Pad Left': '', 
 'D-Pad Right': '', 
 'D-Pad Down': '', 
 'Triangle': '', 
 'Square': '', 
 'Circle': '', 
 'Cross': '', 
 'L3': '', 
 'R3': '', 
 'Touch Pad': '', 
 'Options Button': '', 
 'Triangle (SCUF 1)': '', 
 'Square (SCUF 2)': '', 
 'Circle (SCUF 3)': '', 
 'Cross (SCUF 4)': '', 
 'LT': '', 
 'LB': '', 
 'RT': '', 
 'RB': '', 
 'D-Pad Right (P2)': '', 
 'Y': '', 
 'X': '', 
 'B': '', 
 'A': '', 
 'View Button': '', 
 'Menu Button': '', 
 'Triangle (SCUF 2)': '', 
 'Cross (SCUF 1)': '', 
 'Touch Pad (SCUF 2)': '', 
 'Circle (SCUF 4)': '', 
 'Motion Blur': ''
 };
    row['player'] = playerLink[0].toString();
    for (var setting in settings) {
      row[setting.querySelector('h3').text] = setting.querySelector('p').text;
    }
    settingList.add(row);
    settingList.forEach(print);
  }

  //var keys = Set();
  //for (var setting in settingList) {
  //  keys.addAll(setting.keys);
  //}
  //print(keys);

  List<List<String>> rs = List<List<String>>();
  for(var s in settingList) {
    List<String> r = List<String>();
    s.forEach((k, v) => r.add(v));
    rs.add(r);
  }

  String csv = const ListToCsvConverter().convert(rs);

  File f = new File('player_ditail.csv');
  var sink = f.openWrite();
  sink.write(csv);
  await f.writeAsString(csv);
  await sink.close();

  return settingList;
}
