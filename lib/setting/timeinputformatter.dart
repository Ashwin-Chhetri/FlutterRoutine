import 'package:flutter/services.dart';
import 'package:minaroutine/setting/timehelper.dart';

class TimeInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    const int sampleSize = 8;
    final newTextLenght = newValue.text.length;
    var selectionIndex = newValue.selection.end;
    //Add all value to the output
    if (newTextLenght > 0) {
      //For delete operation
      if (newValue.text.length > oldValue.text.length) {
        //Drop extra characters
        if (newTextLenght > sampleSize) {
          return oldValue;
        }
        //Adding a ':' symbol
        if (newTextLenght == 2) {
          //print("Print value newTextLenght $newTextLenght  ");
          return TextEditingValue(
            text: '${newValue.text.substring(0, newTextLenght)}:',
            selection: TextSelection.collapsed(offset: selectionIndex + 1),
          );
        }
        //Adding a whitespace
        if (newTextLenght == 5) {
          return TextEditingValue(
            text: '${newValue.text.substring(0, newTextLenght)} ',
            selection: TextSelection.collapsed(offset: selectionIndex + 1),
          );
        }
        //Verify 12-Hr Format
        if (newTextLenght == sampleSize) {
          return TextEditingValue(
            text: DateTimeHelper.convert12Hour(newValue.text),
            selection: TextSelection.collapsed(offset: selectionIndex),
          );
        }
      }
    }
    return newValue;
  }
}
