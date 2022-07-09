import 'package:buddy_app/constants/styles.dart';
import 'package:buddy_app/constants/text.dart';
import 'package:flutter/material.dart';

class ResponseWidget extends StatelessWidget {
  final String recipient;
  final String response;
  const ResponseWidget({Key? key, required this.recipient, required this.response}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: recipient == sender ? Alignment.centerRight : Alignment.centerLeft,
      height: 500,
      child: Text(
        response,
        style: const TextStyle(
          fontSize: 16,
          color: white,
        ),
      ),
    );
  }
}
