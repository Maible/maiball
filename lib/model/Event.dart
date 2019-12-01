import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  static List<String> eventNames = [
    "Basket (1PTS)",
    "Basket (2PTS)",
    "Basket (3PTS)",
    "Rebound",
    "Faul",
    " in",
    " out",
    "Steal",
  ];


 static final int TYPE_BASKET1 = 0;
  static final int TYPE_BASKET2 = 1;
  static final int TYPE_BASKET3 = 2;

  static final int TYPE_REBOUND = 3;
  static final int TYPE_FAUL = 4;

  static final int TYPE_PLAYER_IN = 5;
  static final int TYPE_PLAYER_OUT = 6;
  static final int TYPE_STEAL = 7;


  String id;

  int eventType;

  String playerId;

  String matchId;

  int time;

  bool isHomeTeam;

  Event(
      {this.id,
      this.playerId,
      this.matchId,
      this.isHomeTeam,
      this.time,this.eventType});

  static fromJson(Map<String, dynamic> map) {
    return Event(
        id: map['id'],
        playerId: map['playerId'],
        eventType: map['eventType'],
        matchId: map['matchId'],
        isHomeTeam: map["isHomeTeam"] as bool,
        time: map['time'] as int);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "playerId": playerId,
      "eventType": eventType,
      "isHomeTeam": isHomeTeam,
      "matchId": matchId,
      "time": time,
    };
  }

  static void addAction(Event event) {
    Firestore.instance
        .collection("Games")
        .document(event.matchId)
        .collection("Events")
        .add(event.toJson())
        .then((onValue) {
      event.id = onValue.documentID;
      onValue.updateData(event.toJson());
      print("Success");
    });
  }
}

