
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maiball/model/Event.dart';
import 'package:maiball/model/Games.dart';
import 'package:maiball/model/Player.dart';

class PlayerPage extends StatefulWidget {
  Player player;


  PlayerPage(this.player);

  @override
  _PlayerPageState createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {

  List<Statistics> list;

  @override
  void initState() {
    _getGames();
    super.initState();
  }

  _getGames(){
    list = new List();
    Firestore.instance.collection("Games").where("awayTeamId",isEqualTo: widget.player.teamId).getDocuments().then((snapshot){
      List<Game> gameList = new List();
      for(DocumentSnapshot snap in snapshot.documents){
        gameList.add(Game.fromJson(snap.data));
      }

      for(Game game in gameList){
        Firestore.instance.collection("Games").document(game.id).collection("Events").where("playerId",isEqualTo: widget.player.id).getDocuments().then((snapshot){
          List<Event> events = new List();
          for(DocumentSnapshot snap in snapshot.documents){
            events.add(Event.fromJson(snap.data));
          }
          Statistics statistics = new Statistics();
          statistics.game = game;
          statistics.player = widget.player;
          statistics.eventList = events;
          setState(() {
            list.add(statistics);
          });
        });
      }
    });

    Firestore.instance.collection("Games").where("homeTeamId",isEqualTo: widget.player.teamId).getDocuments().then((snapshot){
      List<Game> gameList = new List();
      for(DocumentSnapshot snap in snapshot.documents){
        gameList.add(Game.fromJson(snap.data));
      }

      for(Game game in gameList){
        Firestore.instance.collection("Games").document(game.id).collection("Events").where("playerId",isEqualTo: widget.player.id).getDocuments().then((snapshot){
          List<Event> events = new List();
          for(DocumentSnapshot snap in snapshot.documents){
            events.add(Event.fromJson(snap.data));
          }
          Statistics statistics = new Statistics();
          statistics.game = game;
          statistics.player = widget.player;
          statistics.eventList = events;
          setState(() {
            list.add(statistics);
          });
        });
      }
    });
  }

  _getTable() {
    setState(() {
      list.sort((s1,s2)=>s1.game.date.compareTo(s2.game.date));
    });

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
          label: Text('Game',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold)),
        ),
        DataColumn(
          label: Text('S',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold)),
          numeric: true,
        ),
        DataColumn(
          label: Text('R',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold)),
          numeric: true,
        ),
        DataColumn(
          label: Text('F',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold)),
          numeric: true,
        ),
        DataColumn(
          label: Text('T',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold)),
          numeric: true,
        ),
      ],rows: list
        .map((statistics) => DataRow(selected: list.indexOf(statistics) < 3, cells: [
      DataCell(Text("${list.indexOf(statistics) + 1}",
          style: TextStyle(fontWeight: FontWeight.bold))),
      DataCell(Text("${statistics.game.awayTeamName}",
          style: TextStyle(fontWeight: FontWeight.bold))),
      DataCell(Text("${statistics.getTotalScore()}",
          style: TextStyle(fontWeight: FontWeight.bold))),
      DataCell(Text("${statistics.getTotalRebound()}",
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.green))),
      DataCell(Text("${statistics.getTotalFaul()}",
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.red))),
      DataCell(Text("${_printDuration((Duration(seconds: statistics.getPlayedTime())))}",
          style: TextStyle(fontWeight: FontWeight.bold))),
    ]))
        .toList(),
    );
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child:Column(
          children: <Widget>[
            Card(
              elevation: 16,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Row(children: <Widget>[
                    Container(
                      height: 100,
                      width: 100,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                            widget.player.image,
                            fit: BoxFit.cover),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        title: Text("${widget.player.name} - ${widget.player.countryName}  (${widget.player.position}) "),
                      ),
                    )
                  ]),
                ),
              ),
            ),
      _getTable(),
          ],
        ),
      ),
    );
  }
}

class Statistics{
  Game game;
  List<Event> eventList;
  Player player;

  int getTotalScore(){
    int score = 0;

    for(Event event in eventList){
        if(event.playerId == player.id){
          if(event.eventType == Event.TYPE_BASKET1){
            score += 1;
          }else if(event.eventType == Event.TYPE_BASKET2){
            score += 2;
          }else if(event.eventType == Event.TYPE_BASKET3){
            score += 3;
          }
        }
    }
    return score;
  }

  int getTotalRebound(){
    int count = 0;
    for(Event event in eventList){
      if(event.playerId == player.id){
        if(event.eventType == Event.TYPE_REBOUND){
          count += 1;
        }
      }
    }
    return count;
  }

  int getTotalFaul(){
    int faul = 0;
    for(Event event in eventList){
      if(event.playerId == player.id){
        if(event.eventType == Event.TYPE_FAUL){
          faul += 1;
        }
      }
    }
    return faul;
  }

  int getPlayedTime(){
    int second = 0;
    eventList.sort((e1,e2)=>e1.time.compareTo(e2.time));
    int inTime = 0;

    for(Event event in eventList){
      if(event.eventType == Event.TYPE_PLAYER_IN) {
        inTime = event.time;
      }else if(event.eventType == Event.TYPE_PLAYER_OUT){
        if(inTime == 0){// Maç başında girmiş
          second += event.time;
        }else{ //maç ortasında girmiş
          second += event.time - inTime;
        }
      }
    }


    return second;

  }
}
