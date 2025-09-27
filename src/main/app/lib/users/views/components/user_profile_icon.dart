import 'package:flutter/material.dart';

import '../../../settings/models/user.dart';

class UserProfileIcon extends StatelessWidget {
  final User user;
  final double size;
  final ColorScheme? colorScheme;

  const UserProfileIcon({
    super.key,
    required this.user,
    required this.size,
    this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colorScheme?.primaryContainer ?? colors.primaryContainer,
      ),
      child: Center(
        child: SizedBox(
          width: size * 0.8,
          height: size * 0.8,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              '${user.firstName.substring(0, 1).toUpperCase()}${user.lastName.substring(0, 1).toUpperCase()}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color:
                    colorScheme?.onPrimaryContainer ??
                    colors.onPrimaryContainer,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
