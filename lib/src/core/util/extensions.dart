import 'package:flutter/material.dart';

extension CompareTimeOfDayTo on TimeOfDay {
  bool isAfter(TimeOfDay other) {
    return other is TimeOfDay &&
        (hour > other.hour || (hour == other.hour && minute > other.minute));
  }
}


extension CompareDateTimeTo on DateTime{
  bool isAtSameDayAs(DateTime other){
    return (other is DateTime && year == other.year && month == other.month && day == other.day);
  }
}
