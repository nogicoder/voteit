import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voteit/models/question.dart';
import 'package:voteit/models/response_result.dart';

class Repository {
  var fireStore = Firestore.instance;

  //! Firestore Collection Query
  Future<ResponseResult<List<Question>>> getQuestions() async {
    try {
      QuerySnapshot _query =
          await fireStore.collection('questions').getDocuments();
      var result = <Question>[];
      for (var query in _query.documents) {
        var _question =
            Question(id: query.documentID, content: query.data['content']);
        result.add(_question);
      }
      return ResponseResult(
        state: ResponseState.SUCCESS,
        data: result,
      );
    } catch (error) {
      print('Error - getQuestions - $error');
      return ResponseResult.fromError(error);
    }
  }

  Future<ResponseResult<Question>> getSingleQuestion(String questionId) async {
    try {
      DocumentSnapshot _snapshot =
          await fireStore.collection('questions').document(questionId).get();
      var _question = Question(
          id: _snapshot.documentID, content: _snapshot.data['content']);
      QuerySnapshot _docs = await fireStore
          .collection('questions')
          .document(_snapshot.documentID)
          .collection('items')
          .getDocuments();
      print(_docs.documents.first.data);
      var _items = List<VoteItem>.from(_docs.documents
          .map((doc) => VoteItem.fromJson(doc.data)..id = doc.documentID));
      _question..items = _items;
      return ResponseResult(
        state: ResponseState.SUCCESS,
        data: _question,
      );
    } catch (error) {
      print('Error - getQuestions - $error');
      return ResponseResult.fromError(error);
    }
  }

  Future<ResponseResult<bool>> addVote(
      String questionId, String itemId, String userName) async {
    try {
      DocumentSnapshot snapshot = await fireStore
          .collection('questions')
          .document(questionId)
          .collection('items')
          .document(itemId)
          .get();

      var _doc = fireStore
          .collection('questions')
          .document(questionId)
          .collection('items')
          .document(itemId)
          .updateData({
        'voteCount': snapshot.data['voteCount'] + 1,
        'voters': List<String>.from(snapshot.data['voters'])..add(userName)
      });
      return ResponseResult(
        state: ResponseState.SUCCESS,
        data: true,
      );
    } catch (error) {
      print('Error - getQuestions - $error');
      return ResponseResult.fromError(error);
    }
  }

  Future<ResponseResult<bool>> removeVote(
      String questionId, String itemId, String userName) async {
    try {
      QuerySnapshot itemCollection = await fireStore
          .collection('questions')
          .document(questionId)
          .collection('items')
          .getDocuments();

      for (var doc in itemCollection.documents) {
        if (doc.documentID != itemId) {
          print(itemId);
          var snapshot = await fireStore
              .collection('questions')
              .document(questionId)
              .collection('items')
              .document(doc.documentID)
              .get();
          var _doc = fireStore
              .collection('questions')
              .document(questionId)
              .collection('items')
              .document(doc.documentID)
              .updateData({
            'voteCount': snapshot.data['voteCount'] == 0
                ? 0
                : snapshot.data['voteCount'] - 1,
            'voters': List<String>.from(snapshot.data['voters'])
              ..remove(userName)
          });
        }
      }
      return ResponseResult(
        state: ResponseState.SUCCESS,
        data: true,
      );
    } catch (error) {
      print('Error - getQuestions - $error');
      return ResponseResult.fromError(error);
    }
  }

  Future<ResponseResult<bool>> login(String userName, String password) async {
    try {
      QuerySnapshot _query = await fireStore.collection('users').getDocuments();
      if (_query.documents.firstWhere(
              (element) =>
                  element.data['name'] == userName &&
                  element.data['password'] == password,
              orElse: () => null) !=
          null) {
        return ResponseResult(
          state: ResponseState.SUCCESS,
          data: true,
        );
      }
      return ResponseResult(
        state: ResponseState.SUCCESS,
        data: false,
      );
    } catch (error) {
      print('Error - getQuestions - $error');
      return ResponseResult.fromError(error);
    }
  }
}
