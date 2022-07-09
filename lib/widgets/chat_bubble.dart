import 'package:buddy_app/constants/styles.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String text;
  final int id;
  const ChatBubble({Key? key, required this.text, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: smallPadding,
      margin: standardPadding,
      width: MediaQuery.of(context).size.width / 2,
      decoration:
          BoxDecoration(color: _isOdd(id) ? senderColor : recipientColor, borderRadius: BorderRadius.circular(15)),
      child: Text(
        text,
        style: getStyle(fontSize: 14),
      ),
    );
  }

  // check if odd
  bool _isOdd(int number) {
    return number % 2 != 0;
  }
}
