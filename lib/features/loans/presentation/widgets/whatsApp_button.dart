import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class WhatsAppButton extends StatelessWidget {
  final String phoneNumber; // Numéro WhatsApp avec code pays (ex: +4915774851991)
  final String message; // Message par défaut

  const WhatsAppButton({
    super.key,
    required this.phoneNumber,
    this.message = "Bonjour, j'ai une question concernant votre service de prêt.",
  });

  void _launchWhatsApp() async {
    final url =
        "https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}";
    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("Impossible d'ouvrir WhatsApp");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      right: 20,
      child: FloatingActionButton(
        onPressed: _launchWhatsApp,
        backgroundColor: const Color(0xFF25D366),
        child: const Icon(Icons.chat, color: Colors.white, size: 28),
      ),
    );
  }
}

