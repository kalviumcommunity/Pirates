import 'package:url_launcher/url_launcher.dart';

class SmsLauncher {
  static Future<bool> openSmsComposer({
    required String phoneNumber,
    required String message,
  }) async {
    final encoded = Uri.encodeComponent(message);
    final uri = Uri.parse('sms:$phoneNumber?body=$encoded');

    if (!await canLaunchUrl(uri)) {
      return false;
    }

    return launchUrl(uri);
  }

  static Future<void> openMultiSmsComposer({
    required List<String> phoneNumbers,
    required String message,
  }) async {
    // Not consistently supported across platforms; we fall back to first.
    if (phoneNumbers.isEmpty) return;
    await openSmsComposer(phoneNumber: phoneNumbers.first, message: message);
  }

  static String buildSosMessage({
    required String userName,
    required String mapsUrl,
    required DateTime timeUtc,
  }) {
    // Keep it short to fit SMS.
    return 'RunSOS ALERT\n$userName needs help now.\nLocation: $mapsUrl\nTime (UTC): ${timeUtc.toIso8601String()}';
  }
}
