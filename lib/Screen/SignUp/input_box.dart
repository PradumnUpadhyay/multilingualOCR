import 'package:flutter/material.dart';

class InputBox extends StatelessWidget {
  final Widget child;
  const InputBox({
    Key key,
    this.child
}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Size size=MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      width: size.width*0.8,
      decoration: BoxDecoration(
          color: Color(0xFFF1E6FF),
          borderRadius: BorderRadius.circular(29)
      ),

      child: child,
    );
  }
}
