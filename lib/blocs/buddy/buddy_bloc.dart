import 'package:bloc/bloc.dart';
import 'package:buddy_app/constants/text.dart';
import 'package:buddy_app/repositories/buddy_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

part 'buddy_event.dart';
part 'buddy_state.dart';

class BuddyBloc extends Bloc<BuddyEvent, BuddyState> {
  final BuddyRepository buddyRepository;
  BuddyBloc({required this.buddyRepository})
      : super(const BuddyState(
          prompt: {},
          response: '',
          input: '',
          status: BuddyStatus.idle,
          currentId: 1,
          isMicAvailable: false,
          isListening: false,
          feedback: '',
        )) {
    on<BuddyInitializeEvent>((event, emit) async {
      await buddyRepository.speak('Hello, I am your buddy');
    });
    on<BuddyCheckListenEvent>((event, emit) async {
      final isAvailable = await buddyRepository.initializeSpeech();
      emit(state.copyWith(isMicAvailable: isAvailable));
      if (isAvailable) {
        final isListening = await buddyRepository.startListening();
        emit(state.copyWith(isListening: isListening, status: BuddyStatus.busy));
      } else {
        debugPrint('could not listen');
        emit(state.copyWith(status: BuddyStatus.error));
      }
    });
    on<BuddyStartListeningEvent>((event, emit) async {
      if (state.isMicAvailable && state.isListening) {
        await emit.forEach<String>(buddyRepository.handleResult(), onData: (result) {
          final prompt = '$sender: $result\n';
          final newPrompt = {...state.prompt, state.currentId: prompt};

          return state.copyWith(input: result, prompt: newPrompt);
        });
      } else {
        emit(state.copyWith(status: BuddyStatus.error));
      }
    });
    on<BuddyCompleteListeningEvent>((event, emit) async {
      await emit.forEach<String>(buddyRepository.handleFeedback(), onData: (feedback) {
        return state.copyWith(
          feedback: feedback,
          isListening: false,
          isMicAvailable: false,
          status: BuddyStatus.idle,
        );
      });
    });
    on<BuddySendEvent>((event, emit) async {
      // first create the string to send to the AI
      final prompt = '$sender: ${event.input}\n';
      // now add the prompt to the map
      final newPrompt = {...state.prompt, state.currentId: prompt};
      emit(state.copyWith(prompt: newPrompt));

      final response = await buddyRepository.sendMessage(newPrompt);
      final readableText = buddyRepository.convertResponseToReadableText(response);
      await buddyRepository.speak(readableText);

      // add response to map
      final newResponse = {...newPrompt, state.currentId + 1: '$recipient:$readableText\n'};

      emit(state.copyWith(
        prompt: newResponse,
        response: readableText,
        status: BuddyStatus.idle,
        currentId: newResponse.keys.last + 1,
        feedback: 'speak',
      ));
    });
  }
}
