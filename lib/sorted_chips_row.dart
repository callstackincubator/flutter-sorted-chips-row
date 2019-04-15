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

/// Widget rendering Material Chip widgets in a horizontal, scrollable
/// container, animating the widgets' positions in container according to the
/// provided comparator function.
/// 
/// Example usage:
/// 
/// ```
/// import 'package:sorted_chips_row/sorted_chips_row.dart'
/// 
/// …
/// 
/// ChipSpec chip1 = ChipSpec(label: Text('Label One'), initiallyEnabled: true)
/// ChipSpec chip2 = ChipSpec(label: Text('Label Two'))
/// 
/// Comparator<ChipState> chipComparator = (chipState1, chipState2) => …
/// 
/// return SortedChipsRow(chips: [chip1, chip2], comparator: chipComparator);
/// ```
/// 
/// Note that the SortedChipsRow needs to have an ancestor providing
/// [Directionality](https://docs.flutter.io/flutter/widgets/Directionality-class.html).
library sorted_chips_row;

export './src/chip_spec.dart' show ChipSpec;
export './src/sorted_chips_row.dart' show ChipState, SortedChipsRow;
