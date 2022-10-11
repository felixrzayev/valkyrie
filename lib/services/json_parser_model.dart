import 'dart:convert';

Games gamesFromJson(String str) => Games.fromJson(json.decode(str));

class Games {
  Games({
    this.name,
    this.url,
    this.matches,
  });

  String? name;
  dynamic url;
  List<Matches>? matches;

  factory Games.fromJson(Map<String, dynamic> json) => Games(
        name: json["name"],
        url: json["url"],
        matches:
            List<Matches>.from(json["matches"].map((x) => Matches.fromJson(x))),
      );
}

class Matches {
  Matches({
    this.round,
    this.date,
    this.team1,
    this.team2,
    this.score,
  });

  String? round;
  DateTime? date;
  String? team1;
  String? team2;
  String? score;

  factory Matches.fromJson(Map<String, dynamic> json) => Matches(
        round: json["round"],
        date: DateTime.parse(json["date"]),
        team1: json["team1"],
        team2: json["team2"],
        score: json["score"] == null
            ? " - : -"
            : ("${json["score"]["ft"][0]} : ${json["score"]["ft"][1]}"),
      );
}
