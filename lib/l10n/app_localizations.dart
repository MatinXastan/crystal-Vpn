import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fa.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_zh.dart';

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
    Locale('en'),
    Locale('fa'),
    Locale('ru'),
    Locale('tr'),
    Locale('zh'),
  ];

  /// No description provided for @crystalVpn.
  ///
  /// In en, this message translates to:
  /// **'Crystal VPN'**
  String get crystalVpn;

  /// No description provided for @superApp.
  ///
  /// In en, this message translates to:
  /// **'Super App'**
  String get superApp;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version 1.0.0'**
  String get version;

  /// No description provided for @termsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms and Conditions'**
  String get termsAndConditions;

  /// No description provided for @configSourceInfo.
  ///
  /// In en, this message translates to:
  /// **'We have gathered the best possible free configs from public sources.'**
  String get configSourceInfo;

  /// No description provided for @illegalUseWarning.
  ///
  /// In en, this message translates to:
  /// **'Using this app for illegal purposes is prohibited.'**
  String get illegalUseWarning;

  /// No description provided for @sensitiveUseWarning.
  ///
  /// In en, this message translates to:
  /// **'Do not use these configs for sensitive tasks (like banking).'**
  String get sensitiveUseWarning;

  /// No description provided for @acceptTerms.
  ///
  /// In en, this message translates to:
  /// **'I have read and accept the terms'**
  String get acceptTerms;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @autoRedirectMsg.
  ///
  /// In en, this message translates to:
  /// **'You will be redirected in 10 seconds if no selection is made.'**
  String get autoRedirectMsg;

  /// No description provided for @errorLabel.
  ///
  /// In en, this message translates to:
  /// **'Error: '**
  String get errorLabel;

  /// No description provided for @countLabel.
  ///
  /// In en, this message translates to:
  /// **'Count: '**
  String get countLabel;

  /// No description provided for @allConfigs.
  ///
  /// In en, this message translates to:
  /// **'All Configs'**
  String get allConfigs;

  /// No description provided for @findNewConfigs.
  ///
  /// In en, this message translates to:
  /// **'Click to find new configs'**
  String get findNewConfigs;

  /// No description provided for @receivingConfigs.
  ///
  /// In en, this message translates to:
  /// **'Receiving configs...'**
  String get receivingConfigs;

  /// No description provided for @pingWaitMsg.
  ///
  /// In en, this message translates to:
  /// **'Please wait for the ping test to complete.'**
  String get pingWaitMsg;

  /// No description provided for @retestNeededMsg.
  ///
  /// In en, this message translates to:
  /// **'Configs need retesting. Ping test starting.'**
  String get retestNeededMsg;

  /// No description provided for @bestConfigSelected.
  ///
  /// In en, this message translates to:
  /// **'Best config selected'**
  String get bestConfigSelected;

  /// No description provided for @autoSelect.
  ///
  /// In en, this message translates to:
  /// **'Auto Select'**
  String get autoSelect;

  /// No description provided for @stop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stop;

  /// No description provided for @test.
  ///
  /// In en, this message translates to:
  /// **'Test'**
  String get test;

  /// No description provided for @selectConfigMsg.
  ///
  /// In en, this message translates to:
  /// **'Select a config from the list'**
  String get selectConfigMsg;

  /// No description provided for @alreadyConnectedMsg.
  ///
  /// In en, this message translates to:
  /// **'Connecting or already connected.'**
  String get alreadyConnectedMsg;

  /// No description provided for @invalidConfigMsg.
  ///
  /// In en, this message translates to:
  /// **'Selected config is invalid.'**
  String get invalidConfigMsg;

  /// No description provided for @v2rayErrorMsg.
  ///
  /// In en, this message translates to:
  /// **'Error starting V2Ray: '**
  String get v2rayErrorMsg;

  /// No description provided for @selectedServer.
  ///
  /// In en, this message translates to:
  /// **'Selected Server'**
  String get selectedServer;

  /// No description provided for @selectConfig.
  ///
  /// In en, this message translates to:
  /// **'Select Config'**
  String get selectConfig;

  /// No description provided for @connectionStatus.
  ///
  /// In en, this message translates to:
  /// **'Connection Status'**
  String get connectionStatus;

  /// No description provided for @protocol.
  ///
  /// In en, this message translates to:
  /// **'Protocol: '**
  String get protocol;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @refreshLocation.
  ///
  /// In en, this message translates to:
  /// **'Refresh Location'**
  String get refreshLocation;

  /// No description provided for @uptime.
  ///
  /// In en, this message translates to:
  /// **'Uptime'**
  String get uptime;

  /// No description provided for @myInformation.
  ///
  /// In en, this message translates to:
  /// **'My Information'**
  String get myInformation;

  /// No description provided for @telegramItem.
  ///
  /// In en, this message translates to:
  /// **'Telegram Channel'**
  String get telegramItem;

  /// No description provided for @myTelegramChannel.
  ///
  /// In en, this message translates to:
  /// **'My Telegram Channel'**
  String get myTelegramChannel;

  /// No description provided for @githubItem.
  ///
  /// In en, this message translates to:
  /// **'GitHub'**
  String get githubItem;

  /// No description provided for @myGithub.
  ///
  /// In en, this message translates to:
  /// **'My GitHub'**
  String get myGithub;

  /// No description provided for @projectItem.
  ///
  /// In en, this message translates to:
  /// **'Project'**
  String get projectItem;

  /// No description provided for @projectAddress.
  ///
  /// In en, this message translates to:
  /// **'Project Address'**
  String get projectAddress;

  /// No description provided for @errorReceivingConfigs.
  ///
  /// In en, this message translates to:
  /// **'Error receiving configs'**
  String get errorReceivingConfigs;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @pleaseSelectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Please select your language'**
  String get pleaseSelectLanguage;

  /// No description provided for @chooseYourLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose Your Language'**
  String get chooseYourLanguage;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fa', 'ru', 'tr', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fa':
      return AppLocalizationsFa();
    case 'ru':
      return AppLocalizationsRu();
    case 'tr':
      return AppLocalizationsTr();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
