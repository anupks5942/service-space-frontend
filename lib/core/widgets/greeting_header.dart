import 'package:flutter/material.dart';
import 'package:frontend/auth/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class GreetingHeader extends StatelessWidget {
  const GreetingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final user = context.read<AuthProvider>().getUser();
    final name = user?.name.split(' ').first ?? '';

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hi, $name!',
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                Text(
                  'How would you like to serve today?',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
            // const Spacer(),
            // GestureDetector(
            //   onTap: () => context.read<HomeProvider>().setIndex(2),
            //   child: CircleAvatar(radius: 5.w, child: Icon(Icons.person, size: 5.w, color: colorScheme.onSurface)),
            // ),
          ],
        ),
        Divider(
          color: colorScheme.onSurfaceVariant,
          thickness: 0.5,
          height: 3.h,
        ),
      ],
    );
  }
}
