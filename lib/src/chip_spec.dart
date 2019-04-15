//  Copyright 2019 Callstack.io sp zo.o.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

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
