import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:valkyrie/services/json_parser_model.dart';

class DataManager with ChangeNotifier {
  Games _games = Games();
  List<Matches> _matches = [];
  String? _url;
  String? _homeTeam;
  String? _awayTeam;
  List<String> _uniqueTeams = [];

  String? get homeTeam => _homeTeam;
  String? get awayTeam => _awayTeam;

  Games get games => _games;
  List<Matches> get matches => _matches;
  List<String> get uniqueTeams => _uniqueTeams;

  String? get url => _url;

  Future<void> _readJson() async {
    // final String response = await rootBundle.loadString('assets/en.json');
    // final data = await json.decode(response);

    final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
    var rawData = remoteConfig.getAll()['en'];
    final data = await json.decode(rawData!.asString());

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
