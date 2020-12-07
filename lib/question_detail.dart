import 'package:flutter/material.dart';
import 'package:voteit/bloc.dart';
import 'package:voteit/login.dart';
import 'package:voteit/models/question.dart';
import 'package:voteit/models/response_result.dart';

class QuestionDetailScreen extends StatefulWidget {
  final Question question;
  final String userName;
  QuestionDetailScreen({this.question, this.userName});

  @override
  _QuestionDetailScreenState createState() => _QuestionDetailScreenState();
}

class _QuestionDetailScreenState extends State<QuestionDetailScreen> {
  final MainBloc _mainBloc = MainBloc();
  final _key = GlobalKey<ScaffoldState>();
  var _value;
  bool _display = false;

  @override
  void initState() {
    _mainBloc.getSingleQuestion(widget.question.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: Text(
          'Question Detail',
          style: TextStyle(fontSize: 15),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<ResponseResult<Question>>(
          stream: _mainBloc.singleQuestionController.stream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container(
                  child: Center(child: CircularProgressIndicator()));
            }
            final _question = snapshot.data.data;
            if (_value == null) {
              for (var item in _question.items) {
                if (item.voters.contains(widget.userName)) {
                  _display = true;
                  _value = _question.items.indexOf(item);
                }
              }
            }
            return Column(
              children: [
                Text(_question.content),
                Column(
                  children: List<Widget>.generate(
                    _question.items.length,
                    (i) => Row(
                      children: [
                        Radio(
                            value: i,
                            groupValue: _value,
                            onChanged: (value) async {
                              if (widget.userName == null) {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                        title: Text('Unauthorized'),
                                        content: Container(
                                            height: 100,
                                            child: Center(
                                              child: Column(
                                                children: [
                                                  FlatButton(
                                                    child: Text("Login Now"),
                                                    onPressed: () => Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                LoginScreen())),
                                                  ),
                                                  FlatButton(
                                                    child: Text("Cancel"),
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                  ),
                                                ],
                                              ),
                                            ))));
                              } else {
                                setState(() {
                                  _value = i;
                                  _display = true;
                                });
                                if (!_question.items[i].voters
                                    .contains(widget.userName)) {
                                  await _mainBloc.addVote(_question.id,
                                      _question.items[i].id, widget.userName);
                                  await _mainBloc.removeVote(_question.id,
                                      _question.items[i].id, widget.userName);
                                  _mainBloc
                                      .getSingleQuestion(widget.question.id);
                                }
                              }
                            }),
                        if (!_display) Text(_question.items[i].name ?? ''),
                        if (_display)
                          Text(
                              '${_question.items[i].name} (${_question.items[i].voteCount})' ??
                                  ''),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }
}
