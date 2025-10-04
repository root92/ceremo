import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/locale_provider.dart';

class LanguageToggle extends StatelessWidget {
  const LanguageToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(
      builder: (context, localeProvider, child) {
        return PopupMenuButton<Locale>(
          icon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                localeProvider.languageFlag,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.language,
                size: 18,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ],
          ),
          onSelected: (Locale locale) {
            localeProvider.setLocale(locale);
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: const Locale('en'),
              child: Row(
                children: [
                  const Text('🇺🇸', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 8),
                  const Text('English'),
                  if (localeProvider.isEnglish)
                    const Spacer(),
                  if (localeProvider.isEnglish)
                    const Icon(Icons.check, color: Colors.orange),
                ],
              ),
            ),
            PopupMenuItem(
              value: const Locale('fr'),
              child: Row(
                children: [
                  const Text('🇫🇷', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 8),
                  const Text('Français'),
                  if (localeProvider.isFrench)
                    const Spacer(),
                  if (localeProvider.isFrench)
                    const Icon(Icons.check, color: Colors.orange),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
