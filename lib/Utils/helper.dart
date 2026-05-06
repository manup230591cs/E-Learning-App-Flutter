import 'dart:convert';
import 'package:flutter/services.dart' as rootBundle;
import 'package:e_learning/question_model.dart';

// Function to load and parse JSON data
Future<QuestionList> loadQuestions() async {
  // Load JSON file from assets
  final jsonString =
      await rootBundle.rootBundle.loadString('assets/questions.json');

  // Decode JSON string to a Map
  final jsonResponse = json.decode(jsonString);

  // Parse the JSON data using the QuestionList model
  return QuestionList.fromJson(jsonResponse);
}
