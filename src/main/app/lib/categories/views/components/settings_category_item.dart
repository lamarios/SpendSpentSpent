import 'package:flutter/material.dart';
import 'package:spend_spent_spent/categories/views/screens/category_settings.dart';
import 'package:spend_spent_spent/globals.dart';

class SettingsCategoryGridItem extends StatelessWidget {
  const SettingsCategoryGridItem({super.key});

  void showAddCategory(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CategorySettingsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () => showAddCategory(context),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: defaultBorder,
          border: Border.all(
            width: 3,
            color: colors.primary.withValues(alpha: 0.5),
          ),
        ),
        child: Icon(
          Icons.settings,
          color: colors.primary.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}
