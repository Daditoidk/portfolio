// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Portfolio';

  @override
  String get headerName => 'Your Name';

  @override
  String get headerTitle => 'Flutter Developer';

  @override
  String get headerSubtitle => 'Creating beautiful mobile experiences';

  @override
  String get aboutTitle => 'About Me';

  @override
  String get aboutDescription => 'I am a passionate Flutter developer with experience in creating beautiful and functional mobile applications. I love turning ideas into reality through clean code and intuitive user interfaces.';

  @override
  String get aboutSubtitle => 'Passionate developer with experience in Flutter, Dart, and web technologies.';

  @override
  String get aboutSkills => 'Flutter, Dart, JavaScript, HTML, CSS, Firebase, REST APIs, Git, UI/UX Design';

  @override
  String get skillFlutter => 'Flutter';

  @override
  String get skillDart => 'Dart';

  @override
  String get skillFirebase => 'Firebase';

  @override
  String get projectsTitle => 'My Projects';

  @override
  String get projectsSubtitle => 'A selection of my recent projects.';

  @override
  String get projectEcommerceTitle => 'E-Commerce App';

  @override
  String get projectEcommerceDescription => 'A full-featured mobile shopping app with payment integration';

  @override
  String get projectTaskManagerTitle => 'Task Manager';

  @override
  String get projectTaskManagerDescription => 'Simple and intuitive task management application';

  @override
  String get projectWeatherTitle => 'Weather App';

  @override
  String get projectWeatherDescription => 'Real-time weather updates with beautiful UI';

  @override
  String get labTitle => 'Lab';

  @override
  String get labSubtitle => 'Experimental projects and creative experiments';

  @override
  String get labAIChatTitle => 'AI Chat Bot';

  @override
  String get labAIChatDescription => 'Experimental chatbot using machine learning';

  @override
  String get labARTitle => 'AR Experience';

  @override
  String get labARDescription => 'Augmented reality prototype for mobile';

  @override
  String get labVoiceTitle => 'Voice Assistant';

  @override
  String get labVoiceDescription => 'Voice-controlled app interface';

  @override
  String get experimentalBadge => 'Experimental';

  @override
  String get contactTitle => 'Get In Touch';

  @override
  String get contactSubtitle => 'Let\'s work together on your next project';

  @override
  String get contactEmail => 'email@example.com';

  @override
  String get contactPhone => '+1 234 567 890';

  @override
  String get contactLocation => 'Your City, Country';

  @override
  String get navHome => 'Home';

  @override
  String get navAbout => 'About';

  @override
  String get navProjects => 'Projects';

  @override
  String get navLab => 'Lab';

  @override
  String get navContact => 'Contact';

  @override
  String get a11yLanguageSwitcher => 'Language switcher';

  @override
  String get a11yLanguageSwitcherHint => 'Double tap to change language';

  @override
  String get a11ySwitchToEnglish => 'Switch to English';

  @override
  String get a11yCurrentlySelectedLanguage => 'Currently selected language';

  @override
  String get a11yDoubleTapToSwitchToEnglish => 'Double tap to switch to English';

  @override
  String get a11ySelected => 'Selected';

  @override
  String get a11yNotSelected => 'Not selected';

  @override
  String get a11yAmericanFlag => 'American flag';

  @override
  String get a11y_navigationMenu => 'Navigation menu';

  @override
  String get a11y_navigationMenuHint => 'Use to navigate between sections';

  @override
  String get a11y_portfolioTitle => 'Portfolio title';

  @override
  String get a11y_navigationLinks => 'Navigation links';

  @override
  String get mainSelectionWelcome => 'Welcome';

  @override
  String get mainSelectionSubtitle => 'Choose your destination';

  @override
  String get mainSelectionPortfolioTitle => 'Portfolio';

  @override
  String get mainSelectionPortfolioSubtitle => 'View my projects and experience';

  @override
  String get mainSelectionLabTitle => 'Lab';

  @override
  String get mainSelectionLabSubtitle => 'Explore experimental projects';

  @override
  String get a11y_mainSelectionPortfolioButton => 'Portfolio navigation button';

  @override
  String get a11y_mainSelectionPortfolioButtonHint => 'Double tap to navigate to portfolio';

  @override
  String get a11y_mainSelectionLabButton => 'Lab navigation button';

  @override
  String get a11y_mainSelectionLabButtonHint => 'Double tap to navigate to lab';

  @override
  String get a11y_mainSelectionScreen => 'Main selection screen';

  @override
  String get a11y_mainSelectionScreenHint => 'Choose between portfolio and lab sections';

  @override
  String get a11y_currentSectionHint => 'Current section, double tap to stay here';

  @override
  String a11y_doubleTapToNavigateToSection(String section) {
    return 'Double tap to navigate to $section section';
  }

  @override
  String get a11y_current => 'Current';

  @override
  String get a11y_notCurrent => 'Not current';

  @override
  String get a11y_headerSection => 'Header section';

  @override
  String get a11y_profilePicture => 'Profile picture';

  @override
  String get a11y_name => 'Name';

  @override
  String get a11y_professionalTitle => 'Professional title';

  @override
  String get a11y_professionalDescription => 'Professional description';

  @override
  String get a11y_mainNavigation => 'Main navigation';

  @override
  String get a11y_aboutSection => 'About section';

  @override
  String get a11y_sectionTitle => 'Section title';

  @override
  String get a11y_aboutDescription => 'About description';

  @override
  String get a11y_skillsAndTechnologies => 'Skills and technologies';

  @override
  String a11y_skillLabel(String skill) {
    return '$skill skill';
  }

  @override
  String a11y_skillIcon(String skill) {
    return '$skill icon';
  }

  @override
  String get a11y_projectsSection => 'Projects section';

  @override
  String get a11y_projectList => 'Project list';

  @override
  String a11y_projectLabel(String title) {
    return 'Project: $title';
  }

  @override
  String get a11y_projectHint => 'Double tap to view project details';

  @override
  String get a11y_projectIcon => 'Project icon';

  @override
  String get a11y_projectTitle => 'Project title';

  @override
  String get a11y_projectDescription => 'Project description';

  @override
  String get a11y_labSection => 'Lab section';

  @override
  String get a11y_sectionDescription => 'Section description';

  @override
  String get a11y_experimentalProjects => 'Experimental projects';

  @override
  String a11y_experimentalProjectLabel(String title) {
    return 'Experimental project: $title';
  }

  @override
  String get a11y_experimentalProjectHint => 'Double tap to view experimental project details';

  @override
  String get a11y_experimentalBadge => 'Experimental badge';

  @override
  String get a11y_contactSection => 'Contact section';

  @override
  String get a11y_contactInformation => 'Contact information';

  @override
  String get a11y_contactIcon => 'Contact icon';

  @override
  String get a11y_contactDetails => 'Contact details';

  @override
  String get a11y_socialMediaLinks => 'Social media links';

  @override
  String a11y_socialProfile(String platform) {
    return '$platform profile';
  }

  @override
  String a11y_socialProfileHint(String platform) {
    return 'Double tap to visit $platform profile';
  }

  @override
  String get projectDemoHelloWorld => 'Hello world';

  @override
  String get projectDemoAvailableOnTabletOrDesktop => 'Demo available in tablet or desktop device';

  @override
  String get projectKnowMore => 'Know More';
}
