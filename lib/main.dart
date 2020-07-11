import 'package:flutter/material.dart';
import 'package:healthlog/HealthScreenPage.dart';
import 'Authentication.dart';
import 'FirebaseTool.dart';
import 'HealthEntry.dart';
import 'HealthScreenAddEntry.dart';
import 'RootPage.dart';

/* TODO
 - suppression des commentaires
 - dispose listen firebase
 - ajouter un champ remarque
   - ajouter comment dans fromJson, fromsnapchot et toJson dans healthentry
 - gérer les erreurs
*/

/* en cours
https://github.com/tattwei46/flutter_login_demo/blob/master/lib/pages/login_signup_page.dart
au niveau de   bool validateAndSave() {
 */

FirebaseTool firebaseTool = FirebaseTool();
HealthEntryList entryList = HealthEntryList();

final ThemeData kDefaultTheme = new ThemeData(
    primarySwatch: Colors.lightGreen,
    backgroundColor: Colors.green
);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "HealthLog",
        theme: kDefaultTheme,
        home: RootPage(auth: Authentication()),
        routes: {
          HealthScreenPage.route: (_) => HealthScreenPage(),
          HealthScreenAddEntry.route: (context) => HealthScreenAddEntry(ModalRoute.of(context).settings.arguments)
        }
    );
  }
}