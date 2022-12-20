import 'package:flutter/material.dart';

class CustomDropDownButtonClass extends StatelessWidget {
  List<String> values;
  double width;

  CustomDropDownButtonClass({required this.values , required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      
      width: width,
      padding: EdgeInsets.symmetric(horizontal: width * 0.04),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(52, 52, 52, 1.0),
        borderRadius: BorderRadius.circular(10),
        ),
      child: DropdownButton(
        value: values.first,
        onChanged: (_){ },
        items: values.map((e) {
          return DropdownMenuItem(
            child: Text(e),
            value: e,
          );
        }).toList(),
        
        underline: Container(),
        dropdownColor: const Color.fromRGBO(
          52, 52, 52, 1.0),
          style: const TextStyle(
            color:  Colors.white),
      )
    );
  }
}