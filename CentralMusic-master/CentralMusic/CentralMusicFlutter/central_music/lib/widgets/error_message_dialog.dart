import 'package:flutter/material.dart';

class ErrorMessageDialog extends StatelessWidget {
  final String title;
  final String text;

  const ErrorMessageDialog({Key key, this.title, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(text),
      actions: [
        FlatButton(
          child: Text("OK"),
          onPressed: () => Navigator.pop(context),
        )
      ],
    );
  }
}
