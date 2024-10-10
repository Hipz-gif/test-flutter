import 'package:flutter/material.dart';

class CustomFormContainer extends StatelessWidget {
  final Widget child;

  const CustomFormContainer({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey),
      ),
      child: child,
    );
  }
}
