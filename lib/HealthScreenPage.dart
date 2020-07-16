import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:healthlog/Authentication.dart';
import 'package:healthlog/HealthEntryTile.dart';
import 'package:healthlog/HealthScreenAddEntry.dart';

import 'HealthEntry.dart';
import 'main.dart';

// Definition des constantes de couleur et thème
Color colorCpamMnpafStateAll = Colors.black;
Color colorCpamMnpafStateEnCoursInAppBar = Colors.red;
Color colorBackground = Colors.green[100];

class HealthScreenPage extends StatefulWidget {
  static const String route ="/HealthScreenPage";
  final Authentication auth;
  final VoidCallback logoutCallback;

  HealthScreenPage({this.auth, this.logoutCallback});

  @override
  State createState() => HealthScreenPageState();
}

class HealthScreenPageState extends State<HealthScreenPage> {

  bool _cpamDisplayAll = true; // affiche t-on toutes les entrées CPAM ?
  bool _mnpafDisplayAll = true;  // affiche t-on toutes les entrées MNPAF ?
  Authentication auth = Authentication();
  Timer timer;

  @override
  void initState() {
    super.initState();
    firebaseTool.listenHealthEntry();

    // defines a timer
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("HealthLog"),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: 60,
                  child: FlatButton(
                      padding: EdgeInsets.all(0),
                      onPressed: _toggleCpamDisplay,
                      textColor: colorCpamMnpafStateAll,
                      child: _displayCpamInAppBar()
                  ),
                ),
                Text("/"),
                SizedBox(
                  width: 60,
                  child: FlatButton(
                      padding: EdgeInsets.all(0),
                      onPressed: _toggleMnpafDisplay,
                      textColor: colorCpamMnpafStateAll,
                      child: _displayMnpafInAppBar()
                  ),
                )
              ],
            ),
            SizedBox(
              width: 15,
              child: IconButton(
                  padding: EdgeInsets.all(0),
                  onPressed: () {
                    timer.cancel();
                    widget.logoutCallback();
                    },
                  icon: Icon(Icons.exit_to_app)
              ),
            ),
          ],
        ),
        elevation: 10.0,
      ),
      body: composeHealthEntryTiles(),
      backgroundColor: colorBackground,
      floatingActionButton: FloatingActionButton(
          onPressed: addEntryInHealthEntryTable,
          child: Icon(Icons.add)
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void  _toggleCpamDisplay() {
    setState(() {
      if (_cpamDisplayAll) {
        _cpamDisplayAll = false;
      }
      else {
        _cpamDisplayAll = true;
      }
    });
  }

  void  _toggleMnpafDisplay() {
    setState(() {
      if (_mnpafDisplayAll) {
        _mnpafDisplayAll = false;
      }
      else {
        _mnpafDisplayAll = true;
      }
    });
  }

  Widget _displayCpamInAppBar() {
    if (_cpamDisplayAll) {
      return Text("CPAM");
    }
    else {
      return Column(
        children: <Widget>[
          Text("CPAM"),
          Text(
            "En cours",
            style: TextStyle(color:colorCpamMnpafStateEnCoursInAppBar),
          )
        ],
      );
    }
  }

  Widget _displayMnpafInAppBar() {
    if (_mnpafDisplayAll) {
      return Text("MNPAF");
    }
    else {
      return Column(
        children: <Widget>[
          Text("MNPAF"),
          Text(
            "En cours",
            style: TextStyle(color:colorCpamMnpafStateEnCoursInAppBar),
          )
        ],
      );
    }
  }

  Widget composeHealthEntryTiles() {
    CpamMnpafState _cpam;
    CpamMnpafState _mnpaf;
    bool _addEntry;
    final List<HealthEntryTile> _listHealthEntryTiles = <HealthEntryTile>[];

    for (var index = 0; index < entryList.healthEntry.length; index++) {
      _cpam = entryList.healthEntry[index].cpam;
      _mnpaf = entryList.healthEntry[index].mnpaf;
      _addEntry = false;

      if (!_cpamDisplayAll) {
        if (_cpam == CpamMnpafState.en_cours || _cpam == CpamMnpafState.rien) {
          _addEntry = true;
        }
      }
      if (!_mnpafDisplayAll) {
        if (_mnpaf == CpamMnpafState.en_cours || _mnpaf == CpamMnpafState.rien) {
          _addEntry = true;
        }
      }
      if (_cpamDisplayAll == true && _mnpafDisplayAll == true) {
        _addEntry = true;
      }
      if (_addEntry == true) {
        _listHealthEntryTiles.add(
            HealthEntryTile(entryList.healthEntry[index]));
      }
    }

    // on met les tiles dans l'ordre des dates
    _listHealthEntryTiles.sort((a,b) => b.healthEntry.date.compareTo(a.healthEntry.date));

    return ListView.builder(
        itemCount: _listHealthEntryTiles.length,
        itemBuilder: (context, index) {
          return _listHealthEntryTiles[index];
        });
  }

  void addEntryInHealthEntryTable(){
    Navigator
        .pushNamed(
        context,
        '/HealthScreenAddEntry',
        arguments: HealthScreenAddEntryArguments(
          false,
        )
    )
        .then((value) => setState(() {}));
  }

  void refresh() {
    setState(() {
    });
  }
}

void saveEntryList() {

  for (int index = 0 ; index < entryList.healthEntry.length ; index++) {
    firebaseTool.saveHealthEntry(entryList.healthEntry[index]);
  }
}

void initHealtEntryTable() {
  // todo : initialisation provisoire de healthEntryTable, à modifier quand la sauvegarde fonctionnera
  HealthEntry healthEntryManual1 = HealthEntry.empty();
  HealthEntry healthEntryManual2 = HealthEntry.empty();
  HealthEntry healthEntryManual3 = HealthEntry.empty();
  HealthEntry healthEntryManual4 = HealthEntry.empty();
  HealthEntry healthEntryManual5 = HealthEntry.empty();
  HealthEntry healthEntryManual6 = HealthEntry.empty();

  healthEntryManual1.date = DateTime.parse("2020-05-22");
  healthEntryManual1.type = "Médecin";
  healthEntryManual1.whoInType = "Duval";
  healthEntryManual1.price = 32.12;
  healthEntryManual1.patientList = ["Mike", "Martin"];
  healthEntryManual1.cpam = CpamMnpafState.none;
  healthEntryManual1.mnpaf = CpamMnpafState.none;
  entryList.healthEntry.add(healthEntryManual1);

  healthEntryManual2.date = DateTime.parse("2020-05-27");
  healthEntryManual2.type = "Dentiste";
  healthEntryManual2.whoInType = "Teboul";
  healthEntryManual2.price = 64.25;
  healthEntryManual2.patientList = ["Martin", "Nathan", "Gabin"];
  healthEntryManual2.cpam = CpamMnpafState.rien;
  healthEntryManual2.mnpaf = CpamMnpafState.rien;
  entryList.healthEntry.add(healthEntryManual2);

  healthEntryManual3.date = DateTime.parse("2020-05-19");
  healthEntryManual3.type = "Psy";
  healthEntryManual3.whoInType = "Aubry";
  healthEntryManual3.price = 55.00;
  healthEntryManual3.patientList = ["Camille", "Mike"];
  healthEntryManual3.cpam = CpamMnpafState.en_cours;
  healthEntryManual3.mnpaf = CpamMnpafState.en_cours;
  entryList.healthEntry.add(healthEntryManual3);

  healthEntryManual4.date = DateTime.parse("2019-05-19");
  healthEntryManual4.type = "Hopital";
  healthEntryManual4.whoInType = "Jossigny";
  healthEntryManual4.price = 5.00;
  healthEntryManual4.patientList = ["Gabin"];
  healthEntryManual4.cpam = CpamMnpafState.ok;
  healthEntryManual4.mnpaf = CpamMnpafState.ok;
  entryList.healthEntry.add(healthEntryManual4);

  healthEntryManual5.date = DateTime.parse("2019-03-14");
  healthEntryManual5.type = "Médecin";
  healthEntryManual5.whoInType = "Duval";
  healthEntryManual5.price = 25.00;
  healthEntryManual5.patientList = ["Lola"];
  healthEntryManual5.cpam = CpamMnpafState.en_cours;
  healthEntryManual5.mnpaf = CpamMnpafState.ok;
  entryList.healthEntry.add(healthEntryManual5);

  healthEntryManual6.date = DateTime.parse("2020-10-29");
  healthEntryManual6.type = "Psy";
  healthEntryManual6.whoInType = "Corde";
  healthEntryManual6.price = 65.00;
  healthEntryManual6.patientList = ["Clément", "Camille"];
  healthEntryManual6.cpam = CpamMnpafState.ok;
  healthEntryManual6.mnpaf = CpamMnpafState.rien;
  entryList.healthEntry.add(healthEntryManual6);
}