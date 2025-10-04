import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'services/graphql_client.dart';
import 'providers/auth_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/locale_provider.dart';
import 'providers/projects_provider.dart';
import 'providers/organizations_provider.dart';
import 'providers/organization_context_provider.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'widgets/loading_screen.dart';
import 'theme/app_theme.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize GraphQL
  await initHiveForFlutter();
  
  runApp(const CeremoApp());
}

class CeremoApp extends StatelessWidget {
  const CeremoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
             providers: [
               ChangeNotifierProvider(create: (_) => AuthProvider()),
               ChangeNotifierProvider(create: (_) => ThemeProvider()),
               ChangeNotifierProvider(create: (_) => LocaleProvider()),
               ChangeNotifierProvider(create: (_) => ProjectsProvider()),
               ChangeNotifierProvider(create: (_) => OrganizationsProvider()),
               ChangeNotifierProvider(create: (_) => OrganizationContextProvider()),
             ],
      child: GraphQLProvider(
        client: ValueNotifier(CeremoGraphQLClient.client),
        child: Consumer2<ThemeProvider, LocaleProvider>(
          builder: (context, themeProvider, localeProvider, child) {
            return MaterialApp(
              title: 'Ceremo',
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeProvider.themeMode,
              locale: localeProvider.locale,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: LocaleProvider.supportedLocales,
              home: const AuthWrapper(),
            );
          },
        ),
      ),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    // Initialize providers
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<AuthProvider>().initialize();
      context.read<ThemeProvider>().initialize();
      context.read<LocaleProvider>().initialize();
      
      // Only initialize organization context if user is authenticated
      if (context.read<AuthProvider>().isAuthenticated) {
        print('Main: User is authenticated, initializing organization context...');
        await context.read<OrganizationContextProvider>().initialize();
        
        // Initialize projects provider after organization context is set
        print('Main: Initializing projects provider...');
        await context.read<ProjectsProvider>().loadProjects();
      } else {
        print('Main: User is not authenticated, skipping organization context initialization');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (authProvider.isLoading) {
          return const LoadingScreen(
            message: 'Initializing Ceremo...',
          );
        }

        if (authProvider.isAuthenticated) {
          return const DashboardScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}


