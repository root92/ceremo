import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class ThemeToggle extends StatelessWidget {
  const ThemeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return PopupMenuButton<ThemeMode>(
          icon: Icon(themeProvider.themeIcon),
          onSelected: (ThemeMode mode) {
            themeProvider.setThemeMode(mode);
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: ThemeMode.light,
              child: Row(
                children: [
                  const Icon(Icons.light_mode),
                  const SizedBox(width: 8),
                  const Text('Light'),
                  if (themeProvider.themeMode == ThemeMode.light)
                    const Spacer(),
                  if (themeProvider.themeMode == ThemeMode.light)
                    const Icon(Icons.check, color: Colors.orange),
                ],
              ),
            ),
            PopupMenuItem(
              value: ThemeMode.dark,
              child: Row(
                children: [
                  const Icon(Icons.dark_mode),
                  const SizedBox(width: 8),
                  const Text('Dark'),
                  if (themeProvider.themeMode == ThemeMode.dark)
                    const Spacer(),
                  if (themeProvider.themeMode == ThemeMode.dark)
                    const Icon(Icons.check, color: Colors.orange),
                ],
              ),
            ),
            PopupMenuItem(
              value: ThemeMode.system,
              child: Row(
                children: [
                  const Icon(Icons.brightness_auto),
                  const SizedBox(width: 8),
                  const Text('System'),
                  if (themeProvider.themeMode == ThemeMode.system)
                    const Spacer(),
                  if (themeProvider.themeMode == ThemeMode.system)
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
