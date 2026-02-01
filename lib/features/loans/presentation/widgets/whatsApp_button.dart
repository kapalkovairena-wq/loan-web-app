import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../l10n/app_localizations.dart';

class WhatsAppButton extends StatelessWidget {
  final String phoneNumber;

  const WhatsAppButton({
    super.key,
    required this.phoneNumber,
  });

  void _launchWhatsApp(BuildContext context) async {
    final message = AppLocalizations.of(context)!.whatsappDefaultMessage;
    final url = "https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}";
    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.whatsappError)),
      );
      debugPrint("Impossible d'ouvrir WhatsApp");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      right: 20,
      child: FloatingActionButton(
        onPressed: () => _launchWhatsApp(context),
        backgroundColor: const Color(0xFF25D366),
        child: const Icon(Icons.chat, color: Colors.white, size: 28),
      ),
    );
  }
}
