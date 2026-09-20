/// Utility class to clean and normalize phone numbers to international formats
class PhoneNumberUtility {
  /// Clean a phone number by stripping spaces, dashes, parentheses, and non-digits (except leading '+').
  static String clean(String phoneNumber) {
    return phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
  }

  /// Normalize a phone number to E.164 format.
  /// [defaultCountryCode] is the international prefix to use if the number is local (defaults to Finland '+358' as seen in the screenshots).
  static String normalize(
    String phoneNumber, {
    String defaultCountryCode = '+358',
  }) {
    String cleaned = clean(phoneNumber);
    if (cleaned.isEmpty) return '';

    // Already international format
    if (cleaned.startsWith('+')) {
      return cleaned;
    }

    // Convert double zero prefix (e.g., '00358...') to '+'
    if (cleaned.startsWith('00')) {
      return '+${cleaned.substring(2)}';
    }

    // Typical European local format: strip leading '0' and prepend the country code.
    // e.g., '0442096093' -> '+358442096093'
    if (cleaned.startsWith('0') && cleaned.length > 1) {
      return defaultCountryCode + cleaned.substring(1);
    }

    // Default fallback: prepend country code
    return defaultCountryCode + cleaned;
  }

  /// Format phone number for a polished, readable UI display (e.g., +358 44 209 6093)
  static String formatForDisplay(String phoneNumber) {
    String cleaned = clean(phoneNumber);
    if (cleaned.startsWith('+') && cleaned.length >= 11) {
      try {
        // e.g. +358442096093 -> +358 44 209 6093
        // or +16505551234 -> +1 650 555 1234
        if (cleaned.startsWith('+358')) {
          String prefix = cleaned.substring(0, 4); // +358
          String area = cleaned.substring(4, 6); // 44
          String part1 = cleaned.substring(6, 9); // 209
          String part2 = cleaned.substring(9); // 6093
          return '$prefix $area $part1 $part2';
        } else if (cleaned.startsWith('+1')) {
          String prefix = cleaned.substring(0, 2); // +1
          String area = cleaned.substring(2, 5); // 650
          String part1 = cleaned.substring(5, 8); // 555
          String part2 = cleaned.substring(8); // 1234
          return '$prefix $area $part1 $part2';
        }
      } catch (_) {
        // Fallback if parsing fails
      }
    }
    return phoneNumber;
  }
}
