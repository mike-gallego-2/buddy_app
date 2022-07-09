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
      : super(const BuddyState(prompt: {
          1: '$sender : Hello, who are you?\n',
          2: '$recipient : I am an ai created by OpenAI. How can I help you today?\n',
        }, response: '', input: '', status: BuddyStatus.idle, currentId: 3)) {
    on<BuddySendEvent>((event, emit) async {
      emit(state.copyWith(status: BuddyStatus.busy));
      // first create the string to send to the AI
      final prompt = '$sender : ${event.input}\n';
      // now add the prompt to the map
      final newPrompt = {...state.prompt, state.currentId: prompt};

      final response = await buddyRepository.sendMessage(newPrompt);
      final readableText = buddyRepository.convertResponseToReadableText(response);

      // add response to map
      final newResponse = {...newPrompt, state.currentId + 1: '$recipient: $readableText\n'};

      emit(state.copyWith(
          prompt: newResponse, response: readableText, status: BuddyStatus.done, currentId: newResponse.keys.last + 1));
    });
  }
}
