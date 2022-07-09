import 'package:flutter/cupertino.dart';

class VerticalSpace extends StatelessWidget {
  final double? height;
  const VerticalSpace({Key? key, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 32,
    );
  }
}
