import 'dart:core';
import 'package:firebase_database/firebase_database.dart';

enum CpamMnpafState {
  none,
  rien,
  en_cours,
  ok
}

class HealthType {
  Set<String> _healthTypeSet = Set<String>();

  void addType(String type) {
    _healthTypeSet.add(type);
  }

  String elementAt(int index) {
    return _healthTypeSet.elementAt(index);
  }

  void initType() {
    //todo : initialisation de initType en fonction de ce qui a été sauvegardé
    Set<String> _healthTypeSetInit = {"Médecin","Dentiste","Hopital"};
    _healthTypeSet.addAll(_healthTypeSetInit);
  }
}

class HealthEntry {
  String id;
  DateTime date;
  String type;
  String whoInType;
  double price;
  List<String> patientList;
  CpamMnpafState cpam;
  CpamMnpafState mnpaf;
  List<String> comments;

  HealthEntry.empty() {
    this.id = "";
    this.date = DateTime.parse("1976-03-29 18:15:00");
    this.type = "";
    this.whoInType = "";
    this.price = 0;
    this.patientList = [];
    this.cpam = CpamMnpafState.none;
    this.mnpaf = CpamMnpafState.none;
    this.comments = [];
  }

  HealthEntry({DateTime date, String type, String whoInType, double price, List<String> patientList, CpamMnpafState cpam, CpamMnpafState mnpaf, List<String> comments}) {
    this.id = "";
    this.date = date;
    this.type = type;
    this.whoInType = whoInType;
    this.price = price;
    this.patientList = patientList;
    this.cpam = cpam;
    this.mnpaf = mnpaf;
    this.comments = comments;
  }

  /*HealthEntry.fromJson(dynamic key, dynamic value) {
    id = key.toString();
    date = DateTime.parse(value["date"]);
    type = value["type"];
    whoInType = value["whoInType"];
    price = value["price"].toDouble();
    patientList = List<String>.from(value["patientList"]);
    cpam = CpamMnpafState.values.firstWhere((element) => element.toString() == value["cpam"]);
    mnpaf = CpamMnpafState.values.firstWhere((element) => element.toString() == value["mnpaf"]);
  }*/

  HealthEntry.fromSnapshot(DataSnapshot snapshot) {
    id = snapshot.key;
    date = DateTime.parse(snapshot.value["date"]);
    type = snapshot.value["type"];
    whoInType = snapshot.value["whoInType"];
    price = snapshot.value["price"].toDouble();
    patientList = List<String>.from(snapshot.value["patientList"]);
    cpam = CpamMnpafState.values.firstWhere((element) => element.toString() == snapshot.value["cpam"]);
    mnpaf = CpamMnpafState.values.firstWhere((element) => element.toString() == snapshot.value["mnpaf"]);
    if (snapshot.value["comments"] != null) {
      comments = List<String>.from(snapshot.value["comments"]);
    } else {
      comments =[];
    }
  }

  toJson() {
    return {
      "date": date,
      "type": type,
      "whoInType": whoInType,
      "price": price,
      "patientList": patientList,
      "cpam": cpam,
      "mnpaf": mnpaf
    };
  }
}

class HealthEntryList {
  final List<HealthEntry> healthEntry = <HealthEntry>[];

  int getHealthEntryIndexById(String id) {
    int index=healthEntry.indexWhere((element) => element.id == id);

    return index;

  }
}