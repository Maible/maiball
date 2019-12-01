import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maiball/model/Event.dart';
import 'package:maiball/model/Games.dart';
import 'package:maiball/model/Player.dart';
import 'package:maiball/model/Team.dart';
import 'package:maiball/screen/TeamDetailPage.dart';
import 'package:shimmer/shimmer.dart';

class DetailPage extends StatefulWidget {
  Game game;
  Team homeTeam;
  Team awayTeam;

  DetailPage({this.game, this.homeTeam, this.awayTeam});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  List<Event> firstCircuit;

  List<Event> secondCircuit;

  List<Event> thirdCircuit;

  List<Event> fourthCircuit;

  @override
  void initState() {
    super.initState();
    getDetail();
  }

  void getDetail(){
    Firestore.instance.collection("Games").document(widget.game.id).collection("Events").orderBy("time").getDocuments().then((snapshots){
      firstCircuit  = new List();
      secondCircuit  = new List();
      thirdCircuit  = new List();
      fourthCircuit  = new List();
      for (DocumentSnapshot snap in snapshots.documents) {
        Event event = Event.fromJson(snap.data);
        if (event.time <= 10 * 60) {
          firstCircuit.add(event);
        } else if (event.time > 10 * 60 && event.time < 20 * 60) {
          secondCircuit.add(event);
        } else if (event.time > 20 * 60 && event.time < 30 * 60) {
          thirdCircuit.add(event);
        } else {
          fourthCircuit.add(event);
        }
      }
      setState(() {

      });

    });
  }
  int homeTeamScore = 0;
  int awayTeamScore = 0;
  String circuitScore(List<Event> events){

    for(Event event in events){

      if(event.eventType == Event.TYPE_BASKET1){
        homeTeamScore += event.isHomeTeam? 1:0;
        awayTeamScore += event.isHomeTeam? 0:1;
      }else if(event.eventType == Event.TYPE_BASKET2){

        homeTeamScore += event.isHomeTeam? 2:0;
        awayTeamScore += event.isHomeTeam? 0:2;
      }else if(event.eventType == Event.TYPE_BASKET3){

        homeTeamScore += event.isHomeTeam? 3:0;
        awayTeamScore += event.isHomeTeam? 0:3;
      }

    }
    return "$homeTeamScore - $awayTeamScore";
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              BackButton(),
              Tooltip(
                message: "Maçı sahada göster",
                child: IconButton(
                  icon: Icon(Icons.fullscreen),
                  onPressed: () {},
                ),
              )
            ],
          ),
         Container(
           height: 150,
           child: Row(
             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
             children: <Widget>[
               Column(
                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                 children: <Widget>[
                   Container(
                     height: 75,
                     width: 75,
                     child: Image.network(widget.homeTeam.image),
                   ),
                   Tooltip(
                     message: "${widget.homeTeam.name} detayı",
                     child: OutlineButton(
                       onPressed: () {
                         print("test");
                         Navigator.of(context).push(MaterialPageRoute(
                             builder: (context) =>
                                 TeamDetail(widget.homeTeam)));
                       },
                       child: Text('${widget.homeTeam.name}'),
                     ),
                   ),
                 ],
               ),
               Text(
                 "${widget.game.homeTeamScore} - ${widget.game.awayTeamScore}",
                 style: Theme.of(context)
                     .textTheme
                     .display1
                     .merge(TextStyle(fontWeight: FontWeight.bold)),
               ),
               Column(
                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                 children: <Widget>[
                   Container(
                     height: 75,
                     width: 75,
                     child: Image.network(widget.awayTeam.image),
                   ),
                   Tooltip(
                     message: "${widget.awayTeam.name} detayı",
                     child: OutlineButton(
                       onPressed: () {
                         Navigator.of(context).push(MaterialPageRoute(
                             builder: (context) =>
                                 TeamDetail(widget.awayTeam)));
                       },
                       child: Text("${widget.awayTeam.name}"),
                     ),
                   ),
                 ],
               ),
             ],
           ),
         ),
          Expanded(
            child: SingleChildScrollView(
              child: firstCircuit != null ? Column(
                children: <Widget>[
                  ListTile(
                    title: Text("1. Devre ",style: Theme.of(context).textTheme.title,),
                    trailing:  Text('${circuitScore(firstCircuit)}'),
                  ),
                  ListView.separated(
                    shrinkWrap: true,
                      separatorBuilder: (BuildContext context, index) {
                        return Container(
                          height: 2,
                          color: Colors.black12,
                        );
                      },
                      itemCount: firstCircuit.length,
                      itemBuilder: (BuildContext context, index) {
                        return DetailItem(firstCircuit[index], widget.game);
                      }),
                  ListTile(
                    title: Text("2. Devre",style: Theme.of(context).textTheme.title,),
                    trailing:  Text('${circuitScore(secondCircuit)}'),
                  ),
                  ListView.separated(
                      shrinkWrap: true,
                      separatorBuilder: (BuildContext context, index) {
                        return Container(
                          height: 2,
                          color: Colors.black12,
                        );
                      },
                      itemCount: secondCircuit.length,
                      itemBuilder: (BuildContext context, index) {
                        return DetailItem(secondCircuit[index], widget.game);
                      }),
                  ListTile(
                    title: Text("3. Devre",style: Theme.of(context).textTheme.title,),
                    trailing:  Text('${circuitScore(thirdCircuit)}'),
                  ),
                  ListView.separated(
                      shrinkWrap: true,
                      separatorBuilder: (BuildContext context, index) {
                        return Container(
                          height: 2,
                          color: Colors.black12,
                        );
                      },
                      itemCount: thirdCircuit.length,
                      itemBuilder: (BuildContext context, index) {
                        return DetailItem(thirdCircuit[index], widget.game);
                      }),
                  ListTile(
                    title: Text("4. Devre",style: Theme.of(context).textTheme.title,),
                    trailing:  Text('${circuitScore(fourthCircuit)}'),
                  ),
                  ListView.separated(
                      shrinkWrap: true,
                      separatorBuilder: (BuildContext context, index) {
                        return Container(
                          height: 2,
                          color: Colors.black12,
                        );
                      },
                      itemCount: fourthCircuit.length,
                      itemBuilder: (BuildContext context, index) {
                        return DetailItem(fourthCircuit[index], widget.game);
                      }),
                ],
              ):Center(child: CircularProgressIndicator(),),
            ),
          )

        ],
      ),
    ));
  }
}

class DetailItem extends StatefulWidget {
  Event event;
  Game game;

  DetailItem(this.event, this.game);

  @override
  _DetailItemState createState() => _DetailItemState();
}

class _DetailItemState extends State<DetailItem> {
  Player player;

  @override
  void initState() {
    getPlayer();
    super.initState();
  }

  void getPlayer() {
    Firestore.instance
        .collection("Players")
        .document(widget.event.playerId)
        .get()
        .then((snap) {
      setState(() {
        player = Player.fromJson(snap.data);
      });
    });
  }

  Widget team1Event(context) {
    return Container(
      child: ListTile(
        title: Text(
          "${player.name} ${Event.eventNames[widget.event.eventType]}",
          textAlign: TextAlign.left,
        ),
      ),
    );
  }

  Widget team2Event(context) {

    return Container(
      child: ListTile(
        title: Text(
          "${player.name} ${Event.eventNames[widget.event.eventType]}",
          textAlign: TextAlign.right,
        ),
      ),
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
    return player != null ? Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left:16.0),
          child: Text(_printDuration(Duration(seconds: widget.event.time))),
        ),
        Expanded(
            child: widget.event.isHomeTeam
                ? team1Event(context)
                : team2Event(context)),
      ],
    ):Shimmer.fromColors(
      direction: ShimmerDirection.ltr,
      period: Duration(seconds: 2),
      baseColor: Theme.of(context).focusColor,
      enabled: true,
      highlightColor: Theme.of(context).accentColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        color: Colors.white,
                        width: MediaQuery.of(context).size.width,
                        height: 16,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        color: Colors.black,
                        width: MediaQuery.of(context).size.width,
                        height: 16,
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
