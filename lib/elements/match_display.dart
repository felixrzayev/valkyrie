import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/json_parser_model.dart';

class MatchDisplay extends StatelessWidget {
  final Matches match;
  const MatchDisplay(this.match, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.width * 0.3,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          // color: boxColor,
          border: Border.all(
            width: 1.5,
            // color: borderColor,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _logoAndTeamName(match.team1!),
            _roundScoreDate(),
            _logoAndTeamName(match.team2!),
          ],
        ),
      ),
    );
  }

  Widget _logoAndTeamName(String team) {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: Image.asset(
              "assets/logo/${team.toLowerCase()}.png",
            ),
          ),
          Text(
            team,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _roundScoreDate() {
    String datetime = DateFormat("dd MMM").format(match.date!);
    return Expanded(
      child: Center(
        child: Column(
          children: [
            Text(
              match.round!,
              // style: secondTextStyle,
            ),
            Expanded(
              child: Center(
                child: Text(
                  match.score!,
                  style: const TextStyle(
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            Text(
              datetime,
              // style: secondTextStyle,
            ),
          ],
        ),
      ),
    );
  }
}
