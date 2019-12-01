import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maiball/model/Games.dart';
import 'package:maiball/model/Team.dart';
import 'package:maiball/screen/DetailPage.dart';
import 'package:shimmer/shimmer.dart';

class MatchList extends StatefulWidget {
  @override
  _MatchListState createState() => _MatchListState();
}

class _MatchListState extends State<MatchList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: StreamBuilder(
            stream: Firestore.instance
                .collection("Games")
                .orderBy("date")
                .snapshots(),
            builder: (BuildContext context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              } else {
                if (snapshot.data.documents.length == 0) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return ListView.separated(
                      separatorBuilder: (BuildContext context, index) {
                        return Container(
                          height: 2,
                          color: Colors.black12,
                        );
                      },
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (BuildContext context, index) {
                        Game game = Game.fromJson(snapshot.data.documents[index].data);
                        return ListItem(game);
                      });
                }
              }
            },
          ),
        ),
      ),
    );
  }
}

class ListItem extends StatefulWidget {
  Game game;

  ListItem(this.game);

  @override
  _ListItemState createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  Team homeTeam;
  Team awayTeam;

  @override
  void initState() {
    getTeams();
    super.initState();
  }

  void getTeams(){
    var ref = Firestore.instance.collection("Teams");

    ref.document(widget.game.homeTeamId).get().then((snap){
      setState(() {
        homeTeam = Team.fromJson(snap.data);
      });
    });

    ref.document(widget.game.awayTeamId).get().then((snap){
      setState(() {
        awayTeam = Team.fromJson(snap.data);
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    if(homeTeam != null && awayTeam != null){
      return InkWell(
        onTap: () {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text('Tıklandı'),
          ));

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DetailPage(game: widget.game,homeTeam: homeTeam,awayTeam: awayTeam,)),
          );
        },
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: ListTile(
                        leading: Container(
                          height: 36,
                          width: 36,
                          child: Image.network(
                              homeTeam.image),
                        ),
                        title: Text(
                          homeTeam.name,
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                    Text(
                      "${widget.game.homeTeamScore} - ${widget.game.awayTeamScore}",
                      style: Theme.of(context).textTheme.title,
                    ),
                    Expanded(
                      flex: 1,
                      child: ListTile(
                        trailing: Container(
                          height: 36,
                          width: 36,
                          child: Image.network(
                              awayTeam.image),
                        ),
                        title: Text(
                          awayTeam.name,
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(new DateFormat("yyyy/MM/dd").format(widget.game.date)),
              ],
            )
          ),
        ),
      );
    }else{
      return Shimmer.fromColors(
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
              Container(
                width: 60,
                height: 60,
                child: CircleAvatar(
                    backgroundImage: AssetImage("img/chat_background.jpg")),
              ),
              Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
              Container(
                width: 60,
                height: 60,
                child: CircleAvatar(
                    backgroundImage: AssetImage("img/chat_background.jpg")),
              ),
            ],
          ),
        ),
      );
    }
  }
}
