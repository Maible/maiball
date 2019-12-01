

import 'package:cloud_firestore/cloud_firestore.dart';

class Player{
  String id;
  String name;
  String countryName;
  String position;

  String teamId;
  String image;


  Player({this.id, this.name, this.countryName, this.position, this.teamId,this.image});

  static fromJson(Map<String, dynamic> map) {
    return Player(
      id: map['id'],
      name: map['name'],
      countryName: map['countryName'],
      position: map['position'],
      image: map['image'],
      teamId: map["teamId"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id":id,
      "name": name,
      "countryName": countryName,
      "position": position,
      "image": image,
      "teamId": teamId,
    };
  }

  static void addPlayer(Player player){
    Firestore.instance.collection("Players").add(player.toJson()).then((onValue){
      player.id = onValue.documentID;
      onValue.updateData(player.toJson());
      print("Success");
    });
  }


}