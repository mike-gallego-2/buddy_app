import 'dart:async';
import 'dart:io';

import 'package:buddy_app/services/openai_service.dart';
import 'package:flutter_speech/flutter_speech.dart';
import 'package:flutter_tts/flutter_tts.dart';

class BuddyRepository {
  late final SpeechRecognition _speech;
  late final FlutterTts _tts;

  BuddyRepository()
      : _speech = SpeechRecognition(),
        _tts = FlutterTts();

  // initialize speech
  Future<bool> initializeSpeech() async {
    return await _speech.activate('en_US').then((value) => true).catchError((error) => false);
  }

  Future<bool> startListening() async {
    return await _speech.listen().then((value) => true).catchError((error) => false);
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
    List<String> completions = [];
    _speech.setRecognitionCompleteHandler((result) async {
      completions.add(result);
      if (completions.length == 2) {
        controller.add(result);
      }
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

  Future<void> _initializeTts() async {
    await _tts.setVoice({"name": "Karen", "locale": "en-US"});
    await _initIos();
    await _tts.awaitSpeakCompletion(true);
  }

  Future<void> _initIos() async {
    if (!Platform.isIOS) return;
    await _tts.setSharedInstance(true);
    await _tts.setIosAudioCategory(
      IosTextToSpeechAudioCategory.playback,
      [IosTextToSpeechAudioCategoryOptions.mixWithOthers],
      //IosTextToSpeechAudioMode.voicePrompt,
    );
  }

  Future<void> speak(String text) async {
    await _initializeTts();
    await _tts.speak(text);
  }
}
