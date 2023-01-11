import 'package:flutter/material.dart';

class Leaderboard extends StatefulWidget {
  Leaderboard({Key? key, required this.scrores}) : super(key: key);
  List<dynamic> scrores;

  @override
  _LeaderboardState createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: const <DataColumn>[
        DataColumn(
          label: Text(
            'Name',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
        DataColumn(
          label: Text(
            'Score',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
        DataColumn(
          label: Text(
            'Date',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
      ],
      rows: <DataRow>[
        ...List.generate(widget.scrores.length, (index) {
          var data = widget.scrores.elementAt((index));
          return DataRow(
            cells: <DataCell>[
              DataCell(Text(data["name"])),
              DataCell(Text(data["score"])),
              DataCell(Text(data["date"])),
            ],
          );
        }).toList(),
      ],
    );
  }
}
