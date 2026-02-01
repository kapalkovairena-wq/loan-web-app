import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bg.dart';
import 'app_localizations_cs.dart';
import 'app_localizations_da.dart';
import 'app_localizations_de.dart';
import 'app_localizations_el.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_et.dart';
import 'app_localizations_fi.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_ga.dart';
import 'app_localizations_hr.dart';
import 'app_localizations_hu.dart';
import 'app_localizations_it.dart';
import 'app_localizations_lt.dart';
import 'app_localizations_lv.dart';
import 'app_localizations_mt.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ro.dart';
import 'app_localizations_sk.dart';
import 'app_localizations_sl.dart';
import 'app_localizations_sv.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('bg'),
    Locale('cs'),
    Locale('da'),
    Locale('de'),
    Locale('el'),
    Locale('en'),
    Locale('es'),
    Locale('et'),
    Locale('fi'),
    Locale('fr'),
    Locale('ga'),
    Locale('hr'),
    Locale('hu'),
    Locale('it'),
    Locale('lt'),
    Locale('lv'),
    Locale('mt'),
    Locale('nl'),
    Locale('pl'),
    Locale('pt'),
    Locale('ro'),
    Locale('sk'),
    Locale('sl'),
    Locale('sv'),
  ];

  /// No description provided for @drawerHome.
  ///
  /// In fr, this message translates to:
  /// **'Page d\'accueil'**
  String get drawerHome;

  /// No description provided for @drawerDashboard.
  ///
  /// In fr, this message translates to:
  /// **'Mon tableau de bord'**
  String get drawerDashboard;

  /// No description provided for @drawerAdminDashboard.
  ///
  /// In fr, this message translates to:
  /// **'Tableau de bord administrateur'**
  String get drawerAdminDashboard;

  /// No description provided for @drawerLoanRequest.
  ///
  /// In fr, this message translates to:
  /// **'Demander un prêt'**
  String get drawerLoanRequest;

  /// No description provided for @drawerOffers.
  ///
  /// In fr, this message translates to:
  /// **'Découvrir nos offres'**
  String get drawerOffers;

  /// No description provided for @drawerInvestment.
  ///
  /// In fr, this message translates to:
  /// **'Investissement'**
  String get drawerInvestment;

  /// No description provided for @drawerContact.
  ///
  /// In fr, this message translates to:
  /// **'Contact'**
  String get drawerContact;

  /// No description provided for @drawerAbout.
  ///
  /// In fr, this message translates to:
  /// **'À propos de nous'**
  String get drawerAbout;

  /// No description provided for @drawerLogout.
  ///
  /// In fr, this message translates to:
  /// **'Se déconnecter'**
  String get drawerLogout;

  /// No description provided for @heroTitle.
  ///
  /// In fr, this message translates to:
  /// **'Des services de prêts\npour développer votre entreprise'**
  String get heroTitle;

  /// No description provided for @heroSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Une solution moderne, simple et sécurisée pour gérer vos prêts et investissements.'**
  String get heroSubtitle;

  /// No description provided for @heroLogin.
  ///
  /// In fr, this message translates to:
  /// **'Se connecter'**
  String get heroLogin;

  /// No description provided for @heroRegister.
  ///
  /// In fr, this message translates to:
  /// **'S\'inscrire'**
  String get heroRegister;

  /// No description provided for @heroAdminAccess.
  ///
  /// In fr, this message translates to:
  /// **'Accéder à l’espace administrateur'**
  String get heroAdminAccess;

  /// No description provided for @heroUserAccess.
  ///
  /// In fr, this message translates to:
  /// **'Accéder à mon espace'**
  String get heroUserAccess;

  /// No description provided for @bankDetailsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Vos coordonnées bancaires'**
  String get bankDetailsTitle;

  /// No description provided for @bankDetailsEmptyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Aucune information bancaire enregistrée'**
  String get bankDetailsEmptyTitle;

  /// No description provided for @bankDetailsEmptyDescription.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez renseigner vos coordonnées pour recevoir les fonds.'**
  String get bankDetailsEmptyDescription;

  /// No description provided for @bankReceiver.
  ///
  /// In fr, this message translates to:
  /// **'Bénéficiaire'**
  String get bankReceiver;

  /// No description provided for @bankIban.
  ///
  /// In fr, this message translates to:
  /// **'IBAN'**
  String get bankIban;

  /// No description provided for @bankBic.
  ///
  /// In fr, this message translates to:
  /// **'BIC'**
  String get bankBic;

  /// No description provided for @bankName.
  ///
  /// In fr, this message translates to:
  /// **'Nom de la banque'**
  String get bankName;

  /// No description provided for @bankAddress.
  ///
  /// In fr, this message translates to:
  /// **'Adresse de la banque'**
  String get bankAddress;

  /// No description provided for @creditSectionLabel.
  ///
  /// In fr, this message translates to:
  /// **'Nos dossiers'**
  String get creditSectionLabel;

  /// No description provided for @creditSectionTitle.
  ///
  /// In fr, this message translates to:
  /// **'Nos services de crédit'**
  String get creditSectionTitle;

  /// No description provided for @creditSectionDescription.
  ///
  /// In fr, this message translates to:
  /// **'Nous proposons des solutions de financement flexibles et accessibles, adaptées à vos besoins personnels ou professionnels.'**
  String get creditSectionDescription;

  /// No description provided for @creditPersonalTitle.
  ///
  /// In fr, this message translates to:
  /// **'Prêt personnel'**
  String get creditPersonalTitle;

  /// No description provided for @creditPersonalDescription.
  ///
  /// In fr, this message translates to:
  /// **'Financez vos projets (voyages, équipements, mariages...) à un prix compétitif et avec une réponse rapide.'**
  String get creditPersonalDescription;

  /// No description provided for @creditBusinessTitle.
  ///
  /// In fr, this message translates to:
  /// **'Prêt professionnel'**
  String get creditBusinessTitle;

  /// No description provided for @creditBusinessDescription.
  ///
  /// In fr, this message translates to:
  /// **'Une solution simple et rapide pour soutenir votre entreprise : approvisionnement, trésorerie, développement.'**
  String get creditBusinessDescription;

  /// No description provided for @creditFlexibleTitle.
  ///
  /// In fr, this message translates to:
  /// **'Lignes de crédit flexibles'**
  String get creditFlexibleTitle;

  /// No description provided for @creditFlexibleDescription.
  ///
  /// In fr, this message translates to:
  /// **'Accès rapide à des fonds immédiatement disponibles, sans obligation d’utilisation immédiate.'**
  String get creditFlexibleDescription;

  /// No description provided for @creditSimulationTitle.
  ///
  /// In fr, this message translates to:
  /// **'Simulation et enquête'**
  String get creditSimulationTitle;

  /// No description provided for @creditSimulationDescription.
  ///
  /// In fr, this message translates to:
  /// **'Estimez votre capacité de crédit et soumettez votre demande directement en ligne.'**
  String get creditSimulationDescription;

  /// No description provided for @documentUploadTitle.
  ///
  /// In fr, this message translates to:
  /// **'Soumettre un document'**
  String get documentUploadTitle;

  /// No description provided for @documentChooseFile.
  ///
  /// In fr, this message translates to:
  /// **'Choisir un fichier ou une photo'**
  String get documentChooseFile;

  /// No description provided for @documentSubmit.
  ///
  /// In fr, this message translates to:
  /// **'Soumettre le document'**
  String get documentSubmit;

  /// No description provided for @documentUploadSuccess.
  ///
  /// In fr, this message translates to:
  /// **'✅ Document soumis avec succès'**
  String get documentUploadSuccess;

  /// No description provided for @documentUploadError.
  ///
  /// In fr, this message translates to:
  /// **'❌ Erreur lors de l’envoi du document :'**
  String get documentUploadError;

  /// No description provided for @newsletterTitle.
  ///
  /// In fr, this message translates to:
  /// **'Abonnez-vous à notre newsletter'**
  String get newsletterTitle;

  /// No description provided for @newsletterDescription.
  ///
  /// In fr, this message translates to:
  /// **'Restez informé(e) des fonctionnalités et technologies de nos produits en constante évolution.'**
  String get newsletterDescription;

  /// No description provided for @newsletterDescriptionShort.
  ///
  /// In fr, this message translates to:
  /// **'Restez informé(e) des nouveautés et évolutions.'**
  String get newsletterDescriptionShort;

  /// No description provided for @newsletterEmailHint.
  ///
  /// In fr, this message translates to:
  /// **'Votre adresse e-mail'**
  String get newsletterEmailHint;

  /// No description provided for @newsletterSubscribe.
  ///
  /// In fr, this message translates to:
  /// **'S’abonner'**
  String get newsletterSubscribe;

  /// No description provided for @footerServices.
  ///
  /// In fr, this message translates to:
  /// **'Services'**
  String get footerServices;

  /// No description provided for @footerInformation.
  ///
  /// In fr, this message translates to:
  /// **'Information'**
  String get footerInformation;

  /// No description provided for @footerHome.
  ///
  /// In fr, this message translates to:
  /// **'Page d’accueil'**
  String get footerHome;

  /// No description provided for @footerOffers.
  ///
  /// In fr, this message translates to:
  /// **'Découvrir nos offres'**
  String get footerOffers;

  /// No description provided for @footerInvestment.
  ///
  /// In fr, this message translates to:
  /// **'Investissement'**
  String get footerInvestment;

  /// No description provided for @footerContact.
  ///
  /// In fr, this message translates to:
  /// **'Contact'**
  String get footerContact;

  /// No description provided for @footerAbout.
  ///
  /// In fr, this message translates to:
  /// **'À propos de nous'**
  String get footerAbout;

  /// No description provided for @footerPrivacy.
  ///
  /// In fr, this message translates to:
  /// **'Protection des données'**
  String get footerPrivacy;

  /// No description provided for @footerSecurity.
  ///
  /// In fr, this message translates to:
  /// **'Sécurité'**
  String get footerSecurity;

  /// No description provided for @footerTerms.
  ///
  /// In fr, this message translates to:
  /// **'CGV'**
  String get footerTerms;

  /// No description provided for @footerBrandDescription.
  ///
  /// In fr, this message translates to:
  /// **'Nous redonnons aux gens le contrôle de leur argent grâce à des solutions de financement modernes.'**
  String get footerBrandDescription;

  /// No description provided for @footerSimulationButton.
  ///
  /// In fr, this message translates to:
  /// **'Voir une simulation'**
  String get footerSimulationButton;

  /// No description provided for @footerAddress.
  ///
  /// In fr, this message translates to:
  /// **'Audenstraße 2 – 4, 61348 Bad Homburg'**
  String get footerAddress;

  /// No description provided for @footerOpeningHours.
  ///
  /// In fr, this message translates to:
  /// **'Lun - Sam : 9h00 - 17h00'**
  String get footerOpeningHours;

  /// No description provided for @footerCopyright.
  ///
  /// In fr, this message translates to:
  /// **'© Copyright 2026 KreditSch. Tous droits réservés.'**
  String get footerCopyright;

  /// No description provided for @loanVisionTitle.
  ///
  /// In fr, this message translates to:
  /// **'Notre vision et notre mission'**
  String get loanVisionTitle;

  /// No description provided for @loanVisionContent.
  ///
  /// In fr, this message translates to:
  /// **'Chez KreditSch, nous simplifions l’accès au crédit en proposant des solutions de prêts rapides, transparentes et adaptées à chaque profil, afin de redonner à chacun le contrôle de ses projets financiers.'**
  String get loanVisionContent;

  /// No description provided for @loanSolutionsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Solutions de prêts intelligentes'**
  String get loanSolutionsTitle;

  /// No description provided for @loanSolutionsContent.
  ///
  /// In fr, this message translates to:
  /// **'KreditSch est reconnue pour ses offres de prêts personnels, professionnels et d’urgence, alliant rapidité, sécurité et conditions flexibles pour accompagner chaque étape de votre vie.'**
  String get loanSolutionsContent;

  /// No description provided for @loanStatApproved.
  ///
  /// In fr, this message translates to:
  /// **'Demandes de prêts approuvées'**
  String get loanStatApproved;

  /// No description provided for @loanStatTypes.
  ///
  /// In fr, this message translates to:
  /// **'Types de prêts disponibles'**
  String get loanStatTypes;

  /// No description provided for @loanStatExperience.
  ///
  /// In fr, this message translates to:
  /// **'Années d’expertise financière'**
  String get loanStatExperience;

  /// No description provided for @loanStatExperts.
  ///
  /// In fr, this message translates to:
  /// **'Experts crédit dédiés'**
  String get loanStatExperts;

  /// No description provided for @loanFeaturePersonalTitle.
  ///
  /// In fr, this message translates to:
  /// **'Financez vos projets personnels simplement'**
  String get loanFeaturePersonalTitle;

  /// No description provided for @loanFeaturePersonalDescription.
  ///
  /// In fr, this message translates to:
  /// **'Obtenez un prêt privé flexible pour vos besoins personnels avec des intérêts transparents et un remboursement adapté.'**
  String get loanFeaturePersonalDescription;

  /// No description provided for @loanFeatureBusinessTitle.
  ///
  /// In fr, this message translates to:
  /// **'Soutenez les entrepreneurs et PME'**
  String get loanFeatureBusinessTitle;

  /// No description provided for @loanFeatureBusinessDescription.
  ///
  /// In fr, this message translates to:
  /// **'Investissez ou empruntez pour développer une activité grâce à notre réseau de prêteurs privés vérifiés.'**
  String get loanFeatureBusinessDescription;

  /// No description provided for @loanFeatureFastTitle.
  ///
  /// In fr, this message translates to:
  /// **'Prêt rapide, sans procédure bancaire lourde'**
  String get loanFeatureFastTitle;

  /// No description provided for @loanFeatureFastDescription.
  ///
  /// In fr, this message translates to:
  /// **'Validation rapide, pénalités claires et conditions définies à l’avance entre prêteur et emprunteur.'**
  String get loanFeatureFastDescription;

  /// No description provided for @loanFeatureCta.
  ///
  /// In fr, this message translates to:
  /// **'Demander un prêt >'**
  String get loanFeatureCta;

  /// No description provided for @loanIdeasHeroQuote.
  ///
  /// In fr, this message translates to:
  /// **'« Un bon prêt ne complique pas votre avenir, il vous aide à le construire sereinement. »'**
  String get loanIdeasHeroQuote;

  /// No description provided for @loanIdeasHeroSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Solutions de prêts privés — simples, claires et adaptées à vos besoins personnels et professionnels.'**
  String get loanIdeasHeroSubtitle;

  /// No description provided for @loanIdeasTitle.
  ///
  /// In fr, this message translates to:
  /// **'Nos solutions de prêts privés'**
  String get loanIdeasTitle;

  /// No description provided for @loanIdeasDescription.
  ///
  /// In fr, this message translates to:
  /// **'Nous proposons des solutions de prêts flexibles et transparentes, adaptées aux besoins des particuliers et des professionnels.'**
  String get loanIdeasDescription;

  /// No description provided for @loanIdeasBulletPersonal.
  ///
  /// In fr, this message translates to:
  /// **'Prêt personnel à court terme'**
  String get loanIdeasBulletPersonal;

  /// No description provided for @loanIdeasBulletBusiness.
  ///
  /// In fr, this message translates to:
  /// **'Prêt pour activités commerciales'**
  String get loanIdeasBulletBusiness;

  /// No description provided for @loanIdeasBulletEmergency.
  ///
  /// In fr, this message translates to:
  /// **'Prêt d’urgence'**
  String get loanIdeasBulletEmergency;

  /// No description provided for @loanIdeasBulletInvestment.
  ///
  /// In fr, this message translates to:
  /// **'Prêt d’investissement'**
  String get loanIdeasBulletInvestment;

  /// No description provided for @loanIdeasBulletInstallment.
  ///
  /// In fr, this message translates to:
  /// **'Prêt avec remboursement échelonné'**
  String get loanIdeasBulletInstallment;

  /// No description provided for @loanIdeasCta.
  ///
  /// In fr, this message translates to:
  /// **'Découvrir nos offres'**
  String get loanIdeasCta;

  /// No description provided for @loanIdeasWhyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Pourquoi choisir notre service ?'**
  String get loanIdeasWhyTitle;

  /// No description provided for @loanIdeasWhyFastTitle.
  ///
  /// In fr, this message translates to:
  /// **'Processus rapide'**
  String get loanIdeasWhyFastTitle;

  /// No description provided for @loanIdeasWhyFastDesc.
  ///
  /// In fr, this message translates to:
  /// **'Décision de prêt rapide et sans procédures complexes.'**
  String get loanIdeasWhyFastDesc;

  /// No description provided for @loanIdeasWhyClearTitle.
  ///
  /// In fr, this message translates to:
  /// **'Conditions claires'**
  String get loanIdeasWhyClearTitle;

  /// No description provided for @loanIdeasWhyClearDesc.
  ///
  /// In fr, this message translates to:
  /// **'Taux d’intérêt et pénalités définis à l’avance.'**
  String get loanIdeasWhyClearDesc;

  /// No description provided for @loanIdeasWhyTrackingTitle.
  ///
  /// In fr, this message translates to:
  /// **'Suivi transparent'**
  String get loanIdeasWhyTrackingTitle;

  /// No description provided for @loanIdeasWhyTrackingDesc.
  ///
  /// In fr, this message translates to:
  /// **'Visualisez vos échéances et paiements à tout moment.'**
  String get loanIdeasWhyTrackingDesc;

  /// No description provided for @loanProcessSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Notre processus de prêt'**
  String get loanProcessSubtitle;

  /// No description provided for @loanProcessTitle.
  ///
  /// In fr, this message translates to:
  /// **'Votre prêt en 3 étapes'**
  String get loanProcessTitle;

  /// No description provided for @loanProcessDescription.
  ///
  /// In fr, this message translates to:
  /// **'Que ce soit pour un projet, un besoin de trésorerie ou un investissement, notre objectif est de vous aider à aller de l’avant en toute confiance.'**
  String get loanProcessDescription;

  /// No description provided for @step1Title.
  ///
  /// In fr, this message translates to:
  /// **'Simulez votre prêt'**
  String get step1Title;

  /// No description provided for @step1Description.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez le montant et la durée souhaités. Recevez un devis clair et sans engagement en quelques clics.'**
  String get step1Description;

  /// No description provided for @step2Title.
  ///
  /// In fr, this message translates to:
  /// **'Soumettez votre demande'**
  String get step2Title;

  /// No description provided for @step2Description.
  ///
  /// In fr, this message translates to:
  /// **'Remplissez le formulaire sécurisé sans aucun document papier. Votre dossier est traité rapidement.'**
  String get step2Description;

  /// No description provided for @step3Title.
  ///
  /// In fr, this message translates to:
  /// **'Recevez les fonds'**
  String get step3Title;

  /// No description provided for @step3Description.
  ///
  /// In fr, this message translates to:
  /// **'Une fois votre demande approuvée, le montant est versé directement sur votre compte.'**
  String get step3Description;

  /// No description provided for @loanCtaTitle.
  ///
  /// In fr, this message translates to:
  /// **'Démarrez votre projet de prêt dès maintenant'**
  String get loanCtaTitle;

  /// No description provided for @loanCtaDescription.
  ///
  /// In fr, this message translates to:
  /// **'Vous avez un projet en tête ? Nous vous aidons à le concrétiser rapidement grâce à un prêt simple, sécurisé et 100 % en ligne.'**
  String get loanCtaDescription;

  /// No description provided for @loanCtaButton.
  ///
  /// In fr, this message translates to:
  /// **'Soumettre une demande'**
  String get loanCtaButton;

  /// No description provided for @loanServicePersonalTitle.
  ///
  /// In fr, this message translates to:
  /// **'Prêts personnels'**
  String get loanServicePersonalTitle;

  /// No description provided for @loanServicePersonalDescription.
  ///
  /// In fr, this message translates to:
  /// **'Des solutions de financement souples pour faire face à vos besoins personnels et projets du quotidien.'**
  String get loanServicePersonalDescription;

  /// No description provided for @loanServiceBusinessTitle.
  ///
  /// In fr, this message translates to:
  /// **'Prêts professionnels'**
  String get loanServiceBusinessTitle;

  /// No description provided for @loanServiceBusinessDescription.
  ///
  /// In fr, this message translates to:
  /// **'Financement adapté aux entrepreneurs, commerçants et porteurs de projets ambitieux.'**
  String get loanServiceBusinessDescription;

  /// No description provided for @loanServiceSupportTitle.
  ///
  /// In fr, this message translates to:
  /// **'Accompagnement personnalisé'**
  String get loanServiceSupportTitle;

  /// No description provided for @loanServiceSupportDescription.
  ///
  /// In fr, this message translates to:
  /// **'Un suivi humain, réactif et confidentiel pour vous accompagner à chaque étape de votre demande de prêt.'**
  String get loanServiceSupportDescription;

  /// No description provided for @learnMore.
  ///
  /// In fr, this message translates to:
  /// **'En savoir plus →'**
  String get learnMore;

  /// No description provided for @loanStatusTitle.
  ///
  /// In fr, this message translates to:
  /// **'Statut de votre prêt'**
  String get loanStatusTitle;

  /// No description provided for @loanStatusNoneTitle.
  ///
  /// In fr, this message translates to:
  /// **'Aucune demande en cours'**
  String get loanStatusNoneTitle;

  /// No description provided for @loanStatusActionRequest.
  ///
  /// In fr, this message translates to:
  /// **'Faire une demande'**
  String get loanStatusActionRequest;

  /// No description provided for @loanStatusPendingTitle.
  ///
  /// In fr, this message translates to:
  /// **'⏳ Demande en cours'**
  String get loanStatusPendingTitle;

  /// No description provided for @loanStatusPendingDescription.
  ///
  /// In fr, this message translates to:
  /// **'Notre équipe analyse actuellement votre dossier.'**
  String get loanStatusPendingDescription;

  /// No description provided for @loanStatusApprovedTitle.
  ///
  /// In fr, this message translates to:
  /// **'✅ Demande approuvée'**
  String get loanStatusApprovedTitle;

  /// No description provided for @loanStatusApprovedDescription.
  ///
  /// In fr, this message translates to:
  /// **'Les fonds seront bientôt disponibles sur votre compte.'**
  String get loanStatusApprovedDescription;

  /// No description provided for @loanStatusRejectedTitle.
  ///
  /// In fr, this message translates to:
  /// **'❌ Demande refusée'**
  String get loanStatusRejectedTitle;

  /// No description provided for @loanStatusRejectedDescription.
  ///
  /// In fr, this message translates to:
  /// **'Vous pouvez soumettre une nouvelle demande à tout moment.'**
  String get loanStatusRejectedDescription;

  /// No description provided for @quickActionsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Actions rapides'**
  String get quickActionsTitle;

  /// No description provided for @quickActionProfile.
  ///
  /// In fr, this message translates to:
  /// **'Profil'**
  String get quickActionProfile;

  /// No description provided for @quickActionNewRequest.
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle demande'**
  String get quickActionNewRequest;

  /// No description provided for @quickActionBankDetails.
  ///
  /// In fr, this message translates to:
  /// **'Mes coordonnées bancaires'**
  String get quickActionBankDetails;

  /// No description provided for @quickActionLoanHistory.
  ///
  /// In fr, this message translates to:
  /// **'Historique des demandes'**
  String get quickActionLoanHistory;

  /// No description provided for @quickActionPaymentHistory.
  ///
  /// In fr, this message translates to:
  /// **'Historique des paiements'**
  String get quickActionPaymentHistory;

  /// No description provided for @quickActionDocumentsHistory.
  ///
  /// In fr, this message translates to:
  /// **'Historique des documents'**
  String get quickActionDocumentsHistory;

  /// No description provided for @quickActionSupport.
  ///
  /// In fr, this message translates to:
  /// **'Support'**
  String get quickActionSupport;

  /// No description provided for @paymentBankDetailsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Coordonnées bancaires de paiement'**
  String get paymentBankDetailsTitle;

  /// No description provided for @noPaymentInfo.
  ///
  /// In fr, this message translates to:
  /// **'Aucune information de paiement disponible'**
  String get noPaymentInfo;

  /// No description provided for @receiver.
  ///
  /// In fr, this message translates to:
  /// **'Receveur'**
  String get receiver;

  /// No description provided for @iban.
  ///
  /// In fr, this message translates to:
  /// **'IBAN'**
  String get iban;

  /// No description provided for @bic.
  ///
  /// In fr, this message translates to:
  /// **'BIC / SWIFT'**
  String get bic;

  /// No description provided for @amountToPay.
  ///
  /// In fr, this message translates to:
  /// **'Montant à payer'**
  String get amountToPay;

  /// No description provided for @documentPreview.
  ///
  /// In fr, this message translates to:
  /// **'Aperçu du document'**
  String get documentPreview;

  /// No description provided for @confirmSubmission.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer la soumission'**
  String get confirmSubmission;

  /// No description provided for @submitProof.
  ///
  /// In fr, this message translates to:
  /// **'Soumettre une preuve'**
  String get submitProof;

  /// No description provided for @uploadSuccess.
  ///
  /// In fr, this message translates to:
  /// **'✅ Preuve envoyée avec succès'**
  String get uploadSuccess;

  /// No description provided for @uploadError.
  ///
  /// In fr, this message translates to:
  /// **'❌ Erreur lors de l\'envoi : {error}'**
  String uploadError(Object error);

  /// No description provided for @teamTitle.
  ///
  /// In fr, this message translates to:
  /// **'Notre équipe'**
  String get teamTitle;

  /// No description provided for @teamDescription.
  ///
  /// In fr, this message translates to:
  /// **'Fondée par des experts de la finance et du digital, KreditSch accompagne depuis plusieurs années des milliers de clients dans la réalisation de leurs projets grâce à des solutions de prêt simples, rapides et transparentes.\n\nNotre équipe internationale travaille chaque jour avec une seule ambition : rendre l’accès au crédit plus juste, plus humain et accessible à tous.'**
  String get teamDescription;

  /// No description provided for @teamCta.
  ///
  /// In fr, this message translates to:
  /// **'Découvrez nos solutions de prêt >'**
  String get teamCta;

  /// No description provided for @testimonialsLabel.
  ///
  /// In fr, this message translates to:
  /// **'Témoignages'**
  String get testimonialsLabel;

  /// No description provided for @testimonialsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Nous bénéficions de la confiance de milliers de clients à travers l’Europe.'**
  String get testimonialsTitle;

  /// No description provided for @testimonialsSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'La satisfaction de nos clients est notre priorité. Découvrez ce qu’ils pensent de leur expérience avec KreditSch.'**
  String get testimonialsSubtitle;

  /// No description provided for @testimonial1Text.
  ///
  /// In fr, this message translates to:
  /// **'Grâce à KreditSch, j’ai obtenu un prêt professionnel en moins de 24 heures. Les conditions étaient claires et adaptées à ma situation. Une vraie solution fiable.'**
  String get testimonial1Text;

  /// No description provided for @testimonial1Name.
  ///
  /// In fr, this message translates to:
  /// **'Martin K.'**
  String get testimonial1Name;

  /// No description provided for @testimonial1Role.
  ///
  /// In fr, this message translates to:
  /// **'Entrepreneur – Berlin'**
  String get testimonial1Role;

  /// No description provided for @testimonial2Text.
  ///
  /// In fr, this message translates to:
  /// **'J’avais besoin d’un financement urgent pour des frais médicaux. KreditSch a été rapide, humain et transparent. Je recommande sans hésiter.'**
  String get testimonial2Text;

  /// No description provided for @testimonial2Name.
  ///
  /// In fr, this message translates to:
  /// **'Sophie L.'**
  String get testimonial2Name;

  /// No description provided for @testimonial2Role.
  ///
  /// In fr, this message translates to:
  /// **'Salariée – Lyon'**
  String get testimonial2Role;

  /// No description provided for @testimonial3Text.
  ///
  /// In fr, this message translates to:
  /// **'L’interface est simple et le suivi du prêt est très clair. KreditSch m’a permis de concrétiser mon projet immobilier sereinement.'**
  String get testimonial3Text;

  /// No description provided for @testimonial3Name.
  ///
  /// In fr, this message translates to:
  /// **'Julien R.'**
  String get testimonial3Name;

  /// No description provided for @testimonial3Role.
  ///
  /// In fr, this message translates to:
  /// **'Investisseur – Bruxelles'**
  String get testimonial3Role;

  /// No description provided for @testimonial4Text.
  ///
  /// In fr, this message translates to:
  /// **'Enfin une plateforme de prêt qui comprend les indépendants. Aucune surprise, tout est expliqué dès le départ.'**
  String get testimonial4Text;

  /// No description provided for @testimonial4Name.
  ///
  /// In fr, this message translates to:
  /// **'Nadia B.'**
  String get testimonial4Name;

  /// No description provided for @testimonial4Role.
  ///
  /// In fr, this message translates to:
  /// **'Freelance – Paris'**
  String get testimonial4Role;

  /// No description provided for @testimonial5Text.
  ///
  /// In fr, this message translates to:
  /// **'Un service client réactif et des offres adaptées. KreditSch m’a accompagné du début à la fin.'**
  String get testimonial5Text;

  /// No description provided for @testimonial5Name.
  ///
  /// In fr, this message translates to:
  /// **'Thomas W.'**
  String get testimonial5Name;

  /// No description provided for @testimonial5Role.
  ///
  /// In fr, this message translates to:
  /// **'Dirigeant PME – Munich'**
  String get testimonial5Role;

  /// No description provided for @testimonials0Label.
  ///
  /// In fr, this message translates to:
  /// **'Témoignages'**
  String get testimonials0Label;

  /// No description provided for @testimonials0Title.
  ///
  /// In fr, this message translates to:
  /// **'Nous bénéficions de la confiance de plus de 50 pays à travers le monde.'**
  String get testimonials0Title;

  /// No description provided for @testimonial6Text.
  ///
  /// In fr, this message translates to:
  /// **'Grâce à ce service de prêt, j’ai pu lancer mon activité sans passer par une banque.'**
  String get testimonial6Text;

  /// No description provided for @testimonial6Name.
  ///
  /// In fr, this message translates to:
  /// **'Aïcha M.'**
  String get testimonial6Name;

  /// No description provided for @testimonial6Role.
  ///
  /// In fr, this message translates to:
  /// **'Entrepreneure'**
  String get testimonial6Role;

  /// No description provided for @testimonial7Text.
  ///
  /// In fr, this message translates to:
  /// **'Les conditions sont claires, les intérêts transparents et le remboursement flexible.'**
  String get testimonial7Text;

  /// No description provided for @testimonial7Name.
  ///
  /// In fr, this message translates to:
  /// **'Jean K.'**
  String get testimonial7Name;

  /// No description provided for @testimonial7Role.
  ///
  /// In fr, this message translates to:
  /// **'Commerçant'**
  String get testimonial7Role;

  /// No description provided for @testimonial8Text.
  ///
  /// In fr, this message translates to:
  /// **'J’ai obtenu un prêt rapidement pour une urgence familiale.'**
  String get testimonial8Text;

  /// No description provided for @testimonial8Name.
  ///
  /// In fr, this message translates to:
  /// **'Fatou S.'**
  String get testimonial8Name;

  /// No description provided for @testimonial8Role.
  ///
  /// In fr, this message translates to:
  /// **'Particulier'**
  String get testimonial8Role;

  /// No description provided for @testimonial9Text.
  ///
  /// In fr, this message translates to:
  /// **'Une plateforme fiable qui met en relation prêteurs et emprunteurs en toute confiance.'**
  String get testimonial9Text;

  /// No description provided for @testimonial9Name.
  ///
  /// In fr, this message translates to:
  /// **'Marc D.'**
  String get testimonial9Name;

  /// No description provided for @testimonial9Role.
  ///
  /// In fr, this message translates to:
  /// **'Investisseur privé'**
  String get testimonial9Role;

  /// No description provided for @trustCardTitle.
  ///
  /// In fr, this message translates to:
  /// **'Pourquoi nous faire confiance ?'**
  String get trustCardTitle;

  /// No description provided for @trustCardItem1.
  ///
  /// In fr, this message translates to:
  /// **'Taux transparents'**
  String get trustCardItem1;

  /// No description provided for @trustCardItem2.
  ///
  /// In fr, this message translates to:
  /// **'Analyse rapide'**
  String get trustCardItem2;

  /// No description provided for @trustCardItem3.
  ///
  /// In fr, this message translates to:
  /// **'Données sécurisées'**
  String get trustCardItem3;

  /// No description provided for @trustCardItem4.
  ///
  /// In fr, this message translates to:
  /// **'Assistance dédiée'**
  String get trustCardItem4;

  /// No description provided for @whatsappDefaultMessage.
  ///
  /// In fr, this message translates to:
  /// **'Bonjour, j\'ai une question concernant votre service de prêt.'**
  String get whatsappDefaultMessage;

  /// No description provided for @whatsappError.
  ///
  /// In fr, this message translates to:
  /// **'Impossible d\'ouvrir WhatsApp'**
  String get whatsappError;

  /// No description provided for @whyUsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Pourquoi nous ?'**
  String get whyUsTitle;

  /// No description provided for @whyUsSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Votre partenaire de prêts privés de confiance'**
  String get whyUsSubtitle;

  /// No description provided for @whyUsDescription.
  ///
  /// In fr, this message translates to:
  /// **'Nous combinons rapidité, transparence et accompagnement personnalisé pour vous offrir des solutions de prêts simples, efficaces et adaptées à vos objectifs.'**
  String get whyUsDescription;

  /// No description provided for @fastProcessing.
  ///
  /// In fr, this message translates to:
  /// **'Rapidité de traitement'**
  String get fastProcessing;

  /// No description provided for @securityReliability.
  ///
  /// In fr, this message translates to:
  /// **'Sécurité & fiabilité'**
  String get securityReliability;

  /// No description provided for @continuousImprovement.
  ///
  /// In fr, this message translates to:
  /// **'Amélioration continue de nos offres'**
  String get continuousImprovement;

  /// No description provided for @clientCommitment.
  ///
  /// In fr, this message translates to:
  /// **'Engagement envers nos clients'**
  String get clientCommitment;

  /// No description provided for @clearConditions.
  ///
  /// In fr, this message translates to:
  /// **'Conditions claires et sans surprise'**
  String get clearConditions;

  /// No description provided for @submitRequest.
  ///
  /// In fr, this message translates to:
  /// **'Soumettre la demande'**
  String get submitRequest;

  /// No description provided for @financingSolutionsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Nos solutions de financement'**
  String get financingSolutionsTitle;

  /// No description provided for @financingSolutionsDesc.
  ///
  /// In fr, this message translates to:
  /// **'Bien plus qu’un prêt, nous vous accompagnons à chaque étape de votre projet personnel ou professionnel.'**
  String get financingSolutionsDesc;

  /// No description provided for @viewOffers.
  ///
  /// In fr, this message translates to:
  /// **'Voir les offres'**
  String get viewOffers;

  /// No description provided for @whyChooseUsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Pourquoi nous choisir ?'**
  String get whyChooseUsTitle;

  /// No description provided for @whyChooseUsSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Une communauté internationale de milliers de clients\nnous fait confiance.'**
  String get whyChooseUsSubtitle;

  /// No description provided for @whyChooseUsDescription.
  ///
  /// In fr, this message translates to:
  /// **'Particuliers, entrepreneurs et professionnels choisissent nos solutions de prêts pour leur simplicité, leur rapidité et la clarté de leurs conditions.'**
  String get whyChooseUsDescription;

  /// No description provided for @infoQualifiedStaff.
  ///
  /// In fr, this message translates to:
  /// **'Personnel qualifié'**
  String get infoQualifiedStaff;

  /// No description provided for @infoFreeConsultation.
  ///
  /// In fr, this message translates to:
  /// **'Consultation gratuite'**
  String get infoFreeConsultation;

  /// No description provided for @infoSaveTime.
  ///
  /// In fr, this message translates to:
  /// **'Vous gagnez du temps'**
  String get infoSaveTime;

  /// No description provided for @infoOptimalService.
  ///
  /// In fr, this message translates to:
  /// **'Qualité de service optimale'**
  String get infoOptimalService;

  /// No description provided for @clientsSatisfied.
  ///
  /// In fr, this message translates to:
  /// **'Clients satisfaits'**
  String get clientsSatisfied;

  /// No description provided for @yearsActive.
  ///
  /// In fr, this message translates to:
  /// **'Années d’activité'**
  String get yearsActive;

  /// No description provided for @financialExperts.
  ///
  /// In fr, this message translates to:
  /// **'Experts financiers'**
  String get financialExperts;

  /// No description provided for @activePartners.
  ///
  /// In fr, this message translates to:
  /// **'Partenaires actifs'**
  String get activePartners;

  /// No description provided for @fillAllFields.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez remplir tous les champs'**
  String get fillAllFields;

  /// No description provided for @accountAlreadyExists.
  ///
  /// In fr, this message translates to:
  /// **'Ce compte existe déjà. Veuillez vous connecter.'**
  String get accountAlreadyExists;

  /// No description provided for @invalidEmail.
  ///
  /// In fr, this message translates to:
  /// **'Email invalide'**
  String get invalidEmail;

  /// No description provided for @weakPassword.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe trop faible (min. 6 caractères)'**
  String get weakPassword;

  /// No description provided for @registrationError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur lors de la création du compte'**
  String get registrationError;

  /// No description provided for @createAccount.
  ///
  /// In fr, this message translates to:
  /// **'Créer un compte'**
  String get createAccount;

  /// No description provided for @joinKreditSch.
  ///
  /// In fr, this message translates to:
  /// **'Rejoignez KreditSch en quelques secondes'**
  String get joinKreditSch;

  /// No description provided for @currency.
  ///
  /// In fr, this message translates to:
  /// **'Devise'**
  String get currency;

  /// No description provided for @email.
  ///
  /// In fr, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe'**
  String get password;

  /// No description provided for @createMyAccount.
  ///
  /// In fr, this message translates to:
  /// **'Créer mon compte'**
  String get createMyAccount;

  /// No description provided for @continueWithGoogle.
  ///
  /// In fr, this message translates to:
  /// **'Continuer avec Google'**
  String get continueWithGoogle;

  /// No description provided for @selectCurrency.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez sélectionner une devise'**
  String get selectCurrency;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In fr, this message translates to:
  /// **'Déjà un compte ?'**
  String get alreadyHaveAccount;

  /// No description provided for @signIn.
  ///
  /// In fr, this message translates to:
  /// **'Se connecter'**
  String get signIn;

  /// No description provided for @googleAuthError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur lors de l\'inscription Google'**
  String get googleAuthError;

  /// No description provided for @loggingOut.
  ///
  /// In fr, this message translates to:
  /// **'Déconnexion en cours…'**
  String get loggingOut;

  /// No description provided for @noAccountFound.
  ///
  /// In fr, this message translates to:
  /// **'Aucun compte trouvé. Veuillez vous inscrire.'**
  String get noAccountFound;

  /// No description provided for @incorrectPassword.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe incorrect'**
  String get incorrectPassword;

  /// No description provided for @loginError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur de connexion'**
  String get loginError;

  /// No description provided for @login.
  ///
  /// In fr, this message translates to:
  /// **'Connexion'**
  String get login;

  /// No description provided for @loginSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Accédez à votre espace client'**
  String get loginSubtitle;

  /// No description provided for @forgotPassword.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe oublié ?'**
  String get forgotPassword;

  /// No description provided for @loginButton.
  ///
  /// In fr, this message translates to:
  /// **'Se connecter'**
  String get loginButton;

  /// No description provided for @googleSignInError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur lors de la connexion Google'**
  String get googleSignInError;

  /// No description provided for @noAccountYet.
  ///
  /// In fr, this message translates to:
  /// **'Pas encore de compte ?'**
  String get noAccountYet;

  /// No description provided for @emailAlreadyInUse.
  ///
  /// In fr, this message translates to:
  /// **'Ce compte existe déjà. Veuillez vous connecter.'**
  String get emailAlreadyInUse;

  /// No description provided for @registerError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur lors de la création du compte'**
  String get registerError;

  /// No description provided for @register.
  ///
  /// In fr, this message translates to:
  /// **'Créer un compte'**
  String get register;

  /// No description provided for @registerSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Rejoignez KreditSch en quelques secondes'**
  String get registerSubtitle;

  /// No description provided for @registerButton.
  ///
  /// In fr, this message translates to:
  /// **'Créer un compte'**
  String get registerButton;

  /// No description provided for @googleRegisterError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur lors de l\'inscription Google'**
  String get googleRegisterError;

  /// No description provided for @userNotFound.
  ///
  /// In fr, this message translates to:
  /// **'Aucun compte trouvé. Veuillez vous inscrire.'**
  String get userNotFound;

  /// No description provided for @wrongPassword.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe incorrect'**
  String get wrongPassword;

  /// No description provided for @googleLoginError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur lors de la connexion Google'**
  String get googleLoginError;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe oublié'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Entrez votre adresse e-mail pour recevoir un lien de réinitialisation.'**
  String get forgotPasswordSubtitle;

  /// No description provided for @emailAddress.
  ///
  /// In fr, this message translates to:
  /// **'Adresse e-mail'**
  String get emailAddress;

  /// No description provided for @sendLink.
  ///
  /// In fr, this message translates to:
  /// **'Envoyer le lien'**
  String get sendLink;

  /// No description provided for @resetLinkSent.
  ///
  /// In fr, this message translates to:
  /// **'Un lien de réinitialisation a été envoyé à votre adresse e-mail.'**
  String get resetLinkSent;

  /// No description provided for @errorOccurred.
  ///
  /// In fr, this message translates to:
  /// **'Erreur lors de l\'envoi'**
  String get errorOccurred;

  /// No description provided for @backToLogin.
  ///
  /// In fr, this message translates to:
  /// **'Retour à la connexion'**
  String get backToLogin;

  /// No description provided for @loading.
  ///
  /// In fr, this message translates to:
  /// **'Chargement…'**
  String get loading;

  /// No description provided for @userNotLoggedIn.
  ///
  /// In fr, this message translates to:
  /// **'Utilisateur non connecté'**
  String get userNotLoggedIn;

  /// No description provided for @serverError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur serveur'**
  String get serverError;

  /// No description provided for @errorLoading.
  ///
  /// In fr, this message translates to:
  /// **'❌ Erreur chargement:'**
  String get errorLoading;

  /// No description provided for @noDocumentsSubmitted.
  ///
  /// In fr, this message translates to:
  /// **'Aucun document soumis'**
  String get noDocumentsSubmitted;

  /// No description provided for @imageUnavailable.
  ///
  /// In fr, this message translates to:
  /// **'Image indisponible'**
  String get imageUnavailable;

  /// No description provided for @approved.
  ///
  /// In fr, this message translates to:
  /// **'Approuvé'**
  String get approved;

  /// No description provided for @rejected.
  ///
  /// In fr, this message translates to:
  /// **'Rejeté'**
  String get rejected;

  /// No description provided for @pending.
  ///
  /// In fr, this message translates to:
  /// **'En attente'**
  String get pending;

  /// No description provided for @transactionHistory.
  ///
  /// In fr, this message translates to:
  /// **'Historique des transactions'**
  String get transactionHistory;

  /// No description provided for @noTransactionsSubmitted.
  ///
  /// In fr, this message translates to:
  /// **'Aucune transaction soumise'**
  String get noTransactionsSubmitted;

  /// No description provided for @submittedOn.
  ///
  /// In fr, this message translates to:
  /// **'Soumis le :'**
  String get submittedOn;

  /// No description provided for @status.
  ///
  /// In fr, this message translates to:
  /// **'Statut'**
  String get status;

  /// No description provided for @errorFetching.
  ///
  /// In fr, this message translates to:
  /// **'❌ Erreur récupération:'**
  String get errorFetching;

  /// No description provided for @heroTitle2.
  ///
  /// In fr, this message translates to:
  /// **'L\'alternative pour l\'ici et maintenant.'**
  String get heroTitle2;

  /// No description provided for @heroDescription.
  ///
  /// In fr, this message translates to:
  /// **'Dans un contexte économique exigeant, accéder rapidement à un financement fiable est devenu essentiel. KreditSch propose des solutions de prêts flexibles, transparentes et adaptées aux particuliers comme aux entreprises.'**
  String get heroDescription;

  /// No description provided for @bulletFastLoans.
  ///
  /// In fr, this message translates to:
  /// **'Prêts rapides avec réponse sous 24h.'**
  String get bulletFastLoans;

  /// No description provided for @bulletFlexibleDuration.
  ///
  /// In fr, this message translates to:
  /// **'Durées flexibles de 6 à 60 mois.'**
  String get bulletFlexibleDuration;

  /// No description provided for @bulletForAll.
  ///
  /// In fr, this message translates to:
  /// **'Solutions adaptées aux particuliers et professionnels.'**
  String get bulletForAll;

  /// No description provided for @heroCTA.
  ///
  /// In fr, this message translates to:
  /// **'Demander un prêt KreditSch Standard >'**
  String get heroCTA;

  /// No description provided for @cardLowRisk.
  ///
  /// In fr, this message translates to:
  /// **'Prêt à faible risque'**
  String get cardLowRisk;

  /// No description provided for @cardLowRiskDesc.
  ///
  /// In fr, this message translates to:
  /// **'Des mensualités fixes et transparentes pour une meilleure maîtrise de votre budget.'**
  String get cardLowRiskDesc;

  /// No description provided for @cardTargeted.
  ///
  /// In fr, this message translates to:
  /// **'Prêts ciblés'**
  String get cardTargeted;

  /// No description provided for @cardTargetedDesc.
  ///
  /// In fr, this message translates to:
  /// **'Financement dédié : logement, auto, études, projets personnels ou trésorerie.'**
  String get cardTargetedDesc;

  /// No description provided for @cardFlexibleAmount.
  ///
  /// In fr, this message translates to:
  /// **'Montant flexible'**
  String get cardFlexibleAmount;

  /// No description provided for @cardFlexibleAmountDesc.
  ///
  /// In fr, this message translates to:
  /// **'Empruntez entre 1 000 € et 500 000 € selon votre profil et votre besoin.'**
  String get cardFlexibleAmountDesc;

  /// No description provided for @dividerText.
  ///
  /// In fr, this message translates to:
  /// **'Si cette solution de prêt ne correspond pas à votre situation, KreditSch vous propose d\'autres options de financement.'**
  String get dividerText;

  /// No description provided for @cardPersonalized.
  ///
  /// In fr, this message translates to:
  /// **'Prêts personnalisés'**
  String get cardPersonalized;

  /// No description provided for @cardPersonalizedDesc.
  ///
  /// In fr, this message translates to:
  /// **'Des offres adaptées à votre situation financière et à votre capacité de remboursement.'**
  String get cardPersonalizedDesc;

  /// No description provided for @cardResponsible.
  ///
  /// In fr, this message translates to:
  /// **'Prêts responsables'**
  String get cardResponsible;

  /// No description provided for @cardResponsibleDesc.
  ///
  /// In fr, this message translates to:
  /// **'Financements pensés pour des projets durables et à impact positif.'**
  String get cardResponsibleDesc;

  /// No description provided for @cardThematic.
  ///
  /// In fr, this message translates to:
  /// **'Prêts thématiques'**
  String get cardThematic;

  /// No description provided for @cardThematicDesc.
  ///
  /// In fr, this message translates to:
  /// **'Santé, études, mobilité, logement ou entrepreneuriat.'**
  String get cardThematicDesc;

  /// No description provided for @cardPartners.
  ///
  /// In fr, this message translates to:
  /// **'Partenaires financiers'**
  String get cardPartners;

  /// No description provided for @cardPartnersDesc.
  ///
  /// In fr, this message translates to:
  /// **'Accès à des solutions issues de partenaires financiers nationaux et internationaux.'**
  String get cardPartnersDesc;

  /// No description provided for @simulationTitle.
  ///
  /// In fr, this message translates to:
  /// **'Simulez votre prêt'**
  String get simulationTitle;

  /// No description provided for @simulationDescription.
  ///
  /// In fr, this message translates to:
  /// **'Ajustez les paramètres pour estimer votre crédit.'**
  String get simulationDescription;

  /// No description provided for @loanAmount.
  ///
  /// In fr, this message translates to:
  /// **'Montant du prêt'**
  String get loanAmount;

  /// No description provided for @duration.
  ///
  /// In fr, this message translates to:
  /// **'Durée'**
  String get duration;

  /// No description provided for @months.
  ///
  /// In fr, this message translates to:
  /// **'mois'**
  String get months;

  /// No description provided for @monthlyPayment.
  ///
  /// In fr, this message translates to:
  /// **'Mensualité'**
  String get monthlyPayment;

  /// No description provided for @annualInterestRate.
  ///
  /// In fr, this message translates to:
  /// **'Taux d\'intérêt annuel du crédit'**
  String get annualInterestRate;

  /// No description provided for @monthlyInsurance.
  ///
  /// In fr, this message translates to:
  /// **'Assurance mensuelle'**
  String get monthlyInsurance;

  /// No description provided for @totalPayments.
  ///
  /// In fr, this message translates to:
  /// **'Total des mensualités (hors assurance)'**
  String get totalPayments;

  /// No description provided for @totalInterests.
  ///
  /// In fr, this message translates to:
  /// **'Total des intérêts'**
  String get totalInterests;

  /// No description provided for @totalInsurance.
  ///
  /// In fr, this message translates to:
  /// **'Total de l’assurance'**
  String get totalInsurance;

  /// No description provided for @continueRequest.
  ///
  /// In fr, this message translates to:
  /// **'Continuer la demande'**
  String get continueRequest;

  /// No description provided for @personalInfoTitle.
  ///
  /// In fr, this message translates to:
  /// **'Informations personnelles'**
  String get personalInfoTitle;

  /// No description provided for @fullNameLabel.
  ///
  /// In fr, this message translates to:
  /// **'Nom complet *'**
  String get fullNameLabel;

  /// No description provided for @fullNameHint.
  ///
  /// In fr, this message translates to:
  /// **'Votre nom complet'**
  String get fullNameHint;

  /// No description provided for @emailLabel.
  ///
  /// In fr, this message translates to:
  /// **'Email *'**
  String get emailLabel;

  /// No description provided for @emailHint.
  ///
  /// In fr, this message translates to:
  /// **'exemple@email.com'**
  String get emailHint;

  /// No description provided for @phoneLabel.
  ///
  /// In fr, this message translates to:
  /// **'Téléphone *'**
  String get phoneLabel;

  /// No description provided for @phoneHint.
  ///
  /// In fr, this message translates to:
  /// **'+49 00000000000'**
  String get phoneHint;

  /// No description provided for @dobLabel.
  ///
  /// In fr, this message translates to:
  /// **'Date de naissance'**
  String get dobLabel;

  /// No description provided for @dobHint.
  ///
  /// In fr, this message translates to:
  /// **'JJ/MM/AAAA'**
  String get dobHint;

  /// No description provided for @addressLabel.
  ///
  /// In fr, this message translates to:
  /// **'Adresse *'**
  String get addressLabel;

  /// No description provided for @addressHint.
  ///
  /// In fr, this message translates to:
  /// **''**
  String get addressHint;

  /// No description provided for @cityLabel.
  ///
  /// In fr, this message translates to:
  /// **'Ville'**
  String get cityLabel;

  /// No description provided for @countryLabel.
  ///
  /// In fr, this message translates to:
  /// **'Pays'**
  String get countryLabel;

  /// No description provided for @requiredDocsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Documents requis'**
  String get requiredDocsTitle;

  /// No description provided for @identityDoc.
  ///
  /// In fr, this message translates to:
  /// **'Pièce d\'identité (Carte d\'identité / Passeport / Permis)'**
  String get identityDoc;

  /// No description provided for @addressProof.
  ///
  /// In fr, this message translates to:
  /// **'Justificatif de domicile'**
  String get addressProof;

  /// No description provided for @noFileSelected.
  ///
  /// In fr, this message translates to:
  /// **'Aucun fichier sélectionné'**
  String get noFileSelected;

  /// No description provided for @documentAdded.
  ///
  /// In fr, this message translates to:
  /// **'Document ajouté'**
  String get documentAdded;

  /// No description provided for @uploadButton.
  ///
  /// In fr, this message translates to:
  /// **'Télécharger'**
  String get uploadButton;

  /// No description provided for @financialInfoTitle.
  ///
  /// In fr, this message translates to:
  /// **'Informations financières'**
  String get financialInfoTitle;

  /// No description provided for @amountLabel.
  ///
  /// In fr, this message translates to:
  /// **'Montant demandé'**
  String get amountLabel;

  /// No description provided for @durationLabel.
  ///
  /// In fr, this message translates to:
  /// **'Durée (mois)'**
  String get durationLabel;

  /// No description provided for @incomeLabel.
  ///
  /// In fr, this message translates to:
  /// **'Source de revenus'**
  String get incomeLabel;

  /// No description provided for @professionLabel.
  ///
  /// In fr, this message translates to:
  /// **'Profession'**
  String get professionLabel;

  /// No description provided for @fillRequiredFields.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez compléter tous les champs obligatoires'**
  String get fillRequiredFields;

  /// No description provided for @invalidAmountOrDuration.
  ///
  /// In fr, this message translates to:
  /// **'Montant ou durée invalide'**
  String get invalidAmountOrDuration;

  /// No description provided for @notAuthenticated.
  ///
  /// In fr, this message translates to:
  /// **'Utilisateur non authentifié'**
  String get notAuthenticated;

  /// No description provided for @requestSuccessTitle.
  ///
  /// In fr, this message translates to:
  /// **'Demande envoyée avec succès'**
  String get requestSuccessTitle;

  /// Message affiché après l’envoi réussi d’une demande de prêt
  ///
  /// In fr, this message translates to:
  /// **'Merci {name},\n\nMontant : {amount} {currency}\nDurée : {duration} mois\nTaux annuel : 3%\n\nMensualité : {monthlyPayment} {currency}\nTotal mensualités : {totalPayments} {currency}\nTotal intérêts : {totalInterest} {currency}\nTotal à rembourser : {totalAmount} {currency}'**
  String requestSuccessContent(
    Object name,
    Object amount,
    Object currency,
    Object duration,
    Object monthlyPayment,
    Object totalPayments,
    Object totalInterest,
    Object totalAmount,
  );

  /// No description provided for @okButton.
  ///
  /// In fr, this message translates to:
  /// **'OK'**
  String get okButton;

  /// No description provided for @loanOffersHeroTitle.
  ///
  /// In fr, this message translates to:
  /// **'Nos offres de financement'**
  String get loanOffersHeroTitle;

  /// No description provided for @loanOffersHeroSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Des solutions de crédit rapides, transparentes et adaptées à vos besoins personnels et professionnels.'**
  String get loanOffersHeroSubtitle;

  /// No description provided for @loanOffersTitle.
  ///
  /// In fr, this message translates to:
  /// **'Nos offres'**
  String get loanOffersTitle;

  /// No description provided for @loanOffersSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Découvrez les solutions de crédit que nous mettons à votre disposition.'**
  String get loanOffersSubtitle;

  /// No description provided for @offerPersonalTitle.
  ///
  /// In fr, this message translates to:
  /// **'Prêt personnel'**
  String get offerPersonalTitle;

  /// No description provided for @offerPersonalDesc.
  ///
  /// In fr, this message translates to:
  /// **'Financez vos projets personnels avec des conditions flexibles et un traitement rapide.'**
  String get offerPersonalDesc;

  /// No description provided for @offerBusinessTitle.
  ///
  /// In fr, this message translates to:
  /// **'Prêt entrepreneurial'**
  String get offerBusinessTitle;

  /// No description provided for @offerBusinessDesc.
  ///
  /// In fr, this message translates to:
  /// **'Un accompagnement financier pour développer et faire grandir votre entreprise.'**
  String get offerBusinessDesc;

  /// No description provided for @offerInvestmentTitle.
  ///
  /// In fr, this message translates to:
  /// **'Prêt investissement'**
  String get offerInvestmentTitle;

  /// No description provided for @offerInvestmentDesc.
  ///
  /// In fr, this message translates to:
  /// **'Investissez dans l’immobilier ou d’autres opportunités rentables.'**
  String get offerInvestmentDesc;

  /// No description provided for @offerEmergencyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Prêt d’urgence'**
  String get offerEmergencyTitle;

  /// No description provided for @offerEmergencyDesc.
  ///
  /// In fr, this message translates to:
  /// **'Une solution rapide pour faire face aux imprévus financiers.'**
  String get offerEmergencyDesc;

  /// No description provided for @loanOffersCtaTitle.
  ///
  /// In fr, this message translates to:
  /// **'Prêt à faire votre demande ?'**
  String get loanOffersCtaTitle;

  /// No description provided for @loanOffersCtaSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Contactez-nous dès aujourd’hui et bénéficiez d’un accompagnement personnalisé.'**
  String get loanOffersCtaSubtitle;

  /// No description provided for @loanOffersCtaButton.
  ///
  /// In fr, this message translates to:
  /// **'Faire une demande'**
  String get loanOffersCtaButton;

  /// No description provided for @loanHistoryTitle.
  ///
  /// In fr, this message translates to:
  /// **'Historique des demandes'**
  String get loanHistoryTitle;

  /// No description provided for @loanHistoryEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucune demande trouvée'**
  String get loanHistoryEmpty;

  /// No description provided for @loanSubmittedOn.
  ///
  /// In fr, this message translates to:
  /// **'Soumise le'**
  String get loanSubmittedOn;

  /// No description provided for @personalInformation.
  ///
  /// In fr, this message translates to:
  /// **'Informations personnelles'**
  String get personalInformation;

  /// No description provided for @financialInformation.
  ///
  /// In fr, this message translates to:
  /// **'Informations financières'**
  String get financialInformation;

  /// No description provided for @loanSummary.
  ///
  /// In fr, this message translates to:
  /// **'Récapitulatif du crédit'**
  String get loanSummary;

  /// No description provided for @phone.
  ///
  /// In fr, this message translates to:
  /// **'Téléphone'**
  String get phone;

  /// No description provided for @address.
  ///
  /// In fr, this message translates to:
  /// **'Adresse'**
  String get address;

  /// No description provided for @city.
  ///
  /// In fr, this message translates to:
  /// **'Ville'**
  String get city;

  /// No description provided for @country.
  ///
  /// In fr, this message translates to:
  /// **'Pays'**
  String get country;

  /// No description provided for @profession.
  ///
  /// In fr, this message translates to:
  /// **'Profession'**
  String get profession;

  /// No description provided for @incomeSource.
  ///
  /// In fr, this message translates to:
  /// **'Source de revenus'**
  String get incomeSource;

  /// No description provided for @requestedAmount.
  ///
  /// In fr, this message translates to:
  /// **'Montant demandé'**
  String get requestedAmount;

  /// No description provided for @totalInterest.
  ///
  /// In fr, this message translates to:
  /// **'Intérêts'**
  String get totalInterest;

  /// No description provided for @totalToRepay.
  ///
  /// In fr, this message translates to:
  /// **'Total à rembourser'**
  String get totalToRepay;

  /// No description provided for @submittedDocuments.
  ///
  /// In fr, this message translates to:
  /// **'Documents soumis'**
  String get submittedDocuments;

  /// No description provided for @identityDocument.
  ///
  /// In fr, this message translates to:
  /// **'Pièce d\'identité'**
  String get identityDocument;

  /// No description provided for @statusPending.
  ///
  /// In fr, this message translates to:
  /// **'En cours'**
  String get statusPending;

  /// No description provided for @statusApproved.
  ///
  /// In fr, this message translates to:
  /// **'Approuvée'**
  String get statusApproved;

  /// No description provided for @statusRejected.
  ///
  /// In fr, this message translates to:
  /// **'Refusée'**
  String get statusRejected;

  /// No description provided for @dashboardTitle.
  ///
  /// In fr, this message translates to:
  /// **'Tableau de bord'**
  String get dashboardTitle;

  /// No description provided for @dashboardHello.
  ///
  /// In fr, this message translates to:
  /// **'Bonjour 👋'**
  String get dashboardHello;

  /// No description provided for @dashboardWelcome.
  ///
  /// In fr, this message translates to:
  /// **'Bienvenue dans votre espace client sécurisé'**
  String get dashboardWelcome;

  /// No description provided for @dashboardSecureData.
  ///
  /// In fr, this message translates to:
  /// **'🔒 Données protégées'**
  String get dashboardSecureData;

  /// No description provided for @contactSectionLabel.
  ///
  /// In fr, this message translates to:
  /// **'Contact'**
  String get contactSectionLabel;

  /// No description provided for @contactTitle.
  ///
  /// In fr, this message translates to:
  /// **'Contactez KreditSch'**
  String get contactTitle;

  /// No description provided for @contactDescription.
  ///
  /// In fr, this message translates to:
  /// **'Notre équipe KreditSch est à votre écoute pour toute demande de prêt personnel, professionnel ou d’urgence.'**
  String get contactDescription;

  /// No description provided for @contactAddressTitle.
  ///
  /// In fr, this message translates to:
  /// **'Allemagne'**
  String get contactAddressTitle;

  /// No description provided for @contactAddress.
  ///
  /// In fr, this message translates to:
  /// **'Audensstraße 2 – 61348 Bad Homburg v.d. Höhe'**
  String get contactAddress;

  /// No description provided for @contactPhoneTitle.
  ///
  /// In fr, this message translates to:
  /// **'Téléphone'**
  String get contactPhoneTitle;

  /// No description provided for @contactPhone.
  ///
  /// In fr, this message translates to:
  /// **'+49 1577 4851991'**
  String get contactPhone;

  /// No description provided for @contactEmailTitle.
  ///
  /// In fr, this message translates to:
  /// **'E-mail'**
  String get contactEmailTitle;

  /// No description provided for @contactEmail.
  ///
  /// In fr, this message translates to:
  /// **'contact@kreditsch.de'**
  String get contactEmail;

  /// No description provided for @contactFormName.
  ///
  /// In fr, this message translates to:
  /// **'Nom'**
  String get contactFormName;

  /// No description provided for @contactFormNameHint.
  ///
  /// In fr, this message translates to:
  /// **'Votre nom'**
  String get contactFormNameHint;

  /// No description provided for @contactFormEmail.
  ///
  /// In fr, this message translates to:
  /// **'E-mail'**
  String get contactFormEmail;

  /// No description provided for @contactFormEmailHint.
  ///
  /// In fr, this message translates to:
  /// **'Votre adresse e-mail'**
  String get contactFormEmailHint;

  /// No description provided for @contactFormSubject.
  ///
  /// In fr, this message translates to:
  /// **'Thème'**
  String get contactFormSubject;

  /// No description provided for @contactFormSubjectHint.
  ///
  /// In fr, this message translates to:
  /// **'Demande de prêt, informations, assistance...'**
  String get contactFormSubjectHint;

  /// No description provided for @contactFormMessage.
  ///
  /// In fr, this message translates to:
  /// **'Message'**
  String get contactFormMessage;

  /// No description provided for @contactFormMessageHint.
  ///
  /// In fr, this message translates to:
  /// **'Décrivez votre besoin ou votre question'**
  String get contactFormMessageHint;

  /// No description provided for @contactFormSubmit.
  ///
  /// In fr, this message translates to:
  /// **'Envoyer un message'**
  String get contactFormSubmit;

  /// No description provided for @profileTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mon profil'**
  String get profileTitle;

  /// No description provided for @profileNotCreatedTitle.
  ///
  /// In fr, this message translates to:
  /// **'Profil non encore créé'**
  String get profileNotCreatedTitle;

  /// No description provided for @profileNotCreatedDescription.
  ///
  /// In fr, this message translates to:
  /// **'Pour compléter votre profil, veuillez effectuer\nvotre première demande de prêt.'**
  String get profileNotCreatedDescription;

  /// No description provided for @profileCreateLoanButton.
  ///
  /// In fr, this message translates to:
  /// **'Faire une demande de prêt'**
  String get profileCreateLoanButton;

  /// No description provided for @profilePersonalInfoTitle.
  ///
  /// In fr, this message translates to:
  /// **'Informations personnelles'**
  String get profilePersonalInfoTitle;

  /// No description provided for @profileContactTitle.
  ///
  /// In fr, this message translates to:
  /// **'Coordonnées'**
  String get profileContactTitle;

  /// No description provided for @profileProfessionalTitle.
  ///
  /// In fr, this message translates to:
  /// **'Situation professionnelle'**
  String get profileProfessionalTitle;

  /// No description provided for @profileBirthDate.
  ///
  /// In fr, this message translates to:
  /// **'Date de naissance'**
  String get profileBirthDate;

  /// No description provided for @profileCountry.
  ///
  /// In fr, this message translates to:
  /// **'Pays'**
  String get profileCountry;

  /// No description provided for @profileCity.
  ///
  /// In fr, this message translates to:
  /// **'Ville'**
  String get profileCity;

  /// No description provided for @profileAddress.
  ///
  /// In fr, this message translates to:
  /// **'Adresse'**
  String get profileAddress;

  /// No description provided for @profileEmail.
  ///
  /// In fr, this message translates to:
  /// **'Email'**
  String get profileEmail;

  /// No description provided for @profilePhone.
  ///
  /// In fr, this message translates to:
  /// **'Téléphone'**
  String get profilePhone;

  /// No description provided for @profileProfession.
  ///
  /// In fr, this message translates to:
  /// **'Profession'**
  String get profileProfession;

  /// No description provided for @profileIncomeSource.
  ///
  /// In fr, this message translates to:
  /// **'Source de revenus'**
  String get profileIncomeSource;

  /// No description provided for @profileStatusPending.
  ///
  /// In fr, this message translates to:
  /// **'En cours'**
  String get profileStatusPending;

  /// No description provided for @profileStatusApproved.
  ///
  /// In fr, this message translates to:
  /// **'Approuvé'**
  String get profileStatusApproved;

  /// No description provided for @profileStatusRejected.
  ///
  /// In fr, this message translates to:
  /// **'Refusé'**
  String get profileStatusRejected;

  /// No description provided for @aboutContactUs.
  ///
  /// In fr, this message translates to:
  /// **'Écrivez-nous'**
  String get aboutContactUs;

  /// No description provided for @aboutLabel.
  ///
  /// In fr, this message translates to:
  /// **'Via KreditSch'**
  String get aboutLabel;

  /// No description provided for @aboutTitle.
  ///
  /// In fr, this message translates to:
  /// **'Des solutions de prêt adaptées à chaque projet'**
  String get aboutTitle;

  /// No description provided for @aboutDescription.
  ///
  /// In fr, this message translates to:
  /// **'KreditSch accompagne particuliers et entrepreneurs avec des solutions de prêt fiables, transparentes et rapides, adaptées à vos besoins financiers réels.'**
  String get aboutDescription;

  /// No description provided for @aboutFeaturePersonalLoanTitle.
  ///
  /// In fr, this message translates to:
  /// **'Prêt personnel flexible'**
  String get aboutFeaturePersonalLoanTitle;

  /// No description provided for @aboutFeaturePersonalLoanDesc.
  ///
  /// In fr, this message translates to:
  /// **'Financez vos projets personnels avec des conditions claires et sans surprise.'**
  String get aboutFeaturePersonalLoanDesc;

  /// No description provided for @aboutFeatureBusinessLoanTitle.
  ///
  /// In fr, this message translates to:
  /// **'Prêt professionnel'**
  String get aboutFeatureBusinessLoanTitle;

  /// No description provided for @aboutFeatureBusinessLoanDesc.
  ///
  /// In fr, this message translates to:
  /// **'Un soutien financier solide pour développer votre activité en toute sérénité.'**
  String get aboutFeatureBusinessLoanDesc;

  /// No description provided for @aboutFeatureFastPaymentTitle.
  ///
  /// In fr, this message translates to:
  /// **'Décaissement rapide'**
  String get aboutFeatureFastPaymentTitle;

  /// No description provided for @aboutFeatureFastPaymentDesc.
  ///
  /// In fr, this message translates to:
  /// **'Recevez vos fonds rapidement après validation de votre dossier.'**
  String get aboutFeatureFastPaymentDesc;

  /// No description provided for @aboutFeatureSecurityTitle.
  ///
  /// In fr, this message translates to:
  /// **'Processus sécurisé'**
  String get aboutFeatureSecurityTitle;

  /// No description provided for @aboutFeatureSecurityDesc.
  ///
  /// In fr, this message translates to:
  /// **'Vos données sont protégées selon les normes les plus strictes.'**
  String get aboutFeatureSecurityDesc;

  /// No description provided for @supportTitle.
  ///
  /// In fr, this message translates to:
  /// **'Support'**
  String get supportTitle;

  /// No description provided for @supportChatTitle.
  ///
  /// In fr, this message translates to:
  /// **'Chat support'**
  String get supportChatTitle;

  /// No description provided for @newConversation.
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle discussion'**
  String get newConversation;

  /// No description provided for @supportTyping.
  ///
  /// In fr, this message translates to:
  /// **'Le support est en train d’écrire…'**
  String get supportTyping;

  /// No description provided for @messageHint.
  ///
  /// In fr, this message translates to:
  /// **'Votre message...'**
  String get messageHint;

  /// No description provided for @bankDetailsSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Informations du compte bancaire'**
  String get bankDetailsSubtitle;

  /// No description provided for @receiverFullName.
  ///
  /// In fr, this message translates to:
  /// **'Nom complet du receveur'**
  String get receiverFullName;

  /// No description provided for @save.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer'**
  String get save;

  /// No description provided for @requiredField.
  ///
  /// In fr, this message translates to:
  /// **'Champ requis'**
  String get requiredField;

  /// No description provided for @bankDetailsSaved.
  ///
  /// In fr, this message translates to:
  /// **'Coordonnées bancaires enregistrées avec succès'**
  String get bankDetailsSaved;

  /// No description provided for @genericError.
  ///
  /// In fr, this message translates to:
  /// **'❌ Une erreur est survenue : {error}'**
  String genericError(Object error);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'bg',
    'cs',
    'da',
    'de',
    'el',
    'en',
    'es',
    'et',
    'fi',
    'fr',
    'ga',
    'hr',
    'hu',
    'it',
    'lt',
    'lv',
    'mt',
    'nl',
    'pl',
    'pt',
    'ro',
    'sk',
    'sl',
    'sv',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bg':
      return AppLocalizationsBg();
    case 'cs':
      return AppLocalizationsCs();
    case 'da':
      return AppLocalizationsDa();
    case 'de':
      return AppLocalizationsDe();
    case 'el':
      return AppLocalizationsEl();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'et':
      return AppLocalizationsEt();
    case 'fi':
      return AppLocalizationsFi();
    case 'fr':
      return AppLocalizationsFr();
    case 'ga':
      return AppLocalizationsGa();
    case 'hr':
      return AppLocalizationsHr();
    case 'hu':
      return AppLocalizationsHu();
    case 'it':
      return AppLocalizationsIt();
    case 'lt':
      return AppLocalizationsLt();
    case 'lv':
      return AppLocalizationsLv();
    case 'mt':
      return AppLocalizationsMt();
    case 'nl':
      return AppLocalizationsNl();
    case 'pl':
      return AppLocalizationsPl();
    case 'pt':
      return AppLocalizationsPt();
    case 'ro':
      return AppLocalizationsRo();
    case 'sk':
      return AppLocalizationsSk();
    case 'sl':
      return AppLocalizationsSl();
    case 'sv':
      return AppLocalizationsSv();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
