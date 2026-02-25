import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:test_effective_mobile/l10n/app_localizations.dart';
import 'package:test_effective_mobile/pages/favoritePage.dart';
import 'package:test_effective_mobile/pages/homePage.dart';
import 'package:test_effective_mobile/pages/settingsPage.dart';
import 'package:test_effective_mobile/theme/locale_notifier.dart';
import 'package:test_effective_mobile/theme/theme_notifier.dart';
import 'package:test_effective_mobile/theme/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  final themeNotifier = ThemeNotifier();
  await themeNotifier.loadTheme();
  final localeNotifier = LocaleNotifier();
  await localeNotifier.loadLocale();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: themeNotifier),
        ChangeNotifierProvider.value(value: localeNotifier),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeNotifier, LocaleNotifier>(
      builder: (context, themeNotifier, localeNotifier, child) {
        return MaterialApp(
          themeMode: themeNotifier.themeMode,
          theme: lightTheme,
          darkTheme: darkTheme,
          locale: localeNotifier.locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          debugShowCheckedModeBanner: false,
          home: const MainPage(),
        );
      },
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedIndex = 0;
  static List<Widget> widgetOptions = <Widget>[];

  void onTab(int i) {
    setState(() {
      selectedIndex = i;
    });
  }

  @override
  void initState() {
    super.initState();
    widgetOptions = [HomePage(), FavoritePage(), SettingsPage()];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widgetOptions[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: onTab,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: AppLocalizations.of(context)!.home,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: AppLocalizations.of(context)!.favorite,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: AppLocalizations.of(context)!.settings,
          ),
        ],
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}
