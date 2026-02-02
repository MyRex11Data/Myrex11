import 'package:flutter/material.dart';

class DateFormat {
  static String getWeekDay(DateTime dateTime) => dateTime == null
      ? ""
      : <String>[
          "MONDAY",
          "TUESDAY",
          "WEDNESDAY",
          "THURSDAY",
          "FRIDAY",
          "SATURDAY",
          "SUNDAY"
        ][dateTime.weekday - 1];

  static String timeToString(TimeOfDay timeOfDay) {
    return timeOfDay == null
        ? "00:00"
        : "${timeOfDay.hour}:${timeOfDay.minute}";
  }

  static DateTime? getFormattedDateObj(String ymd) {
   return ("$ymd".isEmpty) || ("$ymd" == "yyyy-MM-dd HH:mm:ss")
        ? null
        : DateTime.parse("$ymd");
  }


  static DateTime? getDateFormat(String ymd) =>
      ("$ymd".isEmpty) || ("$ymd" == "yyyy-MM-dd HH:mm:ss")
          ? null
          : DateTime.parse("$ymd");

  static String getNotificationDateFormat(DateTime dateTime) =>"${getDayName(dateTime.weekday)}, ${dateTime.day > 9 ? dateTime.day : "0${dateTime.day}"} ${getMonthName(dateTime.month)}";

  static String getFormattedDmyString(DateTime dateTime) =>
      dateTime == null ? "" : getDisplayDate(dateTime, isYMD: false);


  static String getDisplayDate(DateTime dateTime, {bool isYMD = true}) => isYMD
      ? "${dateTime.year}-${dateTime.month > 9 ? dateTime.month : "0${dateTime.month}"}-${dateTime.day > 9 ? dateTime.day : "0${dateTime.day}"}"
      : "${dateTime.day > 9 ? dateTime.day : "0${dateTime.day}"}-${dateTime.month > 9 ? dateTime.month : "0${dateTime.month}"}-${dateTime.year}";

  static String getFormattedDmyHSString(DateTime dateTime,
      {bool isYMD = false}) =>
      dateTime == null ? "" : getDisplayDate(dateTime, isYMD: isYMD) + " " +
          timeToString(TimeOfDay(hour: dateTime.hour, minute: dateTime.minute));

   static String getMonthName(int month){
     String monthName='';
     switch (month) {
       case 1:
         monthName = "January";
         break;
       case 2:
         monthName = "February";
         break;
       case 3:
         monthName = "March";
         break;
       case 4:
         monthName = "April";
         break;
       case 5:
         monthName = "May";
         break;
       case 6:
         monthName = "June";
         break;
       case 7:
         monthName = "July";
         break;
       case 8:
         monthName = "August";
         break;
       case 9:
         monthName = "September";
         break;
       case 10:
         monthName = "October";
         break;
       case 11:
         monthName = "November";
         break;
       case 12:
         monthName = "December";
         break;
     }
     return monthName;
   }
   static String getDayName(int month){
     String dayName='';
     switch (month) {
       case 1:
         dayName = "Monday";
         break;
       case 2:
         dayName = "Tuesday";
         break;
       case 3:
         dayName = "Wednesday";
         break;
       case 4:
         dayName = "Thursday";
         break;
       case 5:
         dayName = "Friday";
         break;
       case 6:
         dayName = "Saturday";
         break;
       case 7:
         dayName = "Sunday";

     }
     return dayName;
   }

}