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
  /// **'View all projects'**
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

  /// Title for contribution details screen
  ///
  /// In en, this message translates to:
  /// **'Contribution Details'**
  String get contributionDetails;

  /// Section title for contribution information
  ///
  /// In en, this message translates to:
  /// **'Contribution Information'**
  String get contributionInfo;

  /// Label for contributor information
  ///
  /// In en, this message translates to:
  /// **'Contributor'**
  String get contributor;

  /// Section title for payment information
  ///
  /// In en, this message translates to:
  /// **'Payment Information'**
  String get paymentInfo;

  /// Payment method field label
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get paymentMethod;

  /// Transaction ID field label
  ///
  /// In en, this message translates to:
  /// **'Transaction ID'**
  String get transactionId;

  /// Label for notes section
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// Error message when contribution is not found
  ///
  /// In en, this message translates to:
  /// **'Contribution not found'**
  String get contributionNotFound;

  /// Title for delete contribution dialog
  ///
  /// In en, this message translates to:
  /// **'Delete Contribution'**
  String get deleteContribution;

  /// Confirmation message for deleting contribution
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this contribution? This action cannot be undone.'**
  String get deleteContributionConfirmation;

  /// Error label
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Retry button text
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Amount label
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// Reference label
  ///
  /// In en, this message translates to:
  /// **'Reference'**
  String get reference;

  /// Status label
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// Edit action
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// Share action
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// Delete action
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Confirm action
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// Mark as received action
  ///
  /// In en, this message translates to:
  /// **'Mark Received'**
  String get markReceived;

  /// Mark as pending action
  ///
  /// In en, this message translates to:
  /// **'Mark as Pending'**
  String get markPending;

  /// Title for contribution actions section
  ///
  /// In en, this message translates to:
  /// **'Contribution Actions'**
  String get contributionActions;

  /// Message shown when no actions are available for the current contribution status
  ///
  /// In en, this message translates to:
  /// **'No actions available for this contribution status'**
  String get noActionsAvailable;

  /// Title for edit contribution screen
  ///
  /// In en, this message translates to:
  /// **'Edit Contribution'**
  String get editContribution;

  /// Member field label
  ///
  /// In en, this message translates to:
  /// **'Member'**
  String get member;

  /// Note field label
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get note;

  /// Save changes button text
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// Cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Select member dropdown placeholder
  ///
  /// In en, this message translates to:
  /// **'Select Member'**
  String get selectMember;

  /// Select payment method dropdown placeholder
  ///
  /// In en, this message translates to:
  /// **'Select Payment Method'**
  String get selectPaymentMethod;

  /// Amount input placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter Amount'**
  String get enterAmount;

  /// Transaction ID input placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter Transaction ID'**
  String get enterTransactionId;

  /// Note input placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter Note (Optional)'**
  String get enterNote;

  /// Success message when contribution is updated
  ///
  /// In en, this message translates to:
  /// **'Contribution updated successfully'**
  String get contributionUpdated;

  /// Error message when contribution update fails
  ///
  /// In en, this message translates to:
  /// **'Failed to update contribution'**
  String get updateContributionError;

  /// Amount validation error message
  ///
  /// In en, this message translates to:
  /// **'Amount is required'**
  String get amountRequired;

  /// Member validation error message
  ///
  /// In en, this message translates to:
  /// **'Member is required'**
  String get memberRequired;

  /// Payment method validation error message
  ///
  /// In en, this message translates to:
  /// **'Payment method is required'**
  String get paymentMethodRequired;

  /// Invalid amount validation error message
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid amount'**
  String get invalidAmount;

  /// Title for add contribution screen
  ///
  /// In en, this message translates to:
  /// **'Add Contribution'**
  String get addContribution;

  /// Success message when contribution is added
  ///
  /// In en, this message translates to:
  /// **'Contribution added successfully'**
  String get contributionAdded;

  /// Error message when contribution addition fails
  ///
  /// In en, this message translates to:
  /// **'Failed to add contribution'**
  String get addContributionError;

  /// Button text for adding new contribution
  ///
  /// In en, this message translates to:
  /// **'Add New Contribution'**
  String get addNewContribution;

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
  /// **'No organizations'**
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
  /// **'View all'**
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

  /// No description provided for @expenseDetails.
  ///
  /// In en, this message translates to:
  /// **'Expense Details'**
  String get expenseDetails;

  /// No description provided for @expenseInformation.
  ///
  /// In en, this message translates to:
  /// **'Expense Information'**
  String get expenseInformation;

  /// No description provided for @expenseNotFound.
  ///
  /// In en, this message translates to:
  /// **'Expense not found'**
  String get expenseNotFound;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @receiptUrl.
  ///
  /// In en, this message translates to:
  /// **'Receipt URL'**
  String get receiptUrl;

  /// No description provided for @actions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get actions;

  /// No description provided for @approve.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get approve;

  /// No description provided for @reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// No description provided for @editExpense.
  ///
  /// In en, this message translates to:
  /// **'Edit Expense'**
  String get editExpense;

  /// No description provided for @expenseUpdated.
  ///
  /// In en, this message translates to:
  /// **'Expense updated successfully'**
  String get expenseUpdated;

  /// No description provided for @updateExpenseError.
  ///
  /// In en, this message translates to:
  /// **'Failed to update expense'**
  String get updateExpenseError;

  /// No description provided for @descriptionRequired.
  ///
  /// In en, this message translates to:
  /// **'Description is required'**
  String get descriptionRequired;

  /// No description provided for @categoryRequired.
  ///
  /// In en, this message translates to:
  /// **'Category is required'**
  String get categoryRequired;

  /// No description provided for @enterDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter Description'**
  String get enterDescription;

  /// No description provided for @enterCategory.
  ///
  /// In en, this message translates to:
  /// **'Enter Category'**
  String get enterCategory;

  /// No description provided for @enterReceiptUrl.
  ///
  /// In en, this message translates to:
  /// **'Enter Receipt URL (Optional)'**
  String get enterReceiptUrl;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @estimateDetails.
  ///
  /// In en, this message translates to:
  /// **'Estimate Details'**
  String get estimateDetails;

  /// No description provided for @estimateInformation.
  ///
  /// In en, this message translates to:
  /// **'Estimate Information'**
  String get estimateInformation;

  /// No description provided for @estimateNotFound.
  ///
  /// In en, this message translates to:
  /// **'Estimate not found'**
  String get estimateNotFound;

  /// No description provided for @estimatedAmount.
  ///
  /// In en, this message translates to:
  /// **'Estimated Amount'**
  String get estimatedAmount;

  /// No description provided for @priority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get priority;

  /// No description provided for @estimatedAt.
  ///
  /// In en, this message translates to:
  /// **'Estimated At'**
  String get estimatedAt;

  /// No description provided for @appSettings.
  ///
  /// In en, this message translates to:
  /// **'App Settings'**
  String get appSettings;

  /// No description provided for @generalSettings.
  ///
  /// In en, this message translates to:
  /// **'General Settings'**
  String get generalSettings;

  /// No description provided for @displaySettings.
  ///
  /// In en, this message translates to:
  /// **'Display Settings'**
  String get displaySettings;

  /// No description provided for @notificationSettings.
  ///
  /// In en, this message translates to:
  /// **'Notification Settings'**
  String get notificationSettings;

  /// No description provided for @privacySettings.
  ///
  /// In en, this message translates to:
  /// **'Privacy Settings'**
  String get privacySettings;

  /// No description provided for @aboutApp.
  ///
  /// In en, this message translates to:
  /// **'About App'**
  String get aboutApp;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @buildNumber.
  ///
  /// In en, this message translates to:
  /// **'Build Number'**
  String get buildNumber;

  /// No description provided for @lastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last Updated'**
  String get lastUpdated;

  /// No description provided for @developer.
  ///
  /// In en, this message translates to:
  /// **'Developer'**
  String get developer;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @feedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedback;

  /// No description provided for @rateApp.
  ///
  /// In en, this message translates to:
  /// **'Rate App'**
  String get rateApp;

  /// No description provided for @shareApp.
  ///
  /// In en, this message translates to:
  /// **'Share App'**
  String get shareApp;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @dataUsage.
  ///
  /// In en, this message translates to:
  /// **'Data Usage'**
  String get dataUsage;

  /// No description provided for @cacheSize.
  ///
  /// In en, this message translates to:
  /// **'Cache Size'**
  String get cacheSize;

  /// No description provided for @clearCache.
  ///
  /// In en, this message translates to:
  /// **'Clear Cache'**
  String get clearCache;

  /// No description provided for @autoSync.
  ///
  /// In en, this message translates to:
  /// **'Auto Sync'**
  String get autoSync;

  /// No description provided for @syncFrequency.
  ///
  /// In en, this message translates to:
  /// **'Sync Frequency'**
  String get syncFrequency;

  /// No description provided for @offlineMode.
  ///
  /// In en, this message translates to:
  /// **'Offline Mode'**
  String get offlineMode;

  /// No description provided for @biometricAuth.
  ///
  /// In en, this message translates to:
  /// **'Biometric Authentication'**
  String get biometricAuth;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @systemTheme.
  ///
  /// In en, this message translates to:
  /// **'System Theme'**
  String get systemTheme;

  /// No description provided for @lightTheme.
  ///
  /// In en, this message translates to:
  /// **'Light Theme'**
  String get lightTheme;

  /// No description provided for @darkTheme.
  ///
  /// In en, this message translates to:
  /// **'Dark Theme'**
  String get darkTheme;

  /// No description provided for @fontSize.
  ///
  /// In en, this message translates to:
  /// **'Font Size'**
  String get fontSize;

  /// No description provided for @small.
  ///
  /// In en, this message translates to:
  /// **'Small'**
  String get small;

  /// No description provided for @medium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get medium;

  /// No description provided for @large.
  ///
  /// In en, this message translates to:
  /// **'Large'**
  String get large;

  /// No description provided for @extraLarge.
  ///
  /// In en, this message translates to:
  /// **'Extra Large'**
  String get extraLarge;

  /// No description provided for @pushNotifications.
  ///
  /// In en, this message translates to:
  /// **'Push Notifications'**
  String get pushNotifications;

  /// No description provided for @emailNotifications.
  ///
  /// In en, this message translates to:
  /// **'Email Notifications'**
  String get emailNotifications;

  /// No description provided for @smsNotifications.
  ///
  /// In en, this message translates to:
  /// **'SMS Notifications'**
  String get smsNotifications;

  /// No description provided for @marketingEmails.
  ///
  /// In en, this message translates to:
  /// **'Marketing Emails'**
  String get marketingEmails;

  /// No description provided for @securityAlerts.
  ///
  /// In en, this message translates to:
  /// **'Security Alerts'**
  String get securityAlerts;

  /// No description provided for @projectUpdates.
  ///
  /// In en, this message translates to:
  /// **'Project Updates'**
  String get projectUpdates;

  /// No description provided for @contributionReminders.
  ///
  /// In en, this message translates to:
  /// **'Contribution Reminders'**
  String get contributionReminders;

  /// No description provided for @expenseAlerts.
  ///
  /// In en, this message translates to:
  /// **'Expense Alerts'**
  String get expenseAlerts;

  /// No description provided for @estimateNotifications.
  ///
  /// In en, this message translates to:
  /// **'Estimate Notifications'**
  String get estimateNotifications;

  /// No description provided for @organizationInvites.
  ///
  /// In en, this message translates to:
  /// **'Organization Invites'**
  String get organizationInvites;

  /// No description provided for @weeklyDigest.
  ///
  /// In en, this message translates to:
  /// **'Weekly Digest'**
  String get weeklyDigest;

  /// No description provided for @monthlyReport.
  ///
  /// In en, this message translates to:
  /// **'Monthly Report'**
  String get monthlyReport;

  /// No description provided for @hiThere.
  ///
  /// In en, this message translates to:
  /// **'Hi there'**
  String get hiThere;

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @untitledProject.
  ///
  /// In en, this message translates to:
  /// **'Untitled Project'**
  String get untitledProject;

  /// No description provided for @project.
  ///
  /// In en, this message translates to:
  /// **'Project'**
  String get project;

  /// No description provided for @noProjectsYet.
  ///
  /// In en, this message translates to:
  /// **'No projects yet'**
  String get noProjectsYet;

  /// No description provided for @startByCreatingFirstProject.
  ///
  /// In en, this message translates to:
  /// **'Start by creating your first project'**
  String get startByCreatingFirstProject;

  /// No description provided for @startCeremony.
  ///
  /// In en, this message translates to:
  /// **'Start a ceremony'**
  String get startCeremony;

  /// No description provided for @manageTeams.
  ///
  /// In en, this message translates to:
  /// **'Manage teams'**
  String get manageTeams;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @switchOrganization.
  ///
  /// In en, this message translates to:
  /// **'Switch Organization'**
  String get switchOrganization;

  /// No description provided for @untitledOrganization.
  ///
  /// In en, this message translates to:
  /// **'Untitled Organization'**
  String get untitledOrganization;

  /// No description provided for @createFirstOrganization.
  ///
  /// In en, this message translates to:
  /// **'Create your first organization to get started'**
  String get createFirstOrganization;

  /// No description provided for @addExpense.
  ///
  /// In en, this message translates to:
  /// **'Add Expense'**
  String get addExpense;

  /// No description provided for @expenseAdded.
  ///
  /// In en, this message translates to:
  /// **'Expense added successfully'**
  String get expenseAdded;

  /// No description provided for @addExpenseError.
  ///
  /// In en, this message translates to:
  /// **'Failed to add expense'**
  String get addExpenseError;

  /// No description provided for @officeSupplies.
  ///
  /// In en, this message translates to:
  /// **'Office Supplies'**
  String get officeSupplies;

  /// No description provided for @travel.
  ///
  /// In en, this message translates to:
  /// **'Travel'**
  String get travel;

  /// No description provided for @meals.
  ///
  /// In en, this message translates to:
  /// **'Meals'**
  String get meals;

  /// No description provided for @equipment.
  ///
  /// In en, this message translates to:
  /// **'Equipment'**
  String get equipment;

  /// No description provided for @marketing.
  ///
  /// In en, this message translates to:
  /// **'Marketing'**
  String get marketing;

  /// No description provided for @utilities.
  ///
  /// In en, this message translates to:
  /// **'Utilities'**
  String get utilities;

  /// No description provided for @rent.
  ///
  /// In en, this message translates to:
  /// **'Rent'**
  String get rent;

  /// No description provided for @professionalServices.
  ///
  /// In en, this message translates to:
  /// **'Professional Services'**
  String get professionalServices;

  /// No description provided for @software.
  ///
  /// In en, this message translates to:
  /// **'Software'**
  String get software;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;
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
