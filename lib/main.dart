import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maiball/model/Event.dart';
import 'package:maiball/model/Games.dart';
import 'package:maiball/model/Player.dart';
import 'package:maiball/model/Team.dart';
import 'package:maiball/screen/MatchListPage.dart';
import 'package:maiball/screen/StandingsPage.dart';
import 'package:maiball/screen/TeamsPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: Main(),
    );
  }
}

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  Widget currentWidget = MatchList();
  int currentIndex = 0;

  _selectPage(int index) {
    setState(() {
      currentIndex = index;
      switch (index) {
        case 0:
          currentWidget = MatchList();
          break;
        case 1:
          currentWidget = StandingsPage();
          break;
        case 2:
          currentWidget = TeamsPage();
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        items: <Widget>[
          Icon(
            FontAwesomeIcons.list,
            color: Colors.white,
            size: 25,
          ),
          Icon(
            FontAwesomeIcons.yinYang,//TODO icon ekle
            color: Colors.white,
            size: 25,
          ),
          Icon(
            FontAwesomeIcons.search,
            color: Colors.white,
            size: 25,
          ),
        ],
        color: Theme.of(context).accentColor,
        backgroundColor: Colors.white,
        buttonBackgroundColor: Theme.of(context).accentColor,
        animationCurve: Curves.linear,
        height: 50,
        animationDuration: Duration(milliseconds: 750),
        onTap: (index) {
          _selectPage(index);
        },
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 750),
        child: SafeArea(child: currentWidget),
      ),
    );
  }
}

//KANKA önemli bi mevzu var teldeyim döncem sana :D

//Nasıl böyle? gayet iyi
//Oke
