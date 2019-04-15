import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Defines attributes of a rendered [Chip] widget.
class ChipSpec {
  /// [Key] to pass to the underlying [Chip] widget.
  final Key key;

  /// Label widget passed to the [Chip] widget. This is usually an instance of
  /// [Text].
  final Widget label;

  /// Whether the widget should be initially enabled.
  final bool initiallyEnabled;

  /// Style to use for the [label] widget. Only makes sense if the label 
  /// respects the [DefaultTextStyle].
  final TextStyle labelStyle;

  /// The widget used as the chips avatar. If not specified, a default one
  /// showing the 'tick' icon will be used.
  final Widget avatar;

  /// Background color to use if the widget is the enabled state.
  final Color enabledColor;

  /// Background color to use if the widget is the disabled state.
  final Color disabledColor;

  /// Clip behaviour to pass to the [Chip] widget. Defaults to [Clip.none].
  final Clip clipBehaviour;

  /// Elevation to pass to the [Chip] widget.
  final double elevation;

  ChipSpec(
      {this.key,
      @required this.label,
      this.initiallyEnabled = false,
      this.labelStyle,
      this.avatar,
      this.enabledColor,
      this.disabledColor,
      this.clipBehaviour = Clip.none,
      this.elevation});
}
