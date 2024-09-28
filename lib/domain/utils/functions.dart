String formatNumber(double number) {
  if (number >= 1000000) {
    return (number / 1000000).toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '') + 'M';
  } else if (number >= 1000) {
    return (number / 1000).toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '') + 'K';
  } else {
    return number.toStringAsFixed(0);
  }
}
String cleanAndCapitalize(String input) {
  // Step 1: Remove all numbers
  String result = input.replaceAll(RegExp(r'[0-9]'), '');

  // Step 2: Replace '-' with a space
  result = result.replaceAll('-', ' ');

  // Step 3: Trim extra spaces from both sides
  result = result.trim();

  // Step 4: Capitalize the first letter
  if (result.isNotEmpty) {
    result = result[0].toUpperCase() + result.substring(1).toLowerCase();
  }

  return result;
}