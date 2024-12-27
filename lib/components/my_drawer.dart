import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/pages/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Toggle Theme',
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 20),
          CupertinoSwitch(
            value: Provider.of<ThemeProvider>(context).isDarkMode,
            onChanged: (value) {
              // Toggle theme
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();

              // Close and reopen the drawer to reflect theme changes
              Navigator.pop(context); // Close the drawer
              Scaffold.of(context).openDrawer(); // Reopen the drawer
            },
          ),
        ],
      ),
    );
  }
}
