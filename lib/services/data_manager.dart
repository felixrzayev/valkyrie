import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:valkyrie/services/json_parser_model.dart';
import 'package:http/http.dart' as http;

class DataNotifier with ChangeNotifier {
  Games _games = Games();
  List<Matches> _matches = [];
  String? _homeTeam;
  String? _awayTeam;
  List<String> _uniqueTeams = [];

  String? get homeTeam => _homeTeam;
  String? get awayTeam => _awayTeam;

  Games get games => _games;
  List<Matches> get matches => _matches;
  List<String> get uniqueTeams => _uniqueTeams;

  Future<void> _readJson() async {
    // usually FirebaseDatabase.instance is used to connect to the RealTime Database
    final Uri url = Uri.parse(
      'https://valkyrie-dd59a-default-rtdb.europe-west1.firebasedatabase.app/salam.json',
    );
    final response = await http.get(url);
    final data = await json.decode(response.body);

    _games = Games.fromJson(data);
    _matches = _games.matches!;

    Set<String> teams = <String>{};
    for (var element in _matches) {
      teams.add(element.team1.toString());
      _uniqueTeams = teams.toList();
      _uniqueTeams.sort();
    }
    notifyListeners();
  }

  Future<void> get readJson => _readJson();

  void selectHomeTeam(String selectedTeam) {
    if (_awayTeam == null) {
      _matches = _games.matches!;
      _matches = _matches.where(
        (element) {
          final homeTeams = element.team1;
          return homeTeams!.contains(selectedTeam);
        },
      ).toList();
    } else {
      _matches = _games.matches!;
      _matches = _matches.where(
        (element) {
          final homeTeams = element.team1;
          final awayTeams = element.team2;
          return homeTeams!.contains(selectedTeam) &&
              awayTeams!.contains(_awayTeam!);
        },
      ).toList();
    }
    _homeTeam = selectedTeam;
    _matches = _matches;
    notifyListeners();
  }

  void selectAwayTeam(String selectedTeam) {
    if (_homeTeam == null) {
      _matches = _matches.where(
        (element) {
          final awayTeams = element.team2;
          return awayTeams!.contains(selectedTeam);
        },
      ).toList();
    } else {
      _matches = _games.matches!;
      _matches = _matches.where((element) {
        final homeTeams = element.team1;
        final awayTeams = element.team2;
        return homeTeams!.contains(_homeTeam!) &&
            awayTeams!.contains(selectedTeam);
      }).toList();
    }
    _awayTeam = selectedTeam;
    _matches = _matches;
    notifyListeners();
  }

  void resetMatches() {
    _matches = _games.matches!;
    _homeTeam = null;
    _awayTeam = null;
    notifyListeners();
  }
}
