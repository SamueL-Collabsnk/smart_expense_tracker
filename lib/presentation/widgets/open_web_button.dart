import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform, Process, ProcessStartMode;
import 'package:flutter/foundation.dart' show kIsWeb;

import '../screens/webview/webview_screen.dart';

/// Button that tries to open an in-app WebView, falling back to the system browser.
class OpenWebButton extends StatelessWidget {
  final String url;
  final String label;

  const OpenWebButton({Key? key, required this.url, this.label = 'Open'})
      : super(key: key);

  Future<void> _openExternal(BuildContext context) async {
    final uri = Uri.parse(url);
    final messenger = ScaffoldMessenger.of(context);
    // On Linux prefer launching Firefox directly if available (so the user
    // sees a full-featured browser). Fall back to the system default.
    if (!kIsWeb && Platform.isLinux) {
      try {
        final which = await Process.run('which', ['firefox']);
        if (which.exitCode == 0) {
          // Start Firefox detached so the app doesn't block.
          await Process.start('firefox', [url],
              mode: ProcessStartMode.detached);
          return;
        }
      } catch (_) {
        // ignore and fallback
      }
    }

    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Could not open external browser')),
      );
    }
  }

  void _openInApp(BuildContext context) {
    try {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => WebViewScreen(url: url)),
      );
    } catch (e) {
      // If the webview fails (missing native engine), fallback to external browser
      _openExternal(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.open_in_browser),
      label: Text(label),
      onPressed: () => _openInApp(context),
    );
  }
}
