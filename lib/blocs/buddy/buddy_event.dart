part of 'buddy_bloc.dart';

@immutable
abstract class BuddyEvent {}

class BuddyInitializeEvent extends BuddyEvent {}

class BuddySendEvent extends BuddyEvent {}

class BuddyCheckListenEvent extends BuddyEvent {}

class BuddyStartListeningEvent extends BuddyEvent {}

class BuddyCompleteListeningEvent extends BuddyEvent {}
