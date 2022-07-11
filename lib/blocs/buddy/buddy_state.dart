part of 'buddy_bloc.dart';

class BuddyState extends Equatable {
  final Map<int, String> prompt;
  final String response;
  final String previousResponse;
  final String input;
  final BuddyStatus status;
  final int currentId;
  final bool isMicAvailable;
  final bool isListening;
  final bool readyToSend;

  const BuddyState({
    required this.prompt,
    required this.response,
    required this.previousResponse,
    required this.input,
    required this.status,
    required this.currentId,
    required this.isMicAvailable,
    required this.isListening,
    required this.readyToSend,
  });

  @override
  List<Object> get props =>
      [prompt, response, previousResponse, input, status, currentId, isMicAvailable, isListening, readyToSend];

  BuddyState copyWith({
    Map<int, String>? prompt,
    String? response,
    String? previousResponse,
    String? input,
    BuddyStatus? status,
    int? currentId,
    bool? isMicAvailable,
    bool? isListening,
    bool? readyToSend,
  }) {
    return BuddyState(
      prompt: prompt ?? this.prompt,
      response: response ?? this.response,
      previousResponse: previousResponse ?? this.previousResponse,
      input: input ?? this.input,
      status: status ?? this.status,
      currentId: currentId ?? this.currentId,
      isMicAvailable: isMicAvailable ?? this.isMicAvailable,
      isListening: isListening ?? this.isListening,
      readyToSend: readyToSend ?? this.readyToSend,
    );
  }
}

enum BuddyStatus {
  idle,
  busy,
  error,
}
