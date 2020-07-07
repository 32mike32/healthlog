import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:healthlog/Authentication.dart';

class LoginPage extends StatefulWidget {
  LoginPage({this.auth, this.loginCallback});

  final Authentication auth;
  final VoidCallback loginCallback;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = new GlobalKey<FormState>();
  String _email;
  String _password;
  String _errorMessage;
  bool _isLoading;

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.green,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                "HealthLog",
              ),
              Card(
                elevation: 10.0,
                child: Container(
                  padding: EdgeInsets.all(15),
                  height: 250,
                  child: Stack(
                    children: <Widget>[
                      _showForm(),
                      _showCircularProgress(),
                    ],
                  )

                ),
              ),
            ],
          )
        )
      )
    );
  }

  Widget _showForm() {
    return Container(
      child: new Form(
        key: _formKey,
        child : new ListView(
          children: <Widget>[
            _showEmailInput(),
            _showPasswordInput(),
            _showSpace(),
            _showButtonConnection(),
            _showErrorMessage(),
          ],
        )
      )
    );
  }

  Widget _showEmailInput () {
    return TextFormField(
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
              hintText: "Email"
          ),
          validator: (value) => value.isEmpty ? "Entrez votre email" : null,
          onSaved: (value) => _email = value.trim(),
        );
  }

  Widget _showPasswordInput() {
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(
        hintText: "Mot de passe",
      ),
      validator: (value) => value.isEmpty ? "Entrez votre mot de passe" : null,
      onSaved: (value) => _password = value.trim(),
    );
  }
Widget _showSpace() {
    return Container(
      height: 30,
    );
}

  Widget _showButtonConnection() {
    return RaisedButton(
        onPressed: _validateAndSubmit,
        elevation: 10.0,
        child: Text(
            "Connection"
        )
    );
  }

  // Perform login or signup
  void _validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (validateAndSave()) {
      String userId = "";
      try {
        userId = await widget.auth.signIn(_email, _password);
        print('Signed in: $userId');
        setState(() {
          _isLoading = false;
        });

        if (userId.length > 0 && userId != null) {
          widget.loginCallback();
        }
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          _errorMessage = e.message;
          _formKey.currentState.reset();
        });
      }
    }
  }

  // Check if form is valid before perform login or signup
  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Widget _showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return new Text(
        _errorMessage,
        style: TextStyle(
            fontSize: 13.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300),

      );
    } else {
      return Container(
          height: 0.0
      );
    }
  }

  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }
}