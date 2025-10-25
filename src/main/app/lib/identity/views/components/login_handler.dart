import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_spent_spent/categories/state/categories.dart';
import 'package:spend_spent_spent/households/states/household.dart';
import 'package:spend_spent_spent/identity/states/username_password.dart';
import 'package:spend_spent_spent/router.dart';

class LoginHandler extends StatelessWidget {
  final Widget child;

  const LoginHandler({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<UsernamePasswordCubit, UsernamePasswordState>(
          listenWhen: (previous, current) =>
              previous.token != current.token && current.token != null,
          listener: (context, state) async {
            if (context.mounted) {
              context.read<CategoriesCubit>().getCategories(true);
              AutoRouter.of(
                context,
              ).replaceAll([const HomeRoute()], updateExistingRoutes: false);
              context.read<HouseholdCubit>().getData();
            }
          },
        ),
      ],
      child: child,
    );
  }
}
