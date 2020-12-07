import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:voteit/models/question.dart';
import 'package:voteit/models/response_result.dart';
import 'package:voteit/repository/repository.dart';

class MainBloc {
  final StreamController questionController = StreamController<ResponseResult<List<Question>>>();
  final StreamController singleQuestionController = StreamController<ResponseResult<Question>>();
  final StreamController loginController = StreamController<ResponseResult>();
  final Repository _repository = Repository();

  getQuestion() async {
    final result = await _repository.getQuestions();
    questionController.add(result);
  }

  getSingleQuestion(String questionId) async {
    final result = await _repository.getSingleQuestion(questionId);
    singleQuestionController.add(result);
  }

  addVote(String questionId, String itemId, String userName) async {
    final result = await _repository.addVote(questionId, itemId, userName);
    return result;
  }

  removeVote(String questionId, String itemId, String userName) async {
    final result = await _repository.removeVote(questionId, itemId, userName);
    return result;
  }

  login(String userName, String password) async {
    final result = await _repository.login(userName, password);
    loginController.add(result);
  }


  dispose() {
    questionController.close();
    loginController.close();
    singleQuestionController.close();
  }
}