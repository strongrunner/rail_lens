import 'package:flutter/material.dart';
import 'package:rail_lens/consta.dart';
import 'package:rail_lens/sizeconfig.dart';

import 'package:rail_lens/gallery.dart';

import 'package:toast/toast.dart';
import 'package:rail_lens/login_screen.dart';

import 'application_bloc.dart';
import 'bloc_provider.dart';
import 'change_password_screen.dart';
import 'models/model.dart';

Station _currStation;

//TODO: App bar station name size constraint check if scalable
class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("RailLens"),
        backgroundColor: consta.color1,
        elevation: 0,
        actions: <Widget>[
          GestureDetector(
            onTapDown: (_details) {
              final page = BlocProvider<ChangePasswordBloc>(
                builder: (_, bloc) =>
                    bloc ??
                    ChangePasswordBloc(Provider.of<ApplicationBloc>(context)),
                onDispose: (_, bloc) => bloc?.dispose(),
                child: ChangePasswordScreen(
                  mandatory: false,
                ),
              );
              Navigator.push(this.context,
                  MaterialPageRoute(builder: (context) {
                return page;
              }));
            },
            child: Center(
                child: IconButton(icon:Icon(Icons.lock_open,size: 30,color: consta.color3,), onPressed: null)),
          ),
          IconButton(
            icon: Icon(Icons.exit_to_app,size: 30,),padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
            onPressed: () => logout(),
          ),

        ],
      ),
      body: Container(
        color: Color.fromRGBO(255, 255, 255, 1),
        child: _Content(),
      ),
    );
  }

  void logout() {
    print('Logout pressed');
    ApplicationBloc bloc = Provider.of<ApplicationBloc>(this.context);
    bloc.logout();
    _currStation = null;
    final page = BlocProvider<LoginBloc>(
      builder: (_, bloc) => bloc ?? LoginBloc(),
      onDispose: (_, bloc) => bloc?.dispose(),
      child: LoginScreen(),
    );
    Navigator.pushReplacement(this.context,
        MaterialPageRoute(builder: (context) {
      return page;
    }));
  }
}

class _Content extends StatefulWidget {
  @override
  _ContentState createState() => _ContentState();
}

class _ContentState extends State<_Content> {
  List<DropdownMenuItem<Station>> _stationList;

  @override
  void didChangeDependencies() {
    _stationList = Provider.of<ApplicationBloc>(context)
        .cachedStationList
        .map(
          (station) => DropdownMenuItem<Station>(
                value: station,
                child: SizedBox(
                  child: Text(
                    station.stnName,
                  ),
                ),
              ),
        )
        .toList();
    _currStation = _stationList[0].value;
  }

  @override
  Widget build(BuildContext context) {
    print('val of curr station is ${_currStation?.stnName}');

    sizeconfig().init(context);
    return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: [consta.color1, Color.fromRGBO(255, 255, 255, 1)],
          begin: Alignment.topCenter,
          end: Alignment.center,
        )),
        height: double.infinity,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
        //    Container(
        //      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        //    ),
            Container(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                color: Color.fromRGBO(255, 255, 255, 1),
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  height: 80,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        width: 80,
                        child: Center(

                            child: Text(
                          (_currStation?.stnCode) ?? '      ',
                          style: TextStyle(
                              color: consta.color1,
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        )),
                      ),
                      VerticalDivider(
                          indent: 0, width: 15, color: consta.color2),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        width: 200,
                        child: DropdownButton<Station>(isExpanded: true,
                          onChanged: (selectedStation) {
                            setState(
                              () {
                                print('On changed called!');
                                _currStation = selectedStation;
                              },
                            );
                          },
                          iconSize: 30,
                          iconDisabledColor: consta.color1,
                          iconEnabledColor: consta.color2,
                          hint: Container(
                            width: 100,


                            child: Text(
                              'Select a Station',

                            ),
                          ),
                          value: _currStation,
                          style: TextStyle(
                            color: consta.color2,
                            fontSize: 18,
                          ),
                          items: _stationList,
                        ),
                      ),
//                      Image.asset(
//                        "assets/icons/search.png",
//                        color: consta.color1,
//                        width: 30,
//                      )
                    ],
                  ),
                )),
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  color: Color(0x000000),
                  child: iconplate(),
                )),
          ],
        ));
  }
}

class iconplate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          alignment: Alignment.bottomCenter,
          padding: EdgeInsets.fromLTRB(0, 35, 0, 0),
          color: Color.fromRGBO(255, 255, 255, 1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    iconwdg(
                        IconButton(
                            icon: Image.asset(
                              "assets/icons/face.png",
                              color: consta.color1,
                            ),
                            onPressed: () {
                              Navigator.of(context).push(new MaterialPageRoute(
                                  builder: (context) => Gallery(
                                      "Station Facade", 74, 1, _currStation)));
                            }),
                        "Station Facade"),
                    iconwdg(
                        IconButton(
                            icon: Image.asset(
                              "assets/icons/circ.png",
                              color: consta.color1,
                            ),
                            onPressed: () {
                              Navigator.of(context).push(new MaterialPageRoute(
                                  builder: (context) => Gallery(
                                      "Circulating Area",
                                      75,
                                      2,
                                      _currStation)));
                            }),
                        "Circulating Area"),
                    iconwdg(
                        IconButton(
                            icon: Image.asset("assets/icons/tube.png",
                                color: consta.color1),
                            onPressed: () {
                              Navigator.of(context).push(new MaterialPageRoute(
                                  builder: (context) => Gallery(
                                      "Illumination", 76, 1, _currStation)));
                            }),
                        "Illumination"),
                  ]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <
                  Widget>[
                iconwdg(
                    IconButton(
                        icon: Image.asset(
                          "assets/icons/waitingroom.png",
                          color: consta.color1,
                        ),
                        onPressed: () {
                          Navigator.of(context).push(new MaterialPageRoute(
                              builder: (context) => Gallery(
                                  "Waiting Room", 77, 2, _currStation)));
                        }),
                    "Waiting Room"),
                iconwdg(
                    IconButton(
                        icon: Image.asset(
                          "assets/icons/platform.png",
                          color: consta.color1,
                        ),
                        onPressed: () {
                          Navigator.of(context).push(new MaterialPageRoute(
                              builder: (context) =>
                                  Gallery("Platform", 78, 1, _currStation)));
                        }),
                    "Platform"),
                iconwdg(
                    IconButton(
                        icon: Image.asset(
                          "assets/icons/food.png",
                          color: consta.color1,
                        ),
                        onPressed: () {
                          Navigator.of(context).push(new MaterialPageRoute(
                              builder: (context) => Gallery(
                                  "Refreshment Rooms", 80, 2, _currStation)));
                        }),
                    "Refreshment Rooms"),
              ]),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    iconwdg(
                        IconButton(
                            icon: Image.asset("assets/icons/taj.png",
                                color: consta.color1),
                            onPressed: () {
                              Navigator.of(context).push(new MaterialPageRoute(
                                  builder: (context) => Gallery(
                                      "Local Heritage", 79, 1, _currStation)));
                            }),
                        "Local Heritage"),
                    iconwdg(
                        IconButton(
                            icon: Image.asset(
                              "assets/icons/stair.png",
                              color: consta.color1,
                            ),
                            onPressed: () {
                              Navigator.of(context).push(new MaterialPageRoute(
                                  builder: (context) => Gallery(
                                      "Bridges and Escalators",
                                      81,
                                      2,
                                      _currStation)));
                            }),
                        "Bridges and Escalators"),
                    iconwdg(
                        IconButton(
                            icon: Image.asset("assets/icons/elevator.png",
                                color: consta.color1),
                            onPressed: () {
                              Navigator.of(context).push(new MaterialPageRoute(
                                  builder: (context) =>
                                      Gallery("Lifts", 81, 1, _currStation)));
                            }),
                        "Lifts"),
                  ]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <
                  Widget>[
                iconwdg(
                    IconButton(
                        icon: Image.asset(
                          "assets/icons/info.png",
                          color: consta.color1,
                        ),
                        onPressed: () {
                          Navigator.of(context).push(new MaterialPageRoute(
                              builder: (context) => Gallery(
                                  "Information Displays",
                                  82,
                                  2,
                                  _currStation)));
                        }),
                    "Information Displays"),
                iconwdg(
                    IconButton(
                        icon: Image.asset(
                          "assets/icons/mslefemsle.png",
                          color: consta.color1,
                        ),
                        onPressed: () {
                          Navigator.of(context).push(new MaterialPageRoute(
                              builder: (context) =>
                                  Gallery("Restrooms", 84, 1, _currStation)));
                        }),
                    "Restrooms"),
                iconwdg(
                    IconButton(
                        icon: Image.asset("assets/icons/gear.png",
                            color: consta.color1),
                        onPressed: () {
                          if (_currStation?.stnCode == null) {
                            Toast.show("Select a Staion", context,
                                duration: Toast.LENGTH_SHORT,
                                gravity: Toast.BOTTOM);
                          } else {
                            Navigator.of(context).push(new MaterialPageRoute(
                                builder: (context) =>
                                    Gallery("Others", 83, 2, _currStation)));
                          }
                        }),
                    "Others"),
              ])
            ],
          ),
        ));
  }
}

Widget iconwdg(IconButton domain, String domainname) {
  // double width = MediaQuery.of(context).size.width;
  return Container(
    width: 110,
    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
    child: Column(
      children: <Widget>[
        domain,
        Text(
          domainname,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: consta.color2,
              fontSize: sizeconfig.blockSizeHorizontal * 3.5),
        )
      ],
    ),
  );
}
