import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:maiball/model/Games.dart';
import 'package:maiball/model/Team.dart';

class StandingsPage extends StatefulWidget {
  @override
  _StandingsPageState createState() => _StandingsPageState();
}

class _StandingsPageState extends State<StandingsPage> {
  List<Team> teams;
  List<String> _fullList = [
    'text',
    'tex1t',
    'text1',
    'text2',
  ];

  @override
  void initState() {
    getStandings();
    super.initState();
  }

  void getStandings() {
    Firestore.instance.collection("Teams").getDocuments().then((snapshots) {
      teams = new List();
      for (DocumentSnapshot snap in snapshots.documents) {
        Team team = Team.fromJson(snap.data);
        team.winCount = 0;
        team.loseCount = 0;
        team.score = 0;
        teams.add(team);
      }
      setState(() {

      });
      for (Team team in teams) {
        Firestore.instance
            .collection("Games")
            .where("awayTeamId", isEqualTo: team.id)
            .getDocuments()
            .then((snapshots) {
          for (DocumentSnapshot snap in snapshots.documents) {
            Game game = Game.fromJson(snap.data);
            if (game.awayTeamScore > game.homeTeamScore) {
              team.winCount += 1;
            } else {
              team.loseCount += 1;
            }
          }
          team.score = (team.winCount * 2) - team.loseCount * 2;
        });

        Firestore.instance
            .collection("Games")
            .where("homeTeamId", isEqualTo: team.id)
            .getDocuments()
            .then((snapshots) {
          for (DocumentSnapshot snap in snapshots.documents) {
            Game game = Game.fromJson(snap.data);
            if (game.homeTeamScore > game.awayTeamScore) {
              team.winCount += 1;
            } else {
              team.loseCount += 1;
            }
          }
          team.score = (team.winCount * 2) - team.loseCount * 2;
          setState(() {
            teams.sort((t2, t1) => t1.score.compareTo(t2.score));
          });
        });
      }


    });
  }

  _getTable() {
    return DataTable(
      columnSpacing: 10,
      columns: [
        DataColumn(
          numeric: true,
          tooltip: "Sıralama",
          label: Text('',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold)),
        ),
        DataColumn(
          label: Text('Team',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold)),
        ),
        DataColumn(
          label: Text('W',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold)),
          numeric: true,
        ),
        DataColumn(
          label: Text('L',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold)),
          numeric: true,
        ),
        DataColumn(
          label: Text('S',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold)),
          numeric: true,
        ),
      ],
      rows: teams
          .map((team) => DataRow(selected: teams.indexOf(team) < 3, cells: [
                DataCell(Text("${teams.indexOf(team) + 1}",
                    style: TextStyle(fontWeight: FontWeight.bold))),
                DataCell(Text(team.name,
                    style: TextStyle(fontWeight: FontWeight.bold))),
                DataCell(Text("${team.winCount}",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.green))),
                DataCell(Text("${team.loseCount}",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.red))),
                DataCell(Text("${team.score}",
                    style: TextStyle(fontWeight: FontWeight.bold))),
              ]))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Standings'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Column(
                children: <Widget>[
                  teams != null ? _getTable() : CircularProgressIndicator()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
