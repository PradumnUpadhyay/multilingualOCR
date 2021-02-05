import 'package:flutter/material.dart';
import 'dart:io';

class MultiSelect extends StatefulWidget {

  final Key key;
  final String path;
  final ValueChanged<bool> isSelected;

  MultiSelect({this.isSelected,this.path,this.key});

  @override
  _MultiSelectState createState() => _MultiSelectState();
}

class _MultiSelectState extends State<MultiSelect> {

  bool isSelected=false;


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        isSelected=!isSelected;
        widget.isSelected(isSelected);
      },

      child: Stack(
        children: <Widget>[
          Image.file(File(widget.path), color: Colors.black.withOpacity(isSelected ? 0.9: 0.0), colorBlendMode:  BlendMode.color,),

          isSelected ?
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.blue,
                  ),
                ),
              ) :
          Container()
        ],
      ),
    );
  }
}
