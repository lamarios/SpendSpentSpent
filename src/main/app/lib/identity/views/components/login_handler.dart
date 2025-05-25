import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_spent_spent/categories/state/categories.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/identity/states/oidc.dart';
import 'package:spend_spent_spent/identity/states/username_password.dart';
import 'package:spend_spent_spent/router.dart';

class LoginHandler extends StatelessWidget {
  final Widget child;
  final TextEditingController urlController;

  const LoginHandler(
      {super.key, required this.child, required this.urlController});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(listeners: [
      BlocListener<OidcCubit, OidcState>(
        listenWhen: (previous, current) =>
            previous.user != current.user && current.user != null,
        listener: (context, state) async {
          await service.setUrl(urlController.text.trim());
          if (context.mounted) {
            context.read<CategoriesCubit>().getCategories();
            AutoRouter.of(context).replaceAll([const HomeRoute()]);
          }
        },
      ),
      BlocListener<UsernamePasswordCubit, UsernamePasswordState>(
        listenWhen: (previous, current) =>
            previous.token != current.token && current.token != null,
        listener: (context, state) async {
          await service.setUrl(urlController.text.trim());
          if (context.mounted) {
            context.read<CategoriesCubit>().getCategories();
            AutoRouter.of(context).replaceAll([const HomeRoute()]);
          }
        },
      )
    ], child: child);
  }
}
