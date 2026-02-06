import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';

import '../widgets/app_header.dart';
import '../widgets/app_drawer.dart';
import '../widgets/whatsApp_button.dart';
import '../widgets/hero_banner.dart';
import '../widgets/footer_section.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage>
    with TickerProviderStateMixin {
  late AnimationController _formController;
  late AnimationController _infoController;
  late Animation<Offset> _formSlide;
  late Animation<Offset> _infoSlide;
  late Animation<double> _formOpacity;
  late Animation<double> _infoOpacity;

  @override
  void initState() {
    super.initState();

    _formController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _infoController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 800));

    _formSlide = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _formController, curve: Curves.easeOutCubic));

    _infoSlide = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _infoController, curve: Curves.easeOutCubic));

    _formOpacity =
        Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _formController, curve: Curves.easeIn));
    _infoOpacity =
        Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _infoController, curve: Curves.easeIn));

    _formController.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 200), () {
        _infoController.forward();
      });
    });
  }

  @override
  void dispose() {
    _formController.dispose();
    _infoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final isMobile = MediaQuery.of(context).size.width < 900;

    return Scaffold(
      drawer: const AppDrawer(),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              color: const Color(0xFFF8F8F8),
              child: Column(
                children: [
                  const AppHeader(),
                  const HeroBanner(),
                  const SizedBox(height: 80),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: LayoutBuilder(
                      builder: (_, __) {
                        if (isMobile) {
                          return Column(
                            children: [
                              SlideTransition(
                                position: _formSlide,
                                child: FadeTransition(
                                  opacity: _formOpacity,
                                  child: _contactForm(context),
                                ),
                              ),
                              const SizedBox(height: 40),
                              SlideTransition(
                                position: _infoSlide,
                                child: FadeTransition(
                                  opacity: _infoOpacity,
                                  child: _contactInfo(context),
                                ),
                              ),
                            ],
                          );
                        }

                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 6,
                              child: SlideTransition(
                                position: _formSlide,
                                child: FadeTransition(
                                  opacity: _formOpacity,
                                  child: _contactForm(context),
                                ),
                              ),
                            ),
                            const SizedBox(width: 60),
                            Expanded(
                              flex: 5,
                              child: SlideTransition(
                                position: _infoSlide,
                                child: FadeTransition(
                                  opacity: _infoOpacity,
                                  child: _contactInfo(context),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 80),
                  const FooterSection(),
                ],
              ),
            ),
          ),
          const WhatsAppButton(phoneNumber: "+41798079255"),
        ],
      ),
    );
  }

  Widget _contactForm(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 30, offset: Offset(0, 10)),
        ],
      ),
      child: Column(
        children: [
          _formField(label: t.contactFormName, hint: t.contactFormNameHint),
          _formField(
            label: t.contactFormEmail,
            hint: t.contactFormEmailHint,
            keyboardType: TextInputType.emailAddress,
          ),
          _formField(label: t.contactFormSubject, hint: t.contactFormSubjectHint),
          _formField(
            label: t.contactFormMessage,
            hint: t.contactFormMessageHint,
            maxLines: 5,
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF6B400),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(t.contactFormSubmit, style: const TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _formField({
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: Color(0xFF333333)),
          ),
          const SizedBox(height: 8),
          TextFormField(
            keyboardType: keyboardType,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hint,
              contentPadding: const EdgeInsets.all(14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _contactInfo(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(t.contactSectionLabel, style: const TextStyle(color: Color(0xFFF6B400))),
        const SizedBox(height: 20),
        Text(t.contactTitle,
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        Text(t.contactDescription),
        const SizedBox(height: 30),
        _infoItem("🏢", t.contactAddressTitle, t.contactAddress),
        _infoItem("📞", t.contactPhoneTitle, t.contactPhone),
        _infoItem("✉️", t.contactEmailTitle, t.contactEmail),
      ],
    );
  }

  Widget _infoItem(String icon, String title, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFFF6B400),
              borderRadius: BorderRadius.circular(6),
            ),
            alignment: Alignment.center,
            child: Text(icon),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(text),
            ]),
          ),
        ],
      ),
    );
  }
}
