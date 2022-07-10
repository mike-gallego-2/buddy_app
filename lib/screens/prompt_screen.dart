import 'package:buddy_app/blocs/buddy/buddy_bloc.dart';
import 'package:buddy_app/constants/styles.dart';
import 'package:buddy_app/widgets/chat_bubble.dart';
import 'package:buddy_app/widgets/vertical_space.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

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
        child: BlocConsumer<BuddyBloc, BuddyState>(
          listener: (context, state) {
            if (state.status == BuddyStatus.idle) {
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
                await _scrollController.animateTo(
                  _scrollController.position.maxScrollExtent == 0 ? 0 : _scrollController.position.maxScrollExtent + 25,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                );
              });
            }

            if (state.isMicAvailable && state.isListening) {
              context.read<BuddyBloc>().add(BuddyStartListeningEvent());
            }

            if (state.feedback == 'done listening') {
              context.read<BuddyBloc>().add(BuddyCompleteListeningEvent());
            }

            if (state.feedback == 'handle_completed_intent') {
              debugPrint('testing');
              context.read<BuddyBloc>().add(BuddySendEvent(input: state.input));
            }
          },
          builder: (context, state) {
            return CustomScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
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
                      state.prompt.length < 4
                          ? const VerticalSpace(
                              height: 200,
                            )
                          : const VerticalSpace(
                              height: 0,
                            )
                    ],
                  ),
                ),
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: state.status != BuddyStatus.busy
                        ? GestureDetector(
                            onTap: () {
                              context.read<BuddyBloc>().add(BuddyCheckListenEvent());
                            },
                            child: Image.asset(
                              'assets/mic_static.png',
                              height: 100,
                              width: 100,
                            ),
                          )
                        : Lottie.asset('assets/mic_animation.json', height: 100, width: 100),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  bool _isOdd(int number) {
    return number % 2 != 0;
  }
}
