import 'dart:async';

import 'package:buddy_app/services/openai_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speech/flutter_speech.dart';

class BuddyRepository {
  late final SpeechRecognition _speech;

  BuddyRepository() : _speech = SpeechRecognition();

  // initialize speech
  Future<bool> initializeSpeech() async {
    return await _speech.activate('en_US').then((_) => _speech.listen().then((_) => true)).catchError((_) => false);
  }

  Stream<bool> isListening() {
    // make a stream controller to listen to the speech recognition
    final controller = StreamController<bool>();
    _speech.setRecognitionStartedHandler(() {
      debugPrint('started');
      controller.add(true);
    });

    return controller.stream;
  }

  Stream<String> handleResult() {
    final controller = StreamController<String>();
    _speech.setRecognitionResultHandler((result) {
      controller.add(result);
    });
    return controller.stream;
  }

  Stream<String> handleFeedback() {
    final controller = StreamController<String>();
    _speech.setRecognitionCompleteHandler((result) {
      debugPrint('completed');
      controller.add('handle_completed_intent');
    });
    return controller.stream;
  }

  Future<String> sendMessage(Map<int, String> prompt) async {
    final openAiService = OpenAiService();
    // convert the map to a string
    final promptString = prompt.values.join('\n');
    final response = await openAiService.create(prompt: promptString);
    return response;
  }

  String convertResponseToReadableText(String response) {
    final responseSection = response.split(':');
    final readableText = responseSection.last;
    return readableText;
  }
}
