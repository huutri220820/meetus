import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final double height;
  final double width;
  final Function onPressed;
  final Text text;
  const GradientButton({
    Key key,
    this.height,
    this.width,
    this.onPressed,
    this.text,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: this.width,
      height: this.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(80),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xffffae88), Color(0xff8f93ea)],
        ),
      ),
      child: MaterialButton(
        onPressed: this.onPressed,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: StadiumBorder(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: text,
        ),
      ),
    );
  }
}
