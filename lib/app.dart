import 'package:flutter/material.dart';
import 'package:voteit/bloc.dart';
import 'package:voteit/models/question.dart';
import 'package:voteit/models/response_result.dart';
import 'package:voteit/question_detail.dart';

class VoteItApp extends StatefulWidget {
  String userName;
  VoteItApp({this.userName});

  @override
  _VoteItAppState createState() => _VoteItAppState();
}

class _VoteItAppState extends State<VoteItApp> {
  final MainBloc _mainBloc = MainBloc();
  var _currentTab = 0;

  @override
  void initState() {
    _mainBloc.getQuestion();
    super.initState();
  }

  @override
  void dispose() {
    _mainBloc.dispose();
    super.dispose();
  }

  var _value;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('VoteIt!', style: TextStyle(color: Colors.green)),
        elevation: 0.0,
        automaticallyImplyLeading: false,
        // leading: Icon(Icons.arrow_back_ios),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        actions: [
          Container(
            padding: EdgeInsets.only(right: 10),
            child: CircleAvatar(
              backgroundColor: Colors.red,
              radius: 20,
            ),
          )
        ],
      ),
      body: Container(
          child: Column(
        children: [
          ListTile(title: Text('Question List')),
          StreamBuilder<ResponseResult<List<Question>>>(
            stream: _mainBloc.questionController.stream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container();
              }
              var _questions = snapshot.data.data ?? [];
              return Column(
                children: List<Widget>.generate(
                  _questions.length,
                  (index) => InkWell(
                      onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QuestionDetailScreen(
                                question: _questions[index],
                                userName: widget.userName,
                              ),
                            ),
                          ),
                      child: ListTile(title: Text(_questions[index].content))),
                ),
              );
            },
          ),
        ],
      )),
    );
  }
}
