// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:sellers_app_project/widgets/progress_bar.dart';

class LoadingDialog extends StatelessWidget {
  final String? message;
  const LoadingDialog({this.message});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgress(),
          const SizedBox(
            height: 10,
          ),
          Text(message! + "Please Wait..."),
        ],
      ),
    );
  }
}
