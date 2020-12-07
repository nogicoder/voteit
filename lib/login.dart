import 'package:flutter/material.dart';
import 'package:voteit/app.dart';
import 'package:voteit/bloc.dart';
import 'package:voteit/models/response_result.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final MainBloc _mainBloc = MainBloc();
  final TextEditingController _editingController = TextEditingController();
  final TextEditingController _passEditingController = TextEditingController();
  var _password = '';

  @override
  void initState() {
    _mainBloc.loginController.stream.listen((snapshot) {
      print(snapshot);
      if ((snapshot as ResponseResult).data == true) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    VoteItApp(userName: _editingController.text)));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Login'),
        ),
        body: Column(
          children: [
            TextField(
              controller: _editingController,
            ),
            TextField(
              controller: _passEditingController,
            ),
            FlatButton(
              onPressed: () =>
                  _mainBloc.login(_editingController.text, _passEditingController.text),
              child: Text('Submit'),
            )
          ],
        ));
  }
}
