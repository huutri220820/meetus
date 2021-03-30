import 'package:flutter/material.dart';

class MatchButton extends StatelessWidget {
  const MatchButton({
    Key key,
    @required this.icon,
    @required this.bgcolor,
  }) : super(key: key);
  final Icon icon;
  final Color bgcolor;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(3, 5),
          ),
        ],
      ),
      child: CircleAvatar(
        radius: 30,
        backgroundColor: bgcolor,
        child: icon,
      ),
    );
  }
}
