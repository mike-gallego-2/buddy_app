import 'package:buddy_app/blocs/buddy/buddy_bloc.dart';
import 'package:buddy_app/constants/styles.dart';
import 'package:buddy_app/widgets/chat_bubble.dart';
import 'package:buddy_app/widgets/prompt_builder.dart';
import 'package:buddy_app/widgets/vertical_space.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PromptScreen extends StatefulWidget {
  const PromptScreen({Key? key}) : super(key: key);

  @override
  State<PromptScreen> createState() => _PromptScreenState();
}

class _PromptScreenState extends State<PromptScreen> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      body: Container(
        width: double.infinity,
        padding: standardPadding,
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          child: BlocConsumer<BuddyBloc, BuddyState>(
            listener: (context, state) async {
              if (state.status == BuddyStatus.done) {
                await _scrollController.animateTo(
                  _scrollController.position.maxScrollExtent * 2,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOut,
                );
              }
            },
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const VerticalSpace(),
                  Text(
                    'Hello,\nI am your buddy',
                    style: getStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const VerticalSpace(height: 8),
                  Text(
                    'What can I help you with?',
                    style: getStyle(color: lightGrey),
                  ),
                  const VerticalSpace(),
                  Column(
                    children: state.prompt.entries
                        .map((element) => Align(
                            alignment: _isOdd(element.key) ? Alignment.centerRight : Alignment.centerLeft,
                            child: ChatBubble(text: element.value, id: element.key)))
                        .toList(),
                  ),
                  const PromptBuilder()
                ],
              );
            },
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     // open a prompt

      //   },
      //   child: const Icon(Icons.keyboard),
      // ),
    );
  }

  bool _isOdd(int number) {
    return number % 2 != 0;
  }
}
