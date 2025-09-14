import 'package:flutter/material.dart';

///Extension for double to create vertical and horizontal boxes
extension Double on double {
  SizedBox get verticalBox => SizedBox(height: this);
  SizedBox get horizontalBox => SizedBox(width: this);
}

///Extension for int to create vertical and horizontal boxes
extension Int on int {
  SizedBox get verticalBox => SizedBox(height: toDouble());
  SizedBox get horizontalBox => SizedBox(width: toDouble());
}
