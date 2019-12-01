

import 'package:cloud_firestore/cloud_firestore.dart';

class Team{
  String id;
  String name;
  String image;
  String coachName;

  int winCount;
  int score;
  int loseCount;


  Team({this.id, this.name, this.image,this.coachName});

  static fromJson(Map<String, dynamic> map) {
    return Team(
      id: map['id'],
      name: map['name'],
      image: map['image'],
      coachName: map['coachName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id":id,
      "name": name,
      "coachName": coachName,
      "image": image,
    };
  }

  static void addPlayer(Team team){
    Firestore.instance.collection("Teams").add(team.toJson()).then((onValue){
      team.id = onValue.documentID;
      onValue.updateData(team.toJson());
      print("Success");
    });
  }

  @override
  String toString() {
    return 'Team{id: $id, name: $name, image: $image, coachName: $coachName}';
  }


}