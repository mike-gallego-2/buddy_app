part of 'buddy_bloc.dart';

@immutable
abstract class BuddyEvent {}

class BuddySendEvent extends BuddyEvent {
  final String input;
  BuddySendEvent({required this.input});
}
