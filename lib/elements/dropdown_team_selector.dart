import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class DropdownTeamSelector extends StatefulWidget {
  DropdownTeamSelector({
    super.key,
    required this.uniqueTeams,
    required this.onChangedTeam,
    required this.hint,
    this.selectedTeam,
  });

  List<String> uniqueTeams;
  String? selectedTeam;
  final ValueChanged<String> onChangedTeam;
  final String hint;

  @override
  State<DropdownTeamSelector> createState() => _DropdownTeamSelectorState();
}

class _DropdownTeamSelectorState extends State<DropdownTeamSelector> {
  // String? _selectedTeam;

  // @override
  // void initState() {
  //   // _selectedTeam = widget.selectedTeam;
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: DropdownButton2(
          isExpanded: true,
          hint: Text(widget.hint, textAlign: TextAlign.center),
          buttonDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(),
          ),
          dropdownWidth: 200,
          value: widget.selectedTeam,
          // value: _selectedTeam,
          items: widget.uniqueTeams
              .map<DropdownMenuItem<String>>(
                  (String value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      ))
              .toList(),
          onChanged: (value) {
            setState(
              () {
                widget.selectedTeam = value!;
                // _selectedTeam = value;
                widget.onChangedTeam(value);
              },
            );
            // widget.onChangedTeam(widget.selectedTeam);
          }),
    );
  }
}
