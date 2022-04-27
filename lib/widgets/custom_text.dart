import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomTextField extends StatelessWidget {

  final TextEditingController? controller;
  final IconData? data;
  final String ? hintText;
  bool? isObscure=true;
  bool? enabled=true;

  CustomTextField({
    this.controller,
    this.data,
    this.hintText,
    this.enabled,
    this.isObscure,
});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white54,
        borderRadius: BorderRadius.all(Radius.circular(10))
      ),
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(left: 20,right: 20,top: 10,bottom: 10),
      child: TextFormField(
        enabled: enabled,
        controller: controller,
        obscureText: isObscure!,
        cursorColor: Theme.of(context).primaryColor,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(data,
          color: Colors.redAccent,),
            focusColor: Theme.of(context).primaryColorDark,
          hintText: hintText,
        ),
      ),
    );
  }
}
