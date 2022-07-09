part of 'buddy_bloc.dart';

class BuddyState extends Equatable {
  final Map<int, String> prompt;
  final String response;
  final String input;
  final BuddyStatus status;
  final int currentId;

  const BuddyState(
      {required this.prompt,
      required this.response,
      required this.input,
      required this.status,
      required this.currentId});

  @override
  List<Object> get props => [prompt, response, input, status, currentId];

  BuddyState copyWith(
      {Map<int, String>? prompt, String? response, String? input, BuddyStatus? status, int? currentId}) {
    return BuddyState(
      prompt: prompt ?? this.prompt,
      response: response ?? this.response,
      input: input ?? this.input,
      status: status ?? this.status,
      currentId: currentId ?? this.currentId,
    );
  }
}

enum BuddyStatus {
  idle,
  busy,
  done,
}
