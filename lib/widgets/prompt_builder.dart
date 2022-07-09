import 'package:buddy_app/blocs/buddy/buddy_bloc.dart';
import 'package:buddy_app/constants/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PromptBuilder extends StatefulWidget {
  const PromptBuilder({
    Key? key,
  }) : super(key: key);

  @override
  State<PromptBuilder> createState() => _PromptBuilderState();
}

class _PromptBuilderState extends State<PromptBuilder> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      color: Colors.black54,
      child: BlocBuilder<BuddyBloc, BuddyState>(
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                  child: Center(
                child: TextField(
                  controller: _controller,
                  textAlign: TextAlign.center,
                  style: getStyle(),
                  decoration: InputDecoration.collapsed(hintText: 'Type here', hintStyle: getStyle(color: lightGrey)),
                  onSubmitted: (_) {
                    context.read<BuddyBloc>().add(BuddySendEvent(input: _controller.text));
                    _controller.clear();
                  },
                ),
              )),
              // if (state.status == BuddyStatus.done) ...[
              //   Expanded(child: Text(state.response)),
              // ] else if (state.status == BuddyStatus.busy) ...[
              //   const Expanded(
              //     child: CircularProgressIndicator(),
              //   )
              // ] else ...[
              //   const Expanded(
              //     child: Text(''),
              //   )
              // ],
            ],
          );
        },
      ),
    );
  }
}
