import 'package:buddy_app/blocs/buddy/buddy_bloc.dart';
import 'package:buddy_app/repositories/buddy_repository.dart';
import 'package:buddy_app/screens/prompt_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => BuddyRepository(),
      child: BlocProvider(
        create: (context) => BuddyBloc(buddyRepository: context.read<BuddyRepository>()),
        child: const MaterialApp(title: 'Buddy Demo', home: PromptScreen()),
      ),
    );
  }
}
