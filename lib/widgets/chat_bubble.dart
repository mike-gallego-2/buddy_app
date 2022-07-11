import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:buddy_app/constants/styles.dart';
import 'package:buddy_app/repositories/buddy_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatBubble extends StatelessWidget {
  final String text;
  final int id;
  const ChatBubble({Key? key, required this.text, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () async {
        // get the render box from the context
        final RenderBox renderBox = context.findRenderObject() as RenderBox;
        final offset = renderBox.localToGlobal(Offset.zero);
        final left = offset.dx;
        final top = offset.dy + renderBox.size.height;
        final right = left + renderBox.size.width;

        await showMenu(
          context: context,
          items: [
            PopupMenuItem(
              value: 'copy',
              child: Center(
                  child: Text(
                'Copy',
                style: getStyle(color: lightGrey),
              )),
              onTap: () async {
                await Clipboard.setData(ClipboardData(text: text));
              },
            ),
          ],
          color: lightGreen,
          position: RelativeRect.fromLTRB(left, top - 100, right, 0.0),
        );
      },
      child: Container(
        padding: standardPadding,
        margin: standardPadding,
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        decoration: BoxDecoration(
            color: context.read<BuddyRepository>().isOdd(id) ? senderColor : recipientColor,
            borderRadius: standardRadius),
        child: context.read<BuddyRepository>().isOdd(id)
            ? Text(
                text.trim(),
                style: getStyle(fontSize: 14),
              )
            : AnimatedTextKit(
                animatedTexts: [TyperAnimatedText(text.trim(), textStyle: getStyle(fontSize: 14))],
                isRepeatingAnimation: false,
              ),
      ),
    );
  }
}
