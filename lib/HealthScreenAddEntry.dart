import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:healthlog/HealthEntry.dart';
import 'package:healthlog/HealthEntryTile.dart';
import 'package:healthlog/main.dart';

class HealthScreenAddEntry extends StatefulWidget {
  static const String route="/HealthScreenAddEntry";
  final HealthScreenAddEntryArguments _arguments;
  HealthScreenAddEntry(this._arguments);

  @override
  State createState() => HealthScreenAddEntryState(_arguments);
}

class HealthScreenAddEntryState extends State<HealthScreenAddEntry> {

  var _dateFormat = DateFormat("dd.MM.yy");
  DateTime _selectedDate = DateTime.now();
  String _selectedType;
  String _selectedWhoInType;
  double _selectedPrice;
  CpamMnpafState _selectedCpam = CpamMnpafState.none;
  CpamMnpafState _selectedMnpaf = CpamMnpafState.none;
  bool _checkboxMikeValue = false;
  bool _checkboxMarieValue = false;
  bool _checkboxClementValue = false;
  bool _checkboxCamilleValue = false;
  bool _checkboxGabinValue = false;
  bool _checkboxLolaValue = false;
  bool _checkboxNathanValue = false;
  bool _checkboxMartinValue = false;
  String _typeValue = "";
  String _whoInTypeValue ="";
  double _priceValue = 0;

  HealthScreenAddEntryArguments _arguments;

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  HealthScreenAddEntryState(this._arguments) {
    _initHealtEntryTableValues();
  }

  void _initHealtEntryTableValues() {
    if (_arguments.isModification) {
      _selectedDate = _arguments.healthEntry.date;
      _typeValue = _arguments.healthEntry.type;
      _whoInTypeValue = _arguments.healthEntry.whoInType;
      _priceValue = _arguments.healthEntry.price;
      if (_arguments.healthEntry.patientList.contains("Mike")) _checkboxMikeValue = true;
      if (_arguments.healthEntry.patientList.contains("Marie")) _checkboxMarieValue = true;
      if (_arguments.healthEntry.patientList.contains("Clément")) _checkboxClementValue = true;
      if (_arguments.healthEntry.patientList.contains("Camille")) _checkboxCamilleValue = true;
      if (_arguments.healthEntry.patientList.contains("Gabin")) _checkboxGabinValue = true;
      if (_arguments.healthEntry.patientList.contains("Lola")) _checkboxLolaValue = true;
      if (_arguments.healthEntry.patientList.contains("Nathan")) _checkboxNathanValue = true;
      if (_arguments.healthEntry.patientList.contains("Martin")) _checkboxMartinValue = true;
      _selectedCpam = _arguments.healthEntry.cpam;
      _selectedMnpaf = _arguments.healthEntry.mnpaf;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Ajout..."),
              IconButton(
                icon: Icon(Icons.check),
                iconSize: 50,
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    if (_onePatientAtLeastIsChecked()) {
                      _formKey.currentState.save();
                      _insertFormInHealthEntryTableAndFirebase();
                      Navigator.pop(context);
                    } else {
                      _scaffoldKey.currentState.showSnackBar(
                        SnackBar(
                          content: Text("Il faut selectionner au moins un patient")
                        )
                      );
                    }
                  }
                }
              )
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.1,
                      child: IconButton(
                          icon: Icon(Icons.date_range),
                        onPressed: () => _selectDate(context),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Text(
                        _dateFormat.format(_selectedDate).toString()
                        ),
                      ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      child: TextFormField(
                        initialValue: _typeValue,
                        decoration: const InputDecoration(
                            icon: Icon(Icons.home),
                            labelText:'Type'
                        ),
                        onSaved: (String value) => {_selectedType = value},
                        validator: (String value) {
                          if (value.isEmpty) return "pas glop";
                          else return null;
                        },
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      child: TextFormField(
                        initialValue: _whoInTypeValue,
                        decoration: const InputDecoration(
                              icon: Icon(Icons.perm_identity),
                              labelText:'Who'
                          ),
                          onSaved: (String value) => {_selectedWhoInType = value},
                      validator: (String value) {
                        if (value.isEmpty) return "pas glop";
                        else return null;
                      },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TextFormField(
                    initialValue: (_priceValue != 0) ? _priceValue.toString() : "",
                    decoration: const InputDecoration(
                          icon: Icon(Icons.attach_money),
                          labelText:'Montant'
                      ),
                    onSaved: (String value) {
                        value = value.replaceAll(",", ".");
                        _selectedPrice = double.parse(value);
                        },
                    validator: (String value) {
                      if (value.isEmpty || double.tryParse(value) == null) return "pas glop";
                      else return null;
                    },
                          keyboardType:TextInputType.number,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Checkbox(
                                  value: _checkboxMikeValue,
                                  onChanged: (bool value) {
                                    setState(() {
                                      _checkboxMikeValue = value;
                                    });
                                  },
                                ),
                                Text("Mike")
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Checkbox(
                                  value: _checkboxMarieValue,
                                  onChanged: (value) {
                                    setState(() {
                                      _checkboxMarieValue = value;
                                    });
                                  },
                                ),
                                Text("Marie")
                              ],
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Checkbox(
                                  value: _checkboxClementValue,
                                  onChanged: (bool value) {
                                    setState(() {
                                      _checkboxClementValue = value;
                                    });
                                  },
                                ),
                                Text("Clément")
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Checkbox(
                                  value: _checkboxCamilleValue,
                                  onChanged: (value) {
                                    setState(() {
                                      _checkboxCamilleValue = value;
                                    });
                                  },
                                ),
                                Text("Camille")
                              ],
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Checkbox(
                                  value: _checkboxGabinValue,
                                  onChanged: (bool value) {
                                    setState(() {
                                      _checkboxGabinValue = value;
                                    });
                                  },
                                ),
                                Text("Gabin")
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Checkbox(
                                  value: _checkboxLolaValue,
                                  onChanged: (value) {
                                    setState(() {
                                      _checkboxLolaValue = value;
                                    });
                                  },
                                ),
                                Text("Lola")
                              ],
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Checkbox(
                                  value: _checkboxNathanValue,
                                  onChanged: (bool value) {
                                    setState(() {
                                      _checkboxNathanValue = value;
                                    });
                                  },
                                ),
                                Text("Nathan")
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Checkbox(
                                  value: _checkboxMartinValue,
                                  onChanged: (value) {
                                    setState(() {
                                      _checkboxMartinValue = value;
                                    });
                                  },
                                ),
                                Text("Martin")
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: FormField(
                    builder: (FormFieldState state) {
                      return InputDecorator(
                          decoration: const InputDecoration(
                              icon: Icon(Icons.local_hospital),
                              labelText:'CPAM'
                          ),
                        child: cpamMnpafDropdownButton("cpam")
                      );
                    },
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: FormField(
                    builder: (FormFieldState state) {
                      return InputDecorator(
                          decoration: const InputDecoration(
                              icon: Icon(Icons.local_hospital),
                              labelText:'MNPAF'
                          ),
                          child: cpamMnpafDropdownButton("mnpaf")
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }

  DropdownButton cpamMnpafDropdownButton(String cpamOrMnpaf) {
    return DropdownButton<CpamMnpafState>(
      items: [
        DropdownMenuItem<CpamMnpafState>(
          value: CpamMnpafState.none,
          child: Text(
              "NA",
              style: TextStyle(color: HealthEntryTile.colorCpamMnpafStateNone)
          ),
        ),
        DropdownMenuItem<CpamMnpafState>(
          value: CpamMnpafState.rien,
          child: Text(
              "Rien",
              style: TextStyle(color: HealthEntryTile.colorCpamMnpafStateRien)
          ),
        ),
        DropdownMenuItem<CpamMnpafState>(
          value: CpamMnpafState.en_cours,
          child: Text(
              "En cours",
              style: TextStyle(color: HealthEntryTile.colorCpamMnpafStateEnCours)
          ),
        ),
        DropdownMenuItem<CpamMnpafState>(
          value: CpamMnpafState.ok,
          child: Text(
              "Ok",
              style: TextStyle(color: HealthEntryTile.colorCpamMnpafStateOk)
          ),
        ),
      ],
      onChanged: (value) {
        setState(() {
          cpamOrMnpaf == "cpam" ? _selectedCpam = value : _selectedMnpaf = value;
        });
      },
      value: cpamOrMnpaf == "cpam" ? _selectedCpam : _selectedMnpaf,
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101)
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }

  void _insertFormInHealthEntryTableAndFirebase() {
    HealthEntry healthEntry;

    if (_arguments.isModification) {
      healthEntry = _arguments.healthEntry;
    } else {
      healthEntry = HealthEntry.empty();
    }

    healthEntry.date = _selectedDate;
    healthEntry.type = _selectedType;
    healthEntry.whoInType = _selectedWhoInType;
    healthEntry.price = _selectedPrice;
    healthEntry.patientList = createPatientList();
    healthEntry.cpam = _selectedCpam;
    healthEntry.mnpaf = _selectedMnpaf;

    if (_arguments.isModification) {
      firebaseTool.modifyHealthEntry(healthEntry);
    } else {
      entryList.healthEntry.add(healthEntry);
      firebaseTool.saveHealthEntry(healthEntry);
    }
  }

  bool _onePatientAtLeastIsChecked() {
    if (_checkboxMikeValue == true || _checkboxMarieValue == true || _checkboxClementValue == true || _checkboxCamilleValue == true ||
        _checkboxGabinValue == true || _checkboxLolaValue == true || _checkboxNathanValue == true || _checkboxMartinValue == true)
      return true;
    else return false;
  }

  List<String> createPatientList() {
    final List<String> patientList = [];
    
    if (_checkboxMikeValue) patientList.add("Mike");
    if (_checkboxMarieValue) patientList.add("Marie");
    if (_checkboxClementValue) patientList.add("Clément");
    if (_checkboxCamilleValue) patientList.add("Camille");
    if (_checkboxGabinValue) patientList.add("Gabin");
    if (_checkboxLolaValue) patientList.add("Lola");
    if (_checkboxNathanValue) patientList.add("Nathan");
    if (_checkboxMartinValue) patientList.add("Martin");

    return patientList;
  }

  
}

class HealthScreenAddEntryArguments {
  bool isModification;
  HealthEntry healthEntry;

  HealthScreenAddEntryArguments(this.isModification, {this.healthEntry});
}