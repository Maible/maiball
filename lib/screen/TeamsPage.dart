import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:maiball/model/Team.dart';
import 'package:maiball/screen/TeamDetailPage.dart';

class TeamsPage extends StatefulWidget {
  @override
  _TeamsPageState createState() => _TeamsPageState();
}

class _TeamsPageState extends State<TeamsPage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Teams'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: <Widget>[
                  Expanded(
                    child: StreamBuilder(
                      stream: Firestore.instance.collection("Teams").snapshots(),
                      builder: (context,snapshot){
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        } else {
                          if (snapshot.data.documents.length == 0) {
                            return Center(child: CircularProgressIndicator());
                          } else {
                            return ListView.builder(itemCount: snapshot.data.documents.length,itemBuilder: (BuildContext context, index) {
                              Team team = Team.fromJson(snapshot.data.documents[index].data);
                              return InkWell(
                                onTap: (){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => TeamDetail(team)),
                                  );
                                },
                                child: ListTile(
                                  leading: Container(
                                    height: 36,
                                    width: 36,
                                    child: Image.network(
                                        team.image),
                                  ),
                                  title: Text(
                                    team.name,
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              );
                            });
                          }
                        }
                      },
                    ),
                  )
            ],
          ),
        ),
      ),
    );
  }
}
