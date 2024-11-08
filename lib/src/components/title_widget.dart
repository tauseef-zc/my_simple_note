import 'package:flutter/material.dart';

class TitleWidget extends StatelessWidget {
  const TitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      TextTheme textTheme = Theme.of(context).textTheme;
      return Wrap(
        children: [
          Text(
            "My Simple ",
            style: textTheme.headlineLarge,
          ),
          Text(
            "Notes",
            style: textTheme.headlineLarge,
          )
        ],
      );
    });
  }
}
