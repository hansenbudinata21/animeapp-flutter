import 'package:flutter/material.dart';

class CircularLoading extends StatelessWidget {
  final double size;
  const CircularLoading({Key? key, required this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: size,
        width: size,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
