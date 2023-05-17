import 'package:flutter/material.dart';

String parseDate(String dateString) {
  var months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
  DateTime date = DateTime.parse(dateString);
  return ("${date.day} ${months[date.month]}" );
}

  // String formattedTime(String timeString) {
 
  //       DateTime parsedTime = DateTime.parse(timeString);

  //   return "${(parsedTime.hour >= 12) ? (parsedTime.hour - 12) : (parsedTime.hour)}:${parsedTime.minute} ${(parsedTime.hour >= 12) ? "PM" : "AM"}";
  // }

