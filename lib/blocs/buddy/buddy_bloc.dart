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
    on<BuddyCheckListenEvent>((event, emit) async {
      final isAvailable = await buddyRepository.initializeSpeech();
      emit(state.copyWith(isMicAvailable: isAvailable));
      if (isAvailable) {
        await emit.forEach<bool>(buddyRepository.isListening(), onData: (isListening) {
          debugPrint(isListening.toString());
          return state.copyWith(isListening: isListening);
        });
      } else {
        print('could not listen');
        emit(state.copyWith(status: BuddyStatus.error));
      }
    });
    on<BuddyStartListeningEvent>((event, emit) async {
      emit(state.copyWith(status: BuddyStatus.busy));
      if (state.isMicAvailable && state.isListening) {
        await emit.forEach<String>(buddyRepository.handleResult(), onData: (result) {
          final prompt = '$sender: $result\n';
          final newPrompt = {...state.prompt, state.currentId: prompt};

          return state.copyWith(input: result, prompt: newPrompt, feedback: 'done listening');
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
      emit(state.copyWith(status: BuddyStatus.busy));
      // first create the string to send to the AI
      final prompt = '$sender: ${event.input}\n';
      // now add the prompt to the map
      final newPrompt = {...state.prompt, state.currentId: prompt};
      emit(state.copyWith(prompt: newPrompt));

      final response = await buddyRepository.sendMessage(newPrompt);
      final readableText = buddyRepository.convertResponseToReadableText(response);

      // add response to map
      final newResponse = {...newPrompt, state.currentId + 1: '$recipient:$readableText\n'};

      emit(state.copyWith(
          prompt: newResponse, response: readableText, status: BuddyStatus.idle, currentId: newResponse.keys.last + 1));
    });
  }
}
