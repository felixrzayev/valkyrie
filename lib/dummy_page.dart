import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valkyrie/elements/dropdown_team_selector.dart';
import 'package:valkyrie/elements/match_display.dart';
import 'package:valkyrie/services/data_manager.dart';
import 'package:valkyrie/services/theme_manager.dart';

import 'services/json_parser_model.dart';

class GamesPage extends StatefulWidget {
  @override
  State<GamesPage> createState() => _GamesPageState();
}

class _GamesPageState extends State<GamesPage> {
  @override
  void initState() {
    context.read<DataNotifier>().readJson;
    super.initState();
  }

  bool _isOn = true;

  void toggle() {
    setState(() => _isOn = !_isOn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Premier League'),
        actions: [
          Switch(
            value: _isOn,
            activeTrackColor: Colors.white,
            activeColor: Colors.blue[800],
            onChanged: (value) {
              toggle();
              _isOn
                  ? context.read<ThemeNotifier>().setLightMode()
                  : context.read<ThemeNotifier>().setDarkMode();
            },
          ),
        ],
      ),
      body: buildBody(context),
    );
  }

  //----------------------------------------------------------------------------

  Widget buildBody(BuildContext context) {
    final dataProvider = Provider.of<DataNotifier>(context, listen: true);
    final matchesNew = dataProvider.matches;
    final uniqueTeamsNew = dataProvider.uniqueTeams;
    final selectedHomeTeam = dataProvider.homeTeam;
    final selectedAwayTeam = dataProvider.awayTeam;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              buildHomeTeamSelector(
                uniqueTeams: uniqueTeamsNew,
                onChange: dataProvider.selectHomeTeam,
                selectedTeam: selectedHomeTeam,
              ),
              const SizedBox(width: 5),
              buildAwayTeamSelector(
                uniqueTeams: uniqueTeamsNew,
                onChange: dataProvider.selectAwayTeam,
                selectedTeam: selectedAwayTeam,
              ),
              buildResetButton(() {
                dataProvider.resetMatches();
              }),
            ],
          ),
        ),
        buildListView(matchesNew),
      ],
    );
  }

  //----------------------------------------------------------------------------

  Widget buildListView(List<Matches> matches) {
    return Expanded(
      child: ListView.builder(
        itemCount: matches.length,
        itemBuilder: (context, index) => MatchDisplay(matches[index]),
      ),
    );
  }

  //----------------------------------------------------------------------------

  Widget buildHomeTeamSelector({
    required List<String> uniqueTeams,
    required onChange,
    required String? selectedTeam,
  }) =>
      DropdownTeamSelector(
        uniqueTeams: uniqueTeams,
        onChangedTeam: onChange,
        hint: 'Home',
        selectedTeam: selectedTeam,
      );

  Widget buildAwayTeamSelector({
    required List<String> uniqueTeams,
    required onChange,
    required String? selectedTeam,
  }) =>
      DropdownTeamSelector(
        uniqueTeams: uniqueTeams,
        onChangedTeam: onChange,
        hint: 'Away',
        selectedTeam: selectedTeam,
      );

  Widget buildResetButton(Function onPressed) {
    return IconButton(
      onPressed: () => onPressed(),
      icon: const Icon(Icons.restart_alt_outlined),
    );
  }
}
