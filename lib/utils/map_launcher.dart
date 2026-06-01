import 'package:url_launcher/url_launcher.dart';

class MapLauncher {
  static Future<void> openDirections(double lat, double lng) async {
    final url = Uri.parse(
      "https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&travelmode=driving",
    );

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception("Could not open Google Maps.");
    }
  }
}
