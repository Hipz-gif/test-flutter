import 'package:flutter/material.dart';

class Responsive {
  // Returns the width of the screen
  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  // Returns the height of the screen
  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  // Returns the size of a block based on width
  static double blockSizeWidth(BuildContext context, {double dividedBy = 1}) {
    return screenWidth(context) / dividedBy;
  }

  // Returns the size of a block based on height
  static double blockSizeHeight(BuildContext context, {double dividedBy = 1}) {
    return screenHeight(context) / dividedBy;
  }

  // Returns the scale factor of text compared to the default text size of the device
  static double textScaleFactor(BuildContext context) {
    return MediaQuery.of(context).textScaleFactor;
  }

  // Checks if the device is in portrait mode
  static bool isPortrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

  // Checks if the device is in landscape mode
  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }
}
