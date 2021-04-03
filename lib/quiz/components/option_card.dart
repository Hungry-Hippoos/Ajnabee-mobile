import 'package:flutter/material.dart';

class OptionCard extends StatelessWidget {

  final String optionText;
  final Function selectedOptionCallback;
  final int radioButtonValue;
  final int groupValue;

  const OptionCard({this.optionText, this.selectedOptionCallback, this.radioButtonValue, this.groupValue});


  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        optionText,
      ),
      trailing: Radio(value: radioButtonValue, groupValue: groupValue, onChanged: selectedOptionCallback),
    );
  }
}
