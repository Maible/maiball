import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maiball/model/Event.dart';

class Game {
  String id;

  String homeTeamId;
  String awayTeamId;
  String awayTeamName;

  DateTime date;

  int homeTeamScore;
  int awayTeamScore;

  Game(
      {this.id,
      this.homeTeamId,
      this.awayTeamId,
      this.date,
      this.homeTeamScore,
      this.awayTeamScore,this.awayTeamName});

  static fromJson(Map<String, dynamic> map) {
    return Game(
      id: map['id'],
      homeTeamId: map['homeTeamId'],
      awayTeamId: map['awayTeamId'],
      awayTeamName: map['awayTeamName'],
      date: map["date"] != null
          ? DateTime.fromMicrosecondsSinceEpoch(
              map["date"].millisecondsSinceEpoch * 1000)
          : DateTime.now(),
      homeTeamScore: map["homeTeamScore"] as int,
      awayTeamScore: map["awayTeamScore"] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "homeTeamId": homeTeamId,
      "awayTeamId": awayTeamId,
      "awayTeamName": awayTeamName,
      "date": date,
      "homeTeamScore": homeTeamScore,
      "awayTeamScore": awayTeamScore,
    };
  }

  static void addGame(Game match) {
    Firestore.instance.collection("Games").add(match.toJson()).then((onValue) {
      match.id = onValue.documentID;
      onValue.updateData(match.toJson());
      print("Success");
    });
  }
}
