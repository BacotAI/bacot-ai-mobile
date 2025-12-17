import 'package:flutter/material.dart';

class SpeechResultDialog extends StatelessWidget {
  final String result;

  const SpeechResultDialog({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Speech Result'),
      content: SingleChildScrollView(child: Text(result)),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}
