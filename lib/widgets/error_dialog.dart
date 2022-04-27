 // ignore_for_file: use_key_in_widget_constructors

 import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  final String? message;
  ErrorDialog({this.message});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      content: Text(message!),
      actions: [
        ElevatedButton(
          onPressed: (){
            Navigator.pop(context);
          },
          child: const Center(
            child: Text(
              "OK",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          style: ElevatedButton.styleFrom(
            primary: Colors.red,
          ),
        ),
      ],
    );
  }
}
