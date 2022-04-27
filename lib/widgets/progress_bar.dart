// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';


CircularProgress()
{
  return Container(
    alignment: Alignment.center,
    padding: const EdgeInsets.only(top: 12),
    child: const CircularProgressIndicator(
      valueColor:  AlwaysStoppedAnimation(
        Colors.amber,
      ),
    ),
  );
}