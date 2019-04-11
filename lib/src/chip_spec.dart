import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class ChipSpec {
  final Key key;
  final String label;

  final TextStyle labelStyle;
  final Widget avatar;
  final Color enabledColor;
  final Color disabledColor;
  final Clip clipBehaviour;
  final double elevation;

  ChipSpec(
      {this.key,
      @required this.label,
      this.labelStyle,
      this.avatar,
      this.enabledColor,
      this.disabledColor,
      this.clipBehaviour,
      this.elevation});
}
