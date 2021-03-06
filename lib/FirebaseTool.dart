import 'package:firebase_database/firebase_database.dart';
import 'package:healthlog/HealthEntry.dart';
import 'package:healthlog/main.dart';

class FirebaseTool {

  final databaseReference = FirebaseDatabase.instance.reference();
  Query healthEntryQuery;

  void saveHealthEntry(HealthEntry healthEntry) {
    String idPushed = databaseReference.child("HealthEntry").push().key;
    healthEntry.id = idPushed;
    databaseReference.child("HealthEntry").child(idPushed).set({
      'date': healthEntry.date.toString(),
      'type': healthEntry.type,
      'whoInType': healthEntry.whoInType,
      'price': healthEntry.price,
      'patientList':healthEntry.patientList,
      'cpam': healthEntry.cpam.toString(),
      'mnpaf': healthEntry.mnpaf.toString(),
      'comments':healthEntry.comments
    });
  }

  void removeHealthEntry(HealthEntry healthEntry) {
    //print(healthEntry.id);
    if (healthEntry.id == "") {
      print("Problème id vide : FirebaseTool.removeHealthEntry");
    } else {
      databaseReference.child("HealthEntry").child(healthEntry.id).remove();
    }
  }

  void modifyHealthEntry(HealthEntry healthEntry) {
    databaseReference.child("HealthEntry").child(healthEntry.id).set({
      'date': healthEntry.date.toString(),
      'type': healthEntry.type,
      'whoInType': healthEntry.whoInType,
      'price': healthEntry.price,
      'patientList':healthEntry.patientList,
      'cpam': healthEntry.cpam.toString(),
      'mnpaf': healthEntry.mnpaf.toString(),
      'comments': healthEntry.comments
    });
  }

  void listenHealthEntry() {
    healthEntryQuery = databaseReference.child("HealthEntry");
    healthEntryQuery.onChildChanged.listen(_onEntryChanged);
    healthEntryQuery.onChildRemoved.listen(_onEntryRemoved);
    healthEntryQuery.onChildAdded.listen(_onEntryAdded);
  }

  _onEntryChanged(Event event) {
    HealthEntry healthEntry = HealthEntry.fromSnapshot(event.snapshot);
    int index = entryList.getHealthEntryIndexById(healthEntry.id);
    if (index == -1){
      print("Index = -1 : problème avec FirebaseTool._onEntryChanged()");
    } else {
      entryList.healthEntry[index] = healthEntry;
    }
  }

  void _onEntryRemoved(Event event) {
    HealthEntry healthEntry = HealthEntry.fromSnapshot(event.snapshot);
    int index = entryList.getHealthEntryIndexById(healthEntry.id);
    if (index == -1){
      print("Index = -1 : problème avec FirebaseTool._onEntryRemoved()");
    } else {
      entryList.healthEntry.removeAt(index);
    }
  }

  void _onEntryAdded(Event event) {
    HealthEntry healthEntry = HealthEntry.fromSnapshot(event.snapshot);
    int index = entryList.getHealthEntryIndexById(healthEntry.id);
    if (index == -1){
      entryList.healthEntry.add(healthEntry);
    } else {
      // on ne fait rien, l'entrée existe déjà
    }
  }
}

class StreamSubscription {
}