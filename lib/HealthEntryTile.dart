import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:healthlog/HealthEntry.dart';
import 'package:healthlog/main.dart';

import 'HealthScreenAddEntry.dart';

class HealthEntryTile extends StatelessWidget {
  static Color colorCpamMnpafStateNone = Colors.grey;
  static Color colorCpamMnpafStateRien = Colors.red;
  static Color colorCpamMnpafStateEnCours = Colors.orange;
  static Color colorCpamMnpafStateOk = Colors.green;
  final HealthEntry healthEntry;

  HealthEntryTile(this.healthEntry);

  @override
  Widget build(BuildContext context) {
    return _healthEntryTile(context, healthEntry);
  }


  Widget getWidgetCpamMnpafFormated(CpamMnpafState cpamMnpafState,
      String textToBeDisplayed) {
    MaterialColor _color;

    switch (cpamMnpafState) {
      case CpamMnpafState.none:
        _color = HealthEntryTile.colorCpamMnpafStateNone;
        break;
      case CpamMnpafState.rien:
        _color = HealthEntryTile.colorCpamMnpafStateRien;
        break;
      case CpamMnpafState.en_cours:
        _color = HealthEntryTile.colorCpamMnpafStateEnCours;
        break;
      case CpamMnpafState.ok:
        _color = HealthEntryTile.colorCpamMnpafStateOk;
        break;
    }

    return Text(
        textToBeDisplayed,
        style: TextStyle(color: _color)
    );
  }

  Widget displayPatientList(List<String> patientList) {
    String _patientListString = patientList.elementAt(0);

    if (patientList.length > 1) {
      for (var index = 1; index < patientList.length; index++) {
        _patientListString =
            _patientListString + " - " + patientList.elementAt(index);
      }
    }
    return Expanded(
      child: Text(
        _patientListString,
      ),
    );
  }

  Widget _healthEntryTile(BuildContext context, HealthEntry healthEntry) {
    // Definitions des constantes affichage
    double itemHeightInHealthScreen = 60;

    // Definition des constantes de couleur et thème
    Color colorDate = Colors.blue[900];
    Color colorType = Colors.blue[600];
    Color colorWhoInType = Colors.blue[600];

    var _dateFormat = DateFormat("dd.MM.yy");

    return Dismissible(
      key: Key(healthEntry.id.toString()),
      background: Container(
        color: Colors.red,
        child: Container(
            alignment: Alignment.centerRight,
            child: Icon(Icons.delete)
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        entryList.healthEntry.removeAt(
            entryList.getHealthEntryIndexById(healthEntry.id));
        firebaseTool.removeHealthEntry(healthEntry);
      },
      child: GestureDetector(
        onLongPress: () => _healthEntryModification(context, healthEntry),
        child: Container(
          height: itemHeightInHealthScreen,
          child: Card(
            margin: EdgeInsets.all(3.0),
            elevation: 10.0,
            child: Container(
              margin: EdgeInsets.all(3.0),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            _dateFormat.format(healthEntry.date).toString(),
                            style: TextStyle(
                                color: colorDate, fontWeight: FontWeight.bold),
                          ),
                          Text(" : "),
                          Text(
                            healthEntry.type,
                            style: TextStyle(color: colorType),
                          ),
                          Text(" - "),
                          Text(
                            healthEntry.whoInType,
                            style: TextStyle(color: colorWhoInType),
                          ),
                        ],
                      ),
                      Text(
                          healthEntry.price.toString() + "€"
                      ),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      displayPatientList(healthEntry.patientList),
                      Row(
                        children: <Widget>[
                          getWidgetCpamMnpafFormated(
                              healthEntry.cpam, "CPAM"),
                          Text("/"),
                          getWidgetCpamMnpafFormated(
                              healthEntry.mnpaf, "MNPAF")
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _healthEntryModification(BuildContext context, HealthEntry healthEntry) {

    Navigator.pushNamed(
        context,
        '/HealthScreenAddEntry',
        arguments: HealthScreenAddEntryArguments(
            true,
            healthEntry: healthEntry
        )
    );
  }
}