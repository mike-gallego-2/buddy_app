import 'package:buddy_app/blocs/bloc_observer.dart';
import 'package:buddy_app/blocs/buddy/buddy_bloc.dart';
import 'package:buddy_app/repositories/buddy_repository.dart';
import 'package:buddy_app/screens/prompt_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  BlocOverrides.runZoned(() {
    runApp(const MyApp());
  }, blocObserver: BuddyBlocObserver());
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
        create: (context) => BuddyBloc(buddyRepository: context.read<BuddyRepository>())..add(BuddyInitializeEvent()),
        child: const MaterialApp(
          title: 'Buddy Demo',
          home: PromptScreen(),
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
