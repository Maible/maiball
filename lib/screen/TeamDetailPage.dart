import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maiball/model/Games.dart';
import 'package:maiball/model/Player.dart';
import 'package:maiball/model/Team.dart';
import 'package:maiball/screen/DetailPage.dart';
import 'package:maiball/screen/MatchListPage.dart';
import 'package:maiball/screen/Player.dart';

class TeamDetail extends StatefulWidget {
  Team team;


  TeamDetail(this.team);

  @override
  _TeamDetailState createState() => _TeamDetailState();
}

class _TeamDetailState extends State<TeamDetail>
    with SingleTickerProviderStateMixin {
  GlobalKey key = GlobalKey();
  TabController _tabController;
  int tabIndex = 0;




  _tabWidget() {
    switch (tabIndex) {
      case 0:
       return StreamBuilder(
         stream: Firestore.instance.collection("Players").where("teamId",isEqualTo: widget.team.id).snapshots(),
         builder: (context,snapshot){
           if (!snapshot.hasData) {
             return Center(child: CircularProgressIndicator());
           } else {
             if (snapshot.data.documents.length == 0) {
               return Center(child: CircularProgressIndicator());
             } else {
               return ListView.builder(shrinkWrap: true,itemCount: snapshot.data.documents.length,itemBuilder: (BuildContext context,index){
                 Player player = Player.fromJson(snapshot.data.documents[index].data);
                 return ListTile(
                   onTap: (){
                     Navigator.push(
                       context,
                       MaterialPageRoute(builder: (context) => PlayerPage(player)),
                     );

                   },
                   leading: Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: ClipRRect(
                       borderRadius: BorderRadius.circular(16),
                       child: player.image!= null?Image.network(player.image,fit: BoxFit.cover,):CircularProgressIndicator(),
                     ),
                   ),
                   title: Text("15 ${player.name}   ${player.position}"),
                   trailing: Text('${player.countryName}'),
                 );
               });
             }
           }
         },
       );
      case 1:
        return StreamBuilder(
          stream: Firestore.instance.collection("Games").snapshots(),
          builder: (context,snapshot){
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (snapshot.data.documents.length == 0) {
                return Center(child: CircularProgressIndicator());
              } else {
                List<Game> gameList = new List();

                for(DocumentSnapshot snap in snapshot.data.documents){
                  Game game = Game.fromJson(snap.data);
                  if(game.awayTeamId == widget.team.id || game.homeTeamId == widget.team.id){
                    gameList.add(game);
                  }

                }

                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: gameList.length,itemBuilder: (BuildContext context,index){
                  Game game = gameList[index];
                  return ListItem(game);
                });
              }
            }
          },
        );
    }
  }

  @override
  void initState() {
    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
    _tabController.addListener(_handleTabSelection);
    super.initState();
  }

  _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {
        tabIndex = _tabController.index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              snap: false,
              floating: false,
              pinned: true,
              automaticallyImplyLeading: false,
              leading: BackButton(),
              actions: <Widget>[],
              expandedHeight: 260,
              elevation: 8,
              flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: SafeArea(
                    child: Card(
                      elevation: 16,
                      margin: EdgeInsets.only(
                          top: AppBar().preferredSize.height,
                          bottom: AppBar().preferredSize.height + 16,
                          left: 16,
                          right: 16),
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
                                    widget.team.image,
                                    fit: BoxFit.cover),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  ListTile(
                                    title: Text(widget.team.name),
                                  ),
                                  ListTile(
                                    title: Text('Coach: ${widget.team.coachName}'),
                                  )
                                ],
                              ),
                            )
                          ]),
                        ),
                      ),
                    ),
                  )),
              bottom: TabBar(
                key: key,
                controller: _tabController,
                indicatorWeight: 2,
                indicatorSize: TabBarIndicatorSize.tab,
                unselectedLabelColor: Colors.white,
                labelColor: Colors.white,
                unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w300),
                isScrollable: true,
                indicatorColor: Theme.of(context).accentColor,
                tabs: <Widget>[
                  Tab(
                    text: "Players",
                  ),
                  Tab(
                    text: "Games",
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: _tabWidget(),
            )
          ],
        ),
      ),
    );
  }
}



