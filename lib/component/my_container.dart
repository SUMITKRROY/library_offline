import 'package:flutter/material.dart';

class GradientContainer extends StatelessWidget {
  final Widget child;

  const GradientContainer({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.deepPurple.withOpacity(0.8), // 80% opacity
            Colors.black // 60% opacity
          ],
          begin: Alignment.topCenter,
        ),
      ),
      child: child,
    );
  }
}
