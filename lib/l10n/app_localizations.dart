import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

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
    Locale('fr')
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Ceremo'**
  String get appTitle;

  /// Welcome message
  ///
  /// In en, this message translates to:
  /// **'Welcome to Ceremo'**
  String get welcome;

  /// Subtitle for login screen
  ///
  /// In en, this message translates to:
  /// **'Sign in to manage your ceremonies'**
  String get signInToManage;

  /// Email field label
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Email field placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterEmail;

  /// Password field label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Password field placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterPassword;

  /// Sign in button text
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// Text before sign up link
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get dontHaveAccount;

  /// Sign up link text
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// Create account button text
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// Sign up screen subtitle
  ///
  /// In en, this message translates to:
  /// **'Join Ceremo to start managing your ceremonies'**
  String get joinCeremo;

  /// Full name field label
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// Full name field placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get enterFullName;

  /// Confirm password field label
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// Confirm password field placeholder
  ///
  /// In en, this message translates to:
  /// **'Confirm your password'**
  String get confirmYourPassword;

  /// Country field label
  ///
  /// In en, this message translates to:
  /// **'Country (Optional)'**
  String get country;

  /// Currency field label
  ///
  /// In en, this message translates to:
  /// **'Currency (Optional)'**
  String get currency;

  /// Text before sign in link
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccount;

  /// Dashboard welcome message
  ///
  /// In en, this message translates to:
  /// **'Welcome back!'**
  String get welcomeBack;

  /// Quick actions section title
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// New project action
  ///
  /// In en, this message translates to:
  /// **'New Project'**
  String get newProject;

  /// New project description
  ///
  /// In en, this message translates to:
  /// **'Start a new ceremony project'**
  String get startNewCeremony;

  /// My projects action
  ///
  /// In en, this message translates to:
  /// **'My Projects'**
  String get myProjects;

  /// My projects description
  ///
  /// In en, this message translates to:
  /// **'View all your projects'**
  String get viewAllProjects;

  /// Organizations action
  ///
  /// In en, this message translates to:
  /// **'Organizations'**
  String get organizations;

  /// Organizations description
  ///
  /// In en, this message translates to:
  /// **'Manage your organizations'**
  String get manageOrganizations;

  /// Reports action
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reports;

  /// Reports description
  ///
  /// In en, this message translates to:
  /// **'View analytics'**
  String get viewAnalytics;

  /// Recent activity section title
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get recentActivity;

  /// No activity message
  ///
  /// In en, this message translates to:
  /// **'No recent activity'**
  String get noRecentActivity;

  /// No activity description
  ///
  /// In en, this message translates to:
  /// **'Start by creating your first project'**
  String get startFirstProject;

  /// Profile menu item
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// Settings menu item
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Logout menu item
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// Loading screen message
  ///
  /// In en, this message translates to:
  /// **'Initializing Ceremo...'**
  String get initializingCeremo;

  /// Login success message
  ///
  /// In en, this message translates to:
  /// **'Login successful!'**
  String get loginSuccessful;

  /// Registration success message
  ///
  /// In en, this message translates to:
  /// **'Account created successfully!'**
  String get accountCreatedSuccessfully;

  /// Login error message
  ///
  /// In en, this message translates to:
  /// **'Login failed'**
  String get loginFailed;

  /// Registration error message
  ///
  /// In en, this message translates to:
  /// **'Registration failed'**
  String get registrationFailed;

  /// Email validation error
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get pleaseEnterEmail;

  /// Email format validation error
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get pleaseEnterValidEmail;

  /// Password validation error
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get pleaseEnterPassword;

  /// Password length validation error
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordMinLength;

  /// Name validation error
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get pleaseEnterName;

  /// Name length validation error
  ///
  /// In en, this message translates to:
  /// **'Name must be at least 2 characters'**
  String get nameMinLength;

  /// Confirm password validation error
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get pleaseConfirmPassword;

  /// Password confirmation validation error
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// Light theme option
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// Dark theme option
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// System theme option
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @createProject.
  ///
  /// In en, this message translates to:
  /// **'Create Project'**
  String get createProject;

  /// No description provided for @projectName.
  ///
  /// In en, this message translates to:
  /// **'Project Name'**
  String get projectName;

  /// No description provided for @enterProjectName.
  ///
  /// In en, this message translates to:
  /// **'Enter project name'**
  String get enterProjectName;

  /// No description provided for @projectDescription.
  ///
  /// In en, this message translates to:
  /// **'Project Description'**
  String get projectDescription;

  /// No description provided for @enterProjectDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter project description'**
  String get enterProjectDescription;

  /// No description provided for @projectType.
  ///
  /// In en, this message translates to:
  /// **'Project Type'**
  String get projectType;

  /// No description provided for @targetAmount.
  ///
  /// In en, this message translates to:
  /// **'Target Amount'**
  String get targetAmount;

  /// No description provided for @enterTargetAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter target amount'**
  String get enterTargetAmount;

  /// No description provided for @pleaseEnterProjectName.
  ///
  /// In en, this message translates to:
  /// **'Please enter project name'**
  String get pleaseEnterProjectName;

  /// No description provided for @projectNameMinLength.
  ///
  /// In en, this message translates to:
  /// **'Project name must be at least 3 characters'**
  String get projectNameMinLength;

  /// No description provided for @pleaseEnterValidAmount.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid amount'**
  String get pleaseEnterValidAmount;

  /// No description provided for @projectCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Project created successfully!'**
  String get projectCreatedSuccessfully;

  /// No description provided for @projectCreationFailed.
  ///
  /// In en, this message translates to:
  /// **'Project creation failed. Please try again.'**
  String get projectCreationFailed;

  /// No description provided for @projectDetails.
  ///
  /// In en, this message translates to:
  /// **'Project Details'**
  String get projectDetails;

  /// No description provided for @progress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get progress;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @paused.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get paused;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// No description provided for @target.
  ///
  /// In en, this message translates to:
  /// **'Target'**
  String get target;

  /// No description provided for @currentBalance.
  ///
  /// In en, this message translates to:
  /// **'Current Balance'**
  String get currentBalance;

  /// No description provided for @financialInfo.
  ///
  /// In en, this message translates to:
  /// **'Financial Information'**
  String get financialInfo;

  /// No description provided for @projectInfo.
  ///
  /// In en, this message translates to:
  /// **'Project Information'**
  String get projectInfo;

  /// No description provided for @createdAt.
  ///
  /// In en, this message translates to:
  /// **'Created At'**
  String get createdAt;

  /// No description provided for @updatedAt.
  ///
  /// In en, this message translates to:
  /// **'Updated At'**
  String get updatedAt;

  /// No description provided for @notAvailable.
  ///
  /// In en, this message translates to:
  /// **'Not Available'**
  String get notAvailable;

  /// No description provided for @noProjects.
  ///
  /// In en, this message translates to:
  /// **'No projects yet'**
  String get noProjects;

  /// No description provided for @createFirstProject.
  ///
  /// In en, this message translates to:
  /// **'Create your first project to get started'**
  String get createFirstProject;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @projectNotFound.
  ///
  /// In en, this message translates to:
  /// **'Project not found'**
  String get projectNotFound;

  /// No description provided for @noOrganizations.
  ///
  /// In en, this message translates to:
  /// **'No organizations yet'**
  String get noOrganizations;

  /// No description provided for @createOrJoinOrganization.
  ///
  /// In en, this message translates to:
  /// **'Create or join an organization to get started'**
  String get createOrJoinOrganization;

  /// No description provided for @createOrganization.
  ///
  /// In en, this message translates to:
  /// **'Create Organization'**
  String get createOrganization;

  /// No description provided for @organizationName.
  ///
  /// In en, this message translates to:
  /// **'Organization Name'**
  String get organizationName;

  /// No description provided for @enterOrganizationName.
  ///
  /// In en, this message translates to:
  /// **'Enter organization name'**
  String get enterOrganizationName;

  /// No description provided for @organizationDescription.
  ///
  /// In en, this message translates to:
  /// **'Organization Description'**
  String get organizationDescription;

  /// No description provided for @enterOrganizationDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter organization description'**
  String get enterOrganizationDescription;

  /// No description provided for @organizationType.
  ///
  /// In en, this message translates to:
  /// **'Organization Type'**
  String get organizationType;

  /// No description provided for @organizationSlug.
  ///
  /// In en, this message translates to:
  /// **'Organization Slug'**
  String get organizationSlug;

  /// No description provided for @enterOrganizationSlug.
  ///
  /// In en, this message translates to:
  /// **'Enter organization slug'**
  String get enterOrganizationSlug;

  /// No description provided for @slugHelperText.
  ///
  /// In en, this message translates to:
  /// **'Used in URLs (e.g., my-company)'**
  String get slugHelperText;

  /// No description provided for @pleaseEnterOrganizationName.
  ///
  /// In en, this message translates to:
  /// **'Please enter organization name'**
  String get pleaseEnterOrganizationName;

  /// No description provided for @organizationNameMinLength.
  ///
  /// In en, this message translates to:
  /// **'Organization name must be at least 3 characters'**
  String get organizationNameMinLength;

  /// No description provided for @invalidSlugFormat.
  ///
  /// In en, this message translates to:
  /// **'Slug can only contain lowercase letters, numbers, and hyphens'**
  String get invalidSlugFormat;

  /// No description provided for @organizationCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Organization created successfully!'**
  String get organizationCreatedSuccessfully;

  /// No description provided for @organizationCreationFailed.
  ///
  /// In en, this message translates to:
  /// **'Organization creation failed. Please try again.'**
  String get organizationCreationFailed;

  /// No description provided for @join.
  ///
  /// In en, this message translates to:
  /// **'Join'**
  String get join;

  /// No description provided for @joinOrganization.
  ///
  /// In en, this message translates to:
  /// **'Join Organization'**
  String get joinOrganization;

  /// No description provided for @joinOrganizationMessage.
  ///
  /// In en, this message translates to:
  /// **'Do you want to join {organizationName}?'**
  String joinOrganizationMessage(Object organizationName);

  /// No description provided for @joinRequestSent.
  ///
  /// In en, this message translates to:
  /// **'Join request sent successfully!'**
  String get joinRequestSent;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @selectOrganization.
  ///
  /// In en, this message translates to:
  /// **'Select Organization'**
  String get selectOrganization;

  /// No description provided for @personal.
  ///
  /// In en, this message translates to:
  /// **'Personal'**
  String get personal;

  /// No description provided for @business.
  ///
  /// In en, this message translates to:
  /// **'Business'**
  String get business;

  /// No description provided for @ngo.
  ///
  /// In en, this message translates to:
  /// **'NGO'**
  String get ngo;

  /// No description provided for @government.
  ///
  /// In en, this message translates to:
  /// **'Government'**
  String get government;

  /// No description provided for @organization.
  ///
  /// In en, this message translates to:
  /// **'Organization'**
  String get organization;

  /// View all button text
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// Recent section title
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get recent;

  /// Name field label
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// Role field label
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get role;

  /// Logout confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logoutConfirmation;

  /// Personal information section title
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformation;

  /// Preferences section title
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// Account section title
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// Theme setting title
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// Language setting title
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Notifications setting title
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// Notifications setting subtitle
  ///
  /// In en, this message translates to:
  /// **'Manage notification preferences'**
  String get manageNotifications;

  /// All filter option
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// Search dialog title
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// Search projects placeholder
  ///
  /// In en, this message translates to:
  /// **'Search projects...'**
  String get searchProjects;

  /// Clear button text
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// Filter dialog title
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// View details link text
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// Home tab label
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Contributions tab label
  ///
  /// In en, this message translates to:
  /// **'Contributions'**
  String get contributions;

  /// Expenses tab label
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get expenses;

  /// Estimate tab label
  ///
  /// In en, this message translates to:
  /// **'Estimate'**
  String get estimate;

  /// Empty contributions message
  ///
  /// In en, this message translates to:
  /// **'No Contributions Yet'**
  String get noContributions;

  /// Empty contributions subtitle
  ///
  /// In en, this message translates to:
  /// **'Contributions will appear here once people start supporting your project'**
  String get noContributionsSubtitle;

  /// Empty expenses message
  ///
  /// In en, this message translates to:
  /// **'No Expenses Yet'**
  String get noExpenses;

  /// Empty expenses subtitle
  ///
  /// In en, this message translates to:
  /// **'Project expenses will be tracked here'**
  String get noExpensesSubtitle;

  /// Total contributions label
  ///
  /// In en, this message translates to:
  /// **'Total Contributions'**
  String get totalContributions;

  /// Total expenses label
  ///
  /// In en, this message translates to:
  /// **'Total Expenses'**
  String get totalExpenses;

  /// Net balance label
  ///
  /// In en, this message translates to:
  /// **'Net Balance'**
  String get netBalance;

  /// Dashboard tab label
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// Projects tab label
  ///
  /// In en, this message translates to:
  /// **'Projects'**
  String get projects;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'fr': return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
