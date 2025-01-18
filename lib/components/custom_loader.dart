import 'package:flutter/material.dart';

import '../utils/dimensions.dart';

class CustomLoader extends StatelessWidget {
  const CustomLoader({
    super.key,
    required this.task,
  });

  final String task;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(
            Dimensions.radiusSmall,
          ),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(task),
            ),
          ],
        ),
      ),
    );
  }
}
