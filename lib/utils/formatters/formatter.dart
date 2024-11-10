import 'package:intl/intl.dart';

class RFormatter {
  static String formatDate(DateTime? date) {
    date ??= DateTime.now();
    return DateFormat('dd-mmm-yyyy').format(date);
  }

  static String formatCurrency(double amount) {
    return NumberFormat.currency(locale: 'en_US', symbol: '\$').format(amount);
  }

  static String formatPhoneNumber(String phoneNumber) {
    if(phoneNumber.length == 10){
      return '(${phoneNumber.substring(0,3)}) ${phoneNumber.substring(3, 6)} ${phoneNumber.substring(6)}';
    }else if (phoneNumber.length == 11) {
      return '(${phoneNumber.substring(0, 4)}) ${phoneNumber.substring(4, 7)} ${phoneNumber.substring(7)}';
    }

    return phoneNumber;
  }

  static String internationalFormatPhoneNumber(String phoneNumber) {
    // Remove all non-digit characters
    var digitsOnly = phoneNumber.replaceAll(RegExp(r'\D'), '');

    // Extract country code
    String countryCode = '+${digitsOnly.substring(0, 2)}';
    digitsOnly = digitsOnly.substring(2);

    // Initialize a buffer to build the formatted number
    final formattedNumber = StringBuffer();
    formattedNumber.write('($countryCode) ');

    int i = 0;
    while (i < digitsOnly.length) {
      int groupLength = 2;

      // For US numbers, group the first 3 digits together
      if (i == 0 && countryCode == '+1') {
        groupLength = 3;
      }

      // Add the next group of digits to the formatted number
      int end = i + groupLength;
      formattedNumber.write(digitsOnly.substring(i, end));

      // Add a space between groups
      if (end < digitsOnly.length) {
        formattedNumber.write(' ');
      }

      i = end;
    }

    // Return the formatted number as a string
    return formattedNumber.toString();
  }

}