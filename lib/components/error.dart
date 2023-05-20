import 'package:flutter/material.dart';

class ErrorContainer extends StatelessWidget {
  final String errorText;
  const ErrorContainer({Key? key, required this.errorText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Image(
          image: AssetImage('assets/images/exclamation.png'),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                errorText,
                style: const TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ]),
      ],
    );
  }
}
