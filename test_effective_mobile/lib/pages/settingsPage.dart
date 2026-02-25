import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_effective_mobile/l10n/app_localizations.dart';
import 'package:test_effective_mobile/theme/locale_notifier.dart';
import 'package:test_effective_mobile/theme/theme_notifier.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.settings,
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              // Переключатель темы
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Consumer<ThemeNotifier>(
                    builder: (context, themeNotifier, child) {
                      return SwitchListTile(
                        title: Text(
                          themeNotifier.isDark
                              ? AppLocalizations.of(context)!.dark_theme
                              : AppLocalizations.of(context)!.light_theme,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        value: themeNotifier.isDark,
                        onChanged: (_) => themeNotifier.toggleTheme(),
                        secondary: Icon(
                          themeNotifier.isDark
                              ? Icons.dark_mode
                              : Icons.light_mode,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              // Переключатель языка
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Consumer<LocaleNotifier>(
                    builder: (context, localeNotifier, child) {
                      final isRussian =
                          localeNotifier.locale.languageCode == 'ru';
                      return SwitchListTile(
                        title: Text(
                          isRussian ? 'Русский' : 'English',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        value: isRussian,
                        onChanged: (_) => localeNotifier.setLocale(
                          isRussian ? const Locale('en') : const Locale('ru'),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
