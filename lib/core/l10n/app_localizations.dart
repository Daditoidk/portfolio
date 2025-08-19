import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_ja.dart';

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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('ja')
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Portfolio'**
  String get appTitle;

  /// The name displayed in the header section
  ///
  /// In en, this message translates to:
  /// **'Camilo Santacruz Abadiano'**
  String get headerName;

  /// The professional title in the header
  ///
  /// In en, this message translates to:
  /// **'Mobile Developer'**
  String get headerTitle;

  /// The subtitle in the header section
  ///
  /// In en, this message translates to:
  /// **'Creating beautiful mobile experiences'**
  String get headerSubtitle;

  /// Title of the about section
  ///
  /// In en, this message translates to:
  /// **'About Me'**
  String get aboutTitle;

  /// The main description in the about section
  ///
  /// In en, this message translates to:
  /// **'I am a curious person passionate about technology, food, video games, soccer, fitness, dance, music, philosophy, psychology, and a bit of history. I love exploring my country and learning about its diverse cultures and landscapes.'**
  String get aboutDescription;

  /// Subtitle for the about section
  ///
  /// In en, this message translates to:
  /// **'A tech enthusiast who believes in continuous learning and finding joy in both digital innovation and life\'s simple pleasures.'**
  String get aboutSubtitle;

  /// Comma-separated list of skills for the about section
  ///
  /// In en, this message translates to:
  /// **'Flutter, Kotlin, Swift, Rive, Cursor, CodeMagic, REST APIs, Git, UX/UI Design'**
  String get aboutSkills;

  /// Title of the skills section
  ///
  /// In en, this message translates to:
  /// **'Skills & Technologies'**
  String get skillsTitle;

  /// Subtitle of the skills section
  ///
  /// In en, this message translates to:
  /// **'My technical expertise and tools I work with'**
  String get skillsSubtitle;

  /// Category title for programming languages
  ///
  /// In en, this message translates to:
  /// **'Programming Languages'**
  String get skillsLanguages;

  /// Category title for editors and development tools
  ///
  /// In en, this message translates to:
  /// **'Editors & Tools'**
  String get skillsEditors;

  /// Category title for design and animation tools
  ///
  /// In en, this message translates to:
  /// **'Design & Animation'**
  String get skillsDesign;

  /// Category title for DevOps and CI/CD tools
  ///
  /// In en, this message translates to:
  /// **'DevOps & CI/CD'**
  String get skillsDevOps;

  /// Category title for APIs and services
  ///
  /// In en, this message translates to:
  /// **'APIs & Services'**
  String get skillsAPIs;

  /// Flutter skill name
  ///
  /// In en, this message translates to:
  /// **'Flutter'**
  String get skillFlutter;

  /// Dart skill name
  ///
  /// In en, this message translates to:
  /// **'Dart'**
  String get skillDart;

  /// Kotlin skill name
  ///
  /// In en, this message translates to:
  /// **'Kotlin'**
  String get skillKotlin;

  /// Kotlin Multiplatform skill name
  ///
  /// In en, this message translates to:
  /// **'Kotlin Multiplatform'**
  String get skillKotlinMultiplatform;

  /// Swift skill name
  ///
  /// In en, this message translates to:
  /// **'Swift'**
  String get skillSwift;

  /// Title for the page structure dialog
  ///
  /// In en, this message translates to:
  /// **'Page Structure'**
  String get pageStructureTitle;

  /// Tab label for headings in page structure
  ///
  /// In en, this message translates to:
  /// **'Headings'**
  String get pageStructureHeadings;

  /// Tab label for landmarks in page structure
  ///
  /// In en, this message translates to:
  /// **'Landmarks'**
  String get pageStructureLandmarks;

  /// Tab label for links in page structure
  ///
  /// In en, this message translates to:
  /// **'Links'**
  String get pageStructureLinks;

  /// Message shown when no headings are found
  ///
  /// In en, this message translates to:
  /// **'No headings found on this page'**
  String get pageStructureNoHeadings;

  /// Message shown when no landmarks are found
  ///
  /// In en, this message translates to:
  /// **'No landmarks found on this page'**
  String get pageStructureNoLandmarks;

  /// Message shown when no links are found
  ///
  /// In en, this message translates to:
  /// **'No links found on this page'**
  String get pageStructureNoLinks;

  /// Rive skill name
  ///
  /// In en, this message translates to:
  /// **'Rive'**
  String get skillRive;

  /// Figma skill name
  ///
  /// In en, this message translates to:
  /// **'Figma'**
  String get skillFigma;

  /// Adobe XD skill name
  ///
  /// In en, this message translates to:
  /// **'Adobe XD'**
  String get skillAdobeXD;

  /// Android Studio skill name
  ///
  /// In en, this message translates to:
  /// **'Android Studio'**
  String get skillAndroidStudio;

  /// Visual Studio Code skill name
  ///
  /// In en, this message translates to:
  /// **'Visual Studio Code'**
  String get skillVSCode;

  /// Cursor skill name
  ///
  /// In en, this message translates to:
  /// **'Cursor'**
  String get skillCursor;

  /// Git skill name
  ///
  /// In en, this message translates to:
  /// **'Git'**
  String get skillGit;

  /// Scrum skill name
  ///
  /// In en, this message translates to:
  /// **'Scrum'**
  String get skillScrum;

  /// Agile skill name
  ///
  /// In en, this message translates to:
  /// **'Agile'**
  String get skillAgile;

  /// Kanban skill name
  ///
  /// In en, this message translates to:
  /// **'Kanban'**
  String get skillKanban;

  /// CodeMagic skill name
  ///
  /// In en, this message translates to:
  /// **'CodeMagic'**
  String get skillCodeMagic;

  /// GitHub Actions skill name
  ///
  /// In en, this message translates to:
  /// **'GitHub Actions'**
  String get skillGithubActions;

  /// Riverpod skill name
  ///
  /// In en, this message translates to:
  /// **'Riverpod'**
  String get skillRiverpod;

  /// Provider skill name
  ///
  /// In en, this message translates to:
  /// **'Provider'**
  String get skillProvider;

  /// Hooks skill name
  ///
  /// In en, this message translates to:
  /// **'Hooks'**
  String get skillHooks;

  /// Freezed skill name
  ///
  /// In en, this message translates to:
  /// **'Freezed'**
  String get skillFreezed;

  /// Platform Channels skill name
  ///
  /// In en, this message translates to:
  /// **'Platform Channels'**
  String get skillPlatformChannels;

  /// REST skill name
  ///
  /// In en, this message translates to:
  /// **'REST'**
  String get skillRest;

  /// Isar Database skill name
  ///
  /// In en, this message translates to:
  /// **'Isar Database'**
  String get skillIsarDatabase;

  /// SQLite skill name
  ///
  /// In en, this message translates to:
  /// **'SQLite'**
  String get skillSqlLite;

  /// Firebase skill name
  ///
  /// In en, this message translates to:
  /// **'Firebase'**
  String get skillFirebase;

  /// Firebase Analytics skill name
  ///
  /// In en, this message translates to:
  /// **'Firebase Analytics'**
  String get skillFirebaseAnalytics;

  /// Firebase Crashlytics skill name
  ///
  /// In en, this message translates to:
  /// **'Firebase Crashlytics'**
  String get skillFirebaseCrashlytics;

  /// Mason skill name
  ///
  /// In en, this message translates to:
  /// **'Mason'**
  String get skillMason;

  /// Years of experience text
  ///
  /// In en, this message translates to:
  /// **'{years}+ years of experience'**
  String yearsOfExperience(String years);

  /// Text for 1 year or less experience
  ///
  /// In en, this message translates to:
  /// **'1 year or less of experience'**
  String get oneYearOrLess;

  /// Label for currently used technologies
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get currentlyUsing;

  /// Tooltip text for active technology badge
  ///
  /// In en, this message translates to:
  /// **'Currently using this technology'**
  String get activeTooltip;

  /// Tooltip text for experience badges
  ///
  /// In en, this message translates to:
  /// **'Click to see experience details'**
  String get experienceTooltip;

  /// Title of the projects section
  ///
  /// In en, this message translates to:
  /// **'My Projects'**
  String get projectsTitle;

  /// Subtitle of the projects section
  ///
  /// In en, this message translates to:
  /// **'A selection of my recent projects.'**
  String get projectsSubtitle;

  /// Title of the e-commerce project
  ///
  /// In en, this message translates to:
  /// **'E-Commerce App'**
  String get projectEcommerceTitle;

  /// Description of the e-commerce project
  ///
  /// In en, this message translates to:
  /// **'A full-featured mobile shopping app with payment integration'**
  String get projectEcommerceDescription;

  /// Title of the task manager project
  ///
  /// In en, this message translates to:
  /// **'Task Manager'**
  String get projectTaskManagerTitle;

  /// Description of the task manager project
  ///
  /// In en, this message translates to:
  /// **'Simple and intuitive task management application'**
  String get projectTaskManagerDescription;

  /// Title of the weather app project
  ///
  /// In en, this message translates to:
  /// **'Weather App'**
  String get projectWeatherTitle;

  /// Description of the weather app project
  ///
  /// In en, this message translates to:
  /// **'Real-time weather updates with beautiful UI'**
  String get projectWeatherDescription;

  /// Title of the lab section
  ///
  /// In en, this message translates to:
  /// **'Lab'**
  String get labTitle;

  /// Subtitle of the lab section
  ///
  /// In en, this message translates to:
  /// **'Experimental projects and creative experiments'**
  String get labSubtitle;

  /// Title of the AI chat bot lab project
  ///
  /// In en, this message translates to:
  /// **'AI Chat Bot'**
  String get labAIChatTitle;

  /// Description of the AI chat bot lab project
  ///
  /// In en, this message translates to:
  /// **'Experimental chatbot using machine learning'**
  String get labAIChatDescription;

  /// Title of the AR experience lab project
  ///
  /// In en, this message translates to:
  /// **'AR Experience'**
  String get labARTitle;

  /// Description of the AR experience lab project
  ///
  /// In en, this message translates to:
  /// **'Augmented reality prototype for mobile'**
  String get labARDescription;

  /// Title of the voice assistant lab project
  ///
  /// In en, this message translates to:
  /// **'Voice Assistant'**
  String get labVoiceTitle;

  /// Description of the voice assistant lab project
  ///
  /// In en, this message translates to:
  /// **'Voice-controlled app interface'**
  String get labVoiceDescription;

  /// Badge text for experimental projects
  ///
  /// In en, this message translates to:
  /// **'Experimental'**
  String get experimentalBadge;

  /// Title of the contact section
  ///
  /// In en, this message translates to:
  /// **'Get In Touch'**
  String get contactTitle;

  /// Subtitle of the contact section
  ///
  /// In en, this message translates to:
  /// **'Let\'s work together on your next project'**
  String get contactSubtitle;

  /// Contact email address
  ///
  /// In en, this message translates to:
  /// **'kamiomg99@gmail.com'**
  String get contactEmail;

  /// Contact phone number
  ///
  /// In en, this message translates to:
  /// **'+57 3025298355'**
  String get contactPhone;

  /// Contact location
  ///
  /// In en, this message translates to:
  /// **'Funza, Cundinamarca.\nColombia'**
  String get contactLocation;

  /// Navigation item for home section
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// Navigation item for about section
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get navAbout;

  /// Navigation item for projects section
  ///
  /// In en, this message translates to:
  /// **'Projects'**
  String get navProjects;

  /// Navigation item for lab section
  ///
  /// In en, this message translates to:
  /// **'Lab'**
  String get navLab;

  /// Navigation item for contact section
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get navContact;

  /// Accessibility label for language switcher
  ///
  /// In en, this message translates to:
  /// **'Language switcher'**
  String get a11yLanguageSwitcher;

  /// Accessibility hint for language switcher
  ///
  /// In en, this message translates to:
  /// **'Double tap to change language'**
  String get a11yLanguageSwitcherHint;

  /// Accessibility label for English language button
  ///
  /// In en, this message translates to:
  /// **'Switch to English'**
  String get a11ySwitchToEnglish;

  /// Accessibility hint for currently selected language
  ///
  /// In en, this message translates to:
  /// **'Currently selected language'**
  String get a11yCurrentlySelectedLanguage;

  /// Accessibility hint for switching to English
  ///
  /// In en, this message translates to:
  /// **'Double tap to switch to English'**
  String get a11yDoubleTapToSwitchToEnglish;

  /// Accessibility value for selected state
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get a11ySelected;

  /// Accessibility value for not selected state
  ///
  /// In en, this message translates to:
  /// **'Not selected'**
  String get a11yNotSelected;

  /// Accessibility label for American flag
  ///
  /// In en, this message translates to:
  /// **'American flag'**
  String get a11yAmericanFlag;

  /// Accessibility label for navigation menu
  ///
  /// In en, this message translates to:
  /// **'Navigation menu'**
  String get a11y_navigationMenu;

  /// Accessibility hint for navigation menu
  ///
  /// In en, this message translates to:
  /// **'Use to navigate between sections'**
  String get a11y_navigationMenuHint;

  /// Accessibility label for portfolio title
  ///
  /// In en, this message translates to:
  /// **'Portfolio title'**
  String get a11y_portfolioTitle;

  /// Accessibility label for navigation links
  ///
  /// In en, this message translates to:
  /// **'Navigation links'**
  String get a11y_navigationLinks;

  /// Welcome message on the main selection screen
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get mainSelectionWelcome;

  /// Subtitle on the main selection screen
  ///
  /// In en, this message translates to:
  /// **'Choose your destination'**
  String get mainSelectionSubtitle;

  /// Title for the portfolio navigation button
  ///
  /// In en, this message translates to:
  /// **'Portfolio'**
  String get mainSelectionPortfolioTitle;

  /// Subtitle for the portfolio navigation button
  ///
  /// In en, this message translates to:
  /// **'View my projects and experience'**
  String get mainSelectionPortfolioSubtitle;

  /// Title for the lab navigation button
  ///
  /// In en, this message translates to:
  /// **'Lab'**
  String get mainSelectionLabTitle;

  /// Subtitle for the lab navigation button
  ///
  /// In en, this message translates to:
  /// **'Explore experimental projects'**
  String get mainSelectionLabSubtitle;

  /// Accessibility label for portfolio navigation button
  ///
  /// In en, this message translates to:
  /// **'Portfolio navigation button'**
  String get a11y_mainSelectionPortfolioButton;

  /// Accessibility hint for portfolio navigation button
  ///
  /// In en, this message translates to:
  /// **'Double tap to navigate to portfolio'**
  String get a11y_mainSelectionPortfolioButtonHint;

  /// Accessibility label for lab navigation button
  ///
  /// In en, this message translates to:
  /// **'Lab navigation button'**
  String get a11y_mainSelectionLabButton;

  /// Accessibility hint for lab navigation button
  ///
  /// In en, this message translates to:
  /// **'Double tap to navigate to lab'**
  String get a11y_mainSelectionLabButtonHint;

  /// Accessibility label for main selection screen
  ///
  /// In en, this message translates to:
  /// **'Main selection screen'**
  String get a11y_mainSelectionScreen;

  /// Accessibility hint for main selection screen
  ///
  /// In en, this message translates to:
  /// **'Choose between portfolio and lab sections'**
  String get a11y_mainSelectionScreenHint;

  /// Accessibility hint for current section
  ///
  /// In en, this message translates to:
  /// **'Current section, double tap to stay here'**
  String get a11y_currentSectionHint;

  /// Accessibility hint for navigating to section
  ///
  /// In en, this message translates to:
  /// **'Double tap to navigate to {section} section'**
  String a11y_doubleTapToNavigateToSection(String section);

  /// Accessibility value for current state
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get a11y_current;

  /// Accessibility value for not current state
  ///
  /// In en, this message translates to:
  /// **'Not current'**
  String get a11y_notCurrent;

  /// Accessibility label for header section
  ///
  /// In en, this message translates to:
  /// **'Header section'**
  String get a11y_headerSection;

  /// Accessibility label for profile picture
  ///
  /// In en, this message translates to:
  /// **'Profile picture'**
  String get a11y_profilePicture;

  /// Accessibility label for name
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get a11y_name;

  /// Accessibility label for professional title
  ///
  /// In en, this message translates to:
  /// **'Professional title'**
  String get a11y_professionalTitle;

  /// Accessibility label for professional description
  ///
  /// In en, this message translates to:
  /// **'Professional description'**
  String get a11y_professionalDescription;

  /// Accessibility label for main navigation
  ///
  /// In en, this message translates to:
  /// **'Main navigation'**
  String get a11y_mainNavigation;

  /// Accessibility label for about section
  ///
  /// In en, this message translates to:
  /// **'About section'**
  String get a11y_aboutSection;

  /// Accessibility label for section title
  ///
  /// In en, this message translates to:
  /// **'Section title'**
  String get a11y_sectionTitle;

  /// Accessibility label for about description
  ///
  /// In en, this message translates to:
  /// **'About description'**
  String get a11y_aboutDescription;

  /// Accessibility label for skills and technologies
  ///
  /// In en, this message translates to:
  /// **'Skills and technologies'**
  String get a11y_skillsAndTechnologies;

  /// Accessibility label for skill
  ///
  /// In en, this message translates to:
  /// **'{skill} skill'**
  String a11y_skillLabel(String skill);

  /// Accessibility label for skill icon
  ///
  /// In en, this message translates to:
  /// **'{skill} icon'**
  String a11y_skillIcon(String skill);

  /// Accessibility label for projects section
  ///
  /// In en, this message translates to:
  /// **'Projects section'**
  String get a11y_projectsSection;

  /// Accessibility label for project list
  ///
  /// In en, this message translates to:
  /// **'Project list'**
  String get a11y_projectList;

  /// Accessibility label for project
  ///
  /// In en, this message translates to:
  /// **'Project: {title}'**
  String a11y_projectLabel(String title);

  /// Accessibility hint for project
  ///
  /// In en, this message translates to:
  /// **'Double tap to view project details'**
  String get a11y_projectHint;

  /// Accessibility label for project icon
  ///
  /// In en, this message translates to:
  /// **'Project icon'**
  String get a11y_projectIcon;

  /// Accessibility label for project title
  ///
  /// In en, this message translates to:
  /// **'Project title'**
  String get a11y_projectTitle;

  /// Accessibility label for project description
  ///
  /// In en, this message translates to:
  /// **'Project description'**
  String get a11y_projectDescription;

  /// Accessibility label for lab section
  ///
  /// In en, this message translates to:
  /// **'Lab section'**
  String get a11y_labSection;

  /// Accessibility label for section description
  ///
  /// In en, this message translates to:
  /// **'Section description'**
  String get a11y_sectionDescription;

  /// Accessibility label for experimental projects
  ///
  /// In en, this message translates to:
  /// **'Experimental projects'**
  String get a11y_experimentalProjects;

  /// Accessibility label for experimental project
  ///
  /// In en, this message translates to:
  /// **'Experimental project: {title}'**
  String a11y_experimentalProjectLabel(String title);

  /// Accessibility hint for experimental project
  ///
  /// In en, this message translates to:
  /// **'Double tap to view experimental project details'**
  String get a11y_experimentalProjectHint;

  /// Accessibility label for experimental badge
  ///
  /// In en, this message translates to:
  /// **'Experimental badge'**
  String get a11y_experimentalBadge;

  /// Accessibility label for contact section
  ///
  /// In en, this message translates to:
  /// **'Contact section'**
  String get a11y_contactSection;

  /// Accessibility label for contact information
  ///
  /// In en, this message translates to:
  /// **'Contact information'**
  String get a11y_contactInformation;

  /// Accessibility label for contact icon
  ///
  /// In en, this message translates to:
  /// **'Contact icon'**
  String get a11y_contactIcon;

  /// Accessibility label for contact details
  ///
  /// In en, this message translates to:
  /// **'Contact details'**
  String get a11y_contactDetails;

  /// Accessibility label for social media links
  ///
  /// In en, this message translates to:
  /// **'Social media links'**
  String get a11y_socialMediaLinks;

  /// Accessibility label for social profile
  ///
  /// In en, this message translates to:
  /// **'{platform} profile'**
  String a11y_socialProfile(String platform);

  /// Accessibility hint for social profile
  ///
  /// In en, this message translates to:
  /// **'Double tap to visit {platform} profile'**
  String a11y_socialProfileHint(String platform);

  /// No description provided for @projectDemoHelloWorld.
  ///
  /// In en, this message translates to:
  /// **'Hello world'**
  String get projectDemoHelloWorld;

  /// No description provided for @projectDemoAvailableOnTabletOrDesktop.
  ///
  /// In en, this message translates to:
  /// **'Demo available in tablet or desktop device'**
  String get projectDemoAvailableOnTabletOrDesktop;

  /// No description provided for @projectKnowMore.
  ///
  /// In en, this message translates to:
  /// **'Know More'**
  String get projectKnowMore;

  /// Credit text showing who created the application
  ///
  /// In en, this message translates to:
  /// **'Created by Camilo Santacruz'**
  String get createdBy;

  /// GetX skill name
  ///
  /// In en, this message translates to:
  /// **'GetX'**
  String get skillGetX;

  /// Bloc skill name
  ///
  /// In en, this message translates to:
  /// **'Bloc'**
  String get skillBloc;

  /// Flutter Web skill name
  ///
  /// In en, this message translates to:
  /// **'Flutter Web'**
  String get skillFlutterWeb;

  /// Title for Flutter technologies section
  ///
  /// In en, this message translates to:
  /// **'Flutter & Dart Technologies'**
  String get flutterTechnologies;

  /// Category title for state management technologies
  ///
  /// In en, this message translates to:
  /// **'State Management'**
  String get stateManagement;

  /// Category title for code generation technologies
  ///
  /// In en, this message translates to:
  /// **'Code Generation'**
  String get codeGeneration;

  /// Category title for native integration technologies
  ///
  /// In en, this message translates to:
  /// **'Native Integration'**
  String get nativeIntegration;

  /// Category title for database technologies
  ///
  /// In en, this message translates to:
  /// **'Databases'**
  String get databases;

  /// Category title for analytics and monitoring technologies
  ///
  /// In en, this message translates to:
  /// **'Analytics & Monitoring'**
  String get analyticsMonitoring;

  /// Category title for development tools
  ///
  /// In en, this message translates to:
  /// **'Development Tools'**
  String get developmentTools;

  /// Label for project management in page structure dialog
  ///
  /// In en, this message translates to:
  /// **'Project Management'**
  String get projectManagement;

  /// Tooltip text for 1 year or less experience
  ///
  /// In en, this message translates to:
  /// **'1 year or less of experience'**
  String get experienceTooltipOneYear;

  /// Tooltip text for years of experience
  ///
  /// In en, this message translates to:
  /// **'{years}+ years of experience'**
  String experienceTooltipYears(String years);

  /// Text indicating a skill is currently being used
  ///
  /// In en, this message translates to:
  /// **'Currently using'**
  String get skillTooltipCurrentlyUsing;

  /// Text indicating a skill can be clicked to expand
  ///
  /// In en, this message translates to:
  /// **'Click to expand'**
  String get skillTooltipClickToExpand;

  /// Text showing years of experience
  ///
  /// In en, this message translates to:
  /// **'{years} years'**
  String skillTooltipYears(String years);

  /// Button text for downloading the resume in the Resume section.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get resumeDownload;

  /// Title for the resume section.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get resumeSectionTitle;

  /// Description for the resume section.
  ///
  /// In en, this message translates to:
  /// **'Download my latest resume. If you want to know more about my experience, this is the place!'**
  String get resumeSectionDescription;

  /// Label for last updated date of the resume file.
  ///
  /// In en, this message translates to:
  /// **'Last updated: {date}'**
  String resumeLastUpdated(String date);

  /// No description provided for @seasonTab.
  ///
  /// In en, this message translates to:
  /// **'Season'**
  String get seasonTab;

  /// No description provided for @communityTab.
  ///
  /// In en, this message translates to:
  /// **'Community'**
  String get communityTab;

  /// No description provided for @profileTab.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTab;

  /// No description provided for @communityTitle.
  ///
  /// In en, this message translates to:
  /// **'Weekly Leaderboard'**
  String get communityTitle;

  /// No description provided for @weeklyTab.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get weeklyTab;

  /// No description provided for @globalTab.
  ///
  /// In en, this message translates to:
  /// **'Global'**
  String get globalTab;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profileLevelAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Level: Advanced'**
  String get profileLevelAdvanced;

  /// No description provided for @profileRecommendations.
  ///
  /// In en, this message translates to:
  /// **'Recommendations'**
  String get profileRecommendations;

  /// No description provided for @profilePerformance.
  ///
  /// In en, this message translates to:
  /// **'Performance'**
  String get profilePerformance;

  /// No description provided for @profileAchievements.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get profileAchievements;

  /// No description provided for @profileExternalReport.
  ///
  /// In en, this message translates to:
  /// **'External Evaluation Report'**
  String get profileExternalReport;

  /// No description provided for @todayLabel.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get todayLabel;

  /// No description provided for @preEmotionalLabel.
  ///
  /// In en, this message translates to:
  /// **'Emotional Pre'**
  String get preEmotionalLabel;

  /// No description provided for @planLabel.
  ///
  /// In en, this message translates to:
  /// **'Plan'**
  String get planLabel;

  /// No description provided for @matchLabel.
  ///
  /// In en, this message translates to:
  /// **'Match'**
  String get matchLabel;

  /// No description provided for @postEmotionalLabel.
  ///
  /// In en, this message translates to:
  /// **'Emotional Post'**
  String get postEmotionalLabel;

  /// No description provided for @selfEvaluationLabel.
  ///
  /// In en, this message translates to:
  /// **'Self-evaluation'**
  String get selfEvaluationLabel;

  /// No description provided for @popupPastWeekTitle.
  ///
  /// In en, this message translates to:
  /// **'Date finished'**
  String get popupPastWeekTitle;

  /// No description provided for @popupPastWeekContent.
  ///
  /// In en, this message translates to:
  /// **'This date has finished, check your progress in your profile.'**
  String get popupPastWeekContent;

  /// No description provided for @popupCurrentWeekTitle.
  ///
  /// In en, this message translates to:
  /// **'Not available'**
  String get popupCurrentWeekTitle;

  /// No description provided for @popupCurrentWeekContent.
  ///
  /// In en, this message translates to:
  /// **'This flag will be available {when}'**
  String popupCurrentWeekContent(Object when);

  /// No description provided for @popupFutureWeekTitle.
  ///
  /// In en, this message translates to:
  /// **'Not available'**
  String get popupFutureWeekTitle;

  /// No description provided for @popupFutureWeekContent.
  ///
  /// In en, this message translates to:
  /// **'This task will be activated in {weeks} weeks.'**
  String popupFutureWeekContent(Object weeks);

  /// No description provided for @popupFutureWeekContentSpecial.
  ///
  /// In en, this message translates to:
  /// **'This task will be activated {when}.'**
  String popupFutureWeekContentSpecial(Object when);

  /// No description provided for @popupTaskCompleted.
  ///
  /// In en, this message translates to:
  /// **'Huray! Task completed'**
  String get popupTaskCompleted;

  /// No description provided for @popupNewTaskAssigned.
  ///
  /// In en, this message translates to:
  /// **'New task assigned'**
  String get popupNewTaskAssigned;

  /// No description provided for @popupDribblingQuestion.
  ///
  /// In en, this message translates to:
  /// **'Task: How do you rate your dribbling in the last match?'**
  String get popupDribblingQuestion;

  /// No description provided for @popupPassingQuestion.
  ///
  /// In en, this message translates to:
  /// **'Task: How do you rate your passing in the last match?'**
  String get popupPassingQuestion;

  /// No description provided for @popupTomorrow.
  ///
  /// In en, this message translates to:
  /// **'tomorrow'**
  String get popupTomorrow;

  /// No description provided for @popupInXDays.
  ///
  /// In en, this message translates to:
  /// **'in {days} days'**
  String popupInXDays(Object days);

  /// No description provided for @popupNextWeek.
  ///
  /// In en, this message translates to:
  /// **'next week'**
  String get popupNextWeek;

  /// No description provided for @popupLastWeek.
  ///
  /// In en, this message translates to:
  /// **'last week'**
  String get popupLastWeek;

  /// No description provided for @popupInXWeeks.
  ///
  /// In en, this message translates to:
  /// **'in {weeks} weeks'**
  String popupInXWeeks(Object weeks);

  /// No description provided for @popupYesterday.
  ///
  /// In en, this message translates to:
  /// **'yesterday'**
  String get popupYesterday;

  /// No description provided for @preEmotionalLabelShort.
  ///
  /// In en, this message translates to:
  /// **'Pre'**
  String get preEmotionalLabelShort;

  /// No description provided for @planLabelShort.
  ///
  /// In en, this message translates to:
  /// **'Plan'**
  String get planLabelShort;

  /// No description provided for @matchLabelShort.
  ///
  /// In en, this message translates to:
  /// **'Match'**
  String get matchLabelShort;

  /// No description provided for @postEmotionalLabelShort.
  ///
  /// In en, this message translates to:
  /// **'Post'**
  String get postEmotionalLabelShort;

  /// No description provided for @selfEvaluationLabelShort.
  ///
  /// In en, this message translates to:
  /// **'Self'**
  String get selfEvaluationLabelShort;

  /// No description provided for @week1Label.
  ///
  /// In en, this message translates to:
  /// **'Week 1'**
  String get week1Label;

  /// No description provided for @week2Label.
  ///
  /// In en, this message translates to:
  /// **'Week 2'**
  String get week2Label;

  /// No description provided for @week3Label.
  ///
  /// In en, this message translates to:
  /// **'Week 3'**
  String get week3Label;

  /// No description provided for @week4Label.
  ///
  /// In en, this message translates to:
  /// **'Week 4'**
  String get week4Label;

  /// No description provided for @week5Label.
  ///
  /// In en, this message translates to:
  /// **'Week 5'**
  String get week5Label;

  /// No description provided for @b4sDemoTitle.
  ///
  /// In en, this message translates to:
  /// **'Brain4Goals Demo'**
  String get b4sDemoTitle;

  /// No description provided for @b4sDemoTapToStart.
  ///
  /// In en, this message translates to:
  /// **'Tap to start the demo'**
  String get b4sDemoTapToStart;

  /// No description provided for @b4sSplashTitle.
  ///
  /// In en, this message translates to:
  /// **'Brain4Goals'**
  String get b4sSplashTitle;

  /// No description provided for @b4sSplashSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your season, your success'**
  String get b4sSplashSubtitle;

  /// No description provided for @fieldScreenPrepareTitle.
  ///
  /// In en, this message translates to:
  /// **'Get ready\nfor the match!'**
  String get fieldScreenPrepareTitle;

  /// No description provided for @fieldScreenPrepareSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Prepare your mind and body for the upcoming match.'**
  String get fieldScreenPrepareSubtitle;

  /// No description provided for @communityWeeklyTitle.
  ///
  /// In en, this message translates to:
  /// **'Weekly Leaderboard'**
  String get communityWeeklyTitle;

  /// No description provided for @communityTabWeekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get communityTabWeekly;

  /// No description provided for @communityTabGlobal.
  ///
  /// In en, this message translates to:
  /// **'Global'**
  String get communityTabGlobal;

  /// No description provided for @communityFilterStage.
  ///
  /// In en, this message translates to:
  /// **'Stage'**
  String get communityFilterStage;

  /// No description provided for @communityFilterCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get communityFilterCategory;

  /// No description provided for @communityFilterGender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get communityFilterGender;

  /// No description provided for @communityFilterOptionBenjamin.
  ///
  /// In en, this message translates to:
  /// **'Benjamin'**
  String get communityFilterOptionBenjamin;

  /// No description provided for @communityFilterOptionAlevin.
  ///
  /// In en, this message translates to:
  /// **'Alevin'**
  String get communityFilterOptionAlevin;

  /// No description provided for @communityFilterOptionCadete.
  ///
  /// In en, this message translates to:
  /// **'Cadet'**
  String get communityFilterOptionCadete;

  /// No description provided for @communityFilterOptionInfantil.
  ///
  /// In en, this message translates to:
  /// **'Infant'**
  String get communityFilterOptionInfantil;

  /// No description provided for @communityFilterOptionJuvenil.
  ///
  /// In en, this message translates to:
  /// **'Youth'**
  String get communityFilterOptionJuvenil;

  /// No description provided for @communityFilterOptionAmateur.
  ///
  /// In en, this message translates to:
  /// **'Amateur'**
  String get communityFilterOptionAmateur;

  /// No description provided for @communityFilterOptionAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get communityFilterOptionAll;

  /// No description provided for @communityFilterOptionNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get communityFilterOptionNone;

  /// No description provided for @communityFilterOptionA.
  ///
  /// In en, this message translates to:
  /// **'A'**
  String get communityFilterOptionA;

  /// No description provided for @communityFilterOptionB.
  ///
  /// In en, this message translates to:
  /// **'B'**
  String get communityFilterOptionB;

  /// No description provided for @communityFilterOptionC.
  ///
  /// In en, this message translates to:
  /// **'C'**
  String get communityFilterOptionC;

  /// No description provided for @communityFilterOptionMixed.
  ///
  /// In en, this message translates to:
  /// **'Mixed'**
  String get communityFilterOptionMixed;

  /// No description provided for @communityFilterOptionM.
  ///
  /// In en, this message translates to:
  /// **'M'**
  String get communityFilterOptionM;

  /// No description provided for @communityFilterOptionF.
  ///
  /// In en, this message translates to:
  /// **'F'**
  String get communityFilterOptionF;

  /// No description provided for @communityLeagueBronze.
  ///
  /// In en, this message translates to:
  /// **'Bronze'**
  String get communityLeagueBronze;

  /// No description provided for @communityLeagueSilver.
  ///
  /// In en, this message translates to:
  /// **'Silver'**
  String get communityLeagueSilver;

  /// No description provided for @communityLeagueGold.
  ///
  /// In en, this message translates to:
  /// **'Gold'**
  String get communityLeagueGold;

  /// No description provided for @communityLeagueInfo.
  ///
  /// In en, this message translates to:
  /// **'Top 3 at the end of the week advance to the next league'**
  String get communityLeagueInfo;

  /// No description provided for @communityLeagueLabel.
  ///
  /// In en, this message translates to:
  /// **'League {league}'**
  String communityLeagueLabel(Object league);

  /// No description provided for @communityLeaderboardHeaderNumber.
  ///
  /// In en, this message translates to:
  /// **'#'**
  String get communityLeaderboardHeaderNumber;

  /// No description provided for @communityLeaderboardHeaderAthlete.
  ///
  /// In en, this message translates to:
  /// **'Athlete'**
  String get communityLeaderboardHeaderAthlete;

  /// No description provided for @communityLeaderboardHeaderPoints.
  ///
  /// In en, this message translates to:
  /// **'Points'**
  String get communityLeaderboardHeaderPoints;

  /// No description provided for @communityNoUsersFilters.
  ///
  /// In en, this message translates to:
  /// **'No users found for the selected filters.'**
  String get communityNoUsersFilters;

  /// No description provided for @communityNoUsersGlobal.
  ///
  /// In en, this message translates to:
  /// **'No users found for the global leaderboard.'**
  String get communityNoUsersGlobal;

  /// No description provided for @communityCurrentUser.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get communityCurrentUser;

  /// No description provided for @profileAdviceButton.
  ///
  /// In en, this message translates to:
  /// **'ADVICE'**
  String get profileAdviceButton;

  /// No description provided for @profileActionPerformance.
  ///
  /// In en, this message translates to:
  /// **'Performance'**
  String get profileActionPerformance;

  /// No description provided for @profileActionAchievements.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get profileActionAchievements;

  /// No description provided for @profileActionExternalReport.
  ///
  /// In en, this message translates to:
  /// **'External Evaluation Report'**
  String get profileActionExternalReport;

  /// No description provided for @profilePopupTitle.
  ///
  /// In en, this message translates to:
  /// **'Feature unavailable'**
  String get profilePopupTitle;

  /// No description provided for @profilePopupContent.
  ///
  /// In en, this message translates to:
  /// **'This demo does not support this feature.'**
  String get profilePopupContent;

  /// No description provided for @profilePopupOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get profilePopupOk;

  /// No description provided for @profileMonthlyAverage.
  ///
  /// In en, this message translates to:
  /// **'Player\'s monthly average'**
  String get profileMonthlyAverage;

  /// No description provided for @profileStatPsychological.
  ///
  /// In en, this message translates to:
  /// **'Psychological'**
  String get profileStatPsychological;

  /// No description provided for @profileStatTechnical.
  ///
  /// In en, this message translates to:
  /// **'Technical'**
  String get profileStatTechnical;

  /// No description provided for @profileStatTactical.
  ///
  /// In en, this message translates to:
  /// **'Tactical'**
  String get profileStatTactical;

  /// No description provided for @profileStatPhysical.
  ///
  /// In en, this message translates to:
  /// **'Physical'**
  String get profileStatPhysical;

  /// No description provided for @profileGridStreak.
  ///
  /// In en, this message translates to:
  /// **'Streak'**
  String get profileGridStreak;

  /// No description provided for @profileGridExp.
  ///
  /// In en, this message translates to:
  /// **'EXP'**
  String get profileGridExp;

  /// No description provided for @profileGridGold.
  ///
  /// In en, this message translates to:
  /// **'GOLD'**
  String get profileGridGold;

  /// No description provided for @profileGridDivision.
  ///
  /// In en, this message translates to:
  /// **'Division'**
  String get profileGridDivision;

  /// No description provided for @profileGridBadges.
  ///
  /// In en, this message translates to:
  /// **'Badges'**
  String get profileGridBadges;

  /// No description provided for @profileCardPlayerName.
  ///
  /// In en, this message translates to:
  /// **'Player Name'**
  String get profileCardPlayerName;

  /// No description provided for @profileCardPosition.
  ///
  /// In en, this message translates to:
  /// **'Position'**
  String get profileCardPosition;

  /// No description provided for @profileCardStage.
  ///
  /// In en, this message translates to:
  /// **'Stage'**
  String get profileCardStage;

  /// No description provided for @profileCardLeaderStrategic.
  ///
  /// In en, this message translates to:
  /// **'Leader: Strategic'**
  String get profileCardLeaderStrategic;

  /// No description provided for @popupTaskCompletedTitle.
  ///
  /// In en, this message translates to:
  /// **'Huray!'**
  String get popupTaskCompletedTitle;

  /// No description provided for @popupOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get popupOk;

  /// No description provided for @popupCenterFlagInfo.
  ///
  /// In en, this message translates to:
  /// **'This flag will be active on Friday and the weekend.'**
  String get popupCenterFlagInfo;

  /// No description provided for @dayShortMon.
  ///
  /// In en, this message translates to:
  /// **'M'**
  String get dayShortMon;

  /// No description provided for @dayShortTue.
  ///
  /// In en, this message translates to:
  /// **'T'**
  String get dayShortTue;

  /// No description provided for @dayShortWed.
  ///
  /// In en, this message translates to:
  /// **'W'**
  String get dayShortWed;

  /// No description provided for @dayShortThu.
  ///
  /// In en, this message translates to:
  /// **'T'**
  String get dayShortThu;

  /// No description provided for @dayShortFri.
  ///
  /// In en, this message translates to:
  /// **'F'**
  String get dayShortFri;

  /// No description provided for @dayLongMon.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get dayLongMon;

  /// No description provided for @dayLongTue.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get dayLongTue;

  /// No description provided for @dayLongWed.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get dayLongWed;

  /// No description provided for @dayLongThu.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get dayLongThu;

  /// No description provided for @dayLongFri.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get dayLongFri;

  /// Label for the header section in page structure dialog
  ///
  /// In en, this message translates to:
  /// **'Header Section'**
  String get headerSection;

  /// Label for navigation menu in page structure dialog
  ///
  /// In en, this message translates to:
  /// **'Navigation Menu'**
  String get navigationMenu;

  /// Label for profile picture in page structure dialog
  ///
  /// In en, this message translates to:
  /// **'Profile Picture'**
  String get profilePicture;

  /// Label for name in page structure dialog
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameTitle;

  /// Label for professional title in page structure dialog
  ///
  /// In en, this message translates to:
  /// **'Professional Title'**
  String get professionalTitle;

  /// Label for professional description in page structure dialog
  ///
  /// In en, this message translates to:
  /// **'Professional Description'**
  String get professionalDescription;

  /// Label for about section in page structure dialog
  ///
  /// In en, this message translates to:
  /// **'About Section'**
  String get aboutSection;

  /// Label for about title in page structure dialog
  ///
  /// In en, this message translates to:
  /// **'About Title'**
  String get aboutTitleLabel;

  /// Label for about description in page structure dialog
  ///
  /// In en, this message translates to:
  /// **'About Description'**
  String get aboutDescriptionLabel;

  /// Label for about subtitle in page structure dialog
  ///
  /// In en, this message translates to:
  /// **'About Subtitle'**
  String get aboutSubtitleLabel;

  /// Label for skills section in page structure dialog
  ///
  /// In en, this message translates to:
  /// **'Skills Section'**
  String get skillsSection;

  /// Label for skills title in page structure dialog
  ///
  /// In en, this message translates to:
  /// **'Skills Title'**
  String get skillsTitleLabel;

  /// Label for skills description in page structure dialog
  ///
  /// In en, this message translates to:
  /// **'Skills Description'**
  String get skillsDescriptionLabel;

  /// Label for programming languages in page structure dialog
  ///
  /// In en, this message translates to:
  /// **'Programming Languages'**
  String get programmingLanguages;

  /// Label for design & animation in page structure dialog
  ///
  /// In en, this message translates to:
  /// **'Design & Animation'**
  String get designAnimation;

  /// Label for editors & tools in page structure dialog
  ///
  /// In en, this message translates to:
  /// **'Editors & Tools'**
  String get editorsTools;

  /// Label for devops & ci/cd in page structure dialog
  ///
  /// In en, this message translates to:
  /// **'DevOps & CI/CD'**
  String get devopsCICD;

  /// Label for resume section in page structure dialog
  ///
  /// In en, this message translates to:
  /// **'Resume Section'**
  String get resumeSection;

  /// Label for resume title in page structure dialog
  ///
  /// In en, this message translates to:
  /// **'Resume Title'**
  String get resumeTitleLabel;

  /// Label for resume description in page structure dialog
  ///
  /// In en, this message translates to:
  /// **'Resume Description'**
  String get resumeDescriptionLabel;

  /// Label for download resume button in page structure dialog
  ///
  /// In en, this message translates to:
  /// **'Download Resume Button'**
  String get downloadResumeButton;

  /// Label for last updated in page structure dialog
  ///
  /// In en, this message translates to:
  /// **'Last Updated'**
  String get lastUpdated;

  /// Label for projects section in page structure dialog
  ///
  /// In en, this message translates to:
  /// **'Projects Section'**
  String get projectsSection;

  /// Label for projects title in page structure dialog
  ///
  /// In en, this message translates to:
  /// **'Projects Title'**
  String get projectsTitleLabel;

  /// Label for projects description in page structure dialog
  ///
  /// In en, this message translates to:
  /// **'Projects Description'**
  String get projectsDescriptionLabel;

  /// Label for contact section in page structure dialog
  ///
  /// In en, this message translates to:
  /// **'Contact Section'**
  String get contactSection;

  /// Label for contact title in page structure dialog
  ///
  /// In en, this message translates to:
  /// **'Contact Title'**
  String get contactTitleLabel;

  /// Label for contact description in page structure dialog
  ///
  /// In en, this message translates to:
  /// **'Contact Description'**
  String get contactDescriptionLabel;

  /// Label for contact information in page structure dialog
  ///
  /// In en, this message translates to:
  /// **'Contact Information'**
  String get contactInfo;

  /// Label for social links in page structure dialog
  ///
  /// In en, this message translates to:
  /// **'Social Links'**
  String get socialLinks;

  /// Label for B4S project in page structure dialog
  ///
  /// In en, this message translates to:
  /// **'Brain4Goals App'**
  String get projectB4S;

  /// Label for e-commerce project in page structure dialog
  ///
  /// In en, this message translates to:
  /// **'E-commerce Platform'**
  String get projectEcommerce;

  /// Label for social media project in page structure dialog
  ///
  /// In en, this message translates to:
  /// **'Social Media App'**
  String get projectSocial;

  /// Label for weather project in page structure dialog
  ///
  /// In en, this message translates to:
  /// **'Weather Forecast'**
  String get projectWeather;

  /// Label for music player project in page structure dialog
  ///
  /// In en, this message translates to:
  /// **'Music Player'**
  String get projectMusic;

  /// Label for task manager project in page structure dialog
  ///
  /// In en, this message translates to:
  /// **'Task Manager'**
  String get projectTask;

  /// Label for fitness tracker project in page structure dialog
  ///
  /// In en, this message translates to:
  /// **'Fitness Tracker'**
  String get projectFitness;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'es', 'ja'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
    case 'ja': return AppLocalizationsJa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
