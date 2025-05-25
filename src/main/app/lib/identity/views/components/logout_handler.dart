import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_spent_spent/identity/states/oidc.dart';

import '../../../router.dart';
import '../../states/username_password.dart';

class LogoutHandler extends StatelessWidget {
  final Widget child;

  const LogoutHandler({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(listeners: [
      BlocListener<UsernamePasswordCubit, UsernamePasswordState>(
        // handling rerouting to login page if the user is not logged in
        listenWhen: (previous, current) =>
            previous.token != current.token && current.token == null,
        listener: (BuildContext context, UsernamePasswordState state) {
          AutoRouter.of(context).replaceAll([const LoginRoute()]);
        },
      ),
      BlocListener<OidcCubit, OidcState>(
        // handling rerouting to login page if the user is not logged in
        listenWhen: (previous, current) =>
            previous.user != current.user && current.user == null,
        listener: (BuildContext context, OidcState state) {
          AutoRouter.of(context).replaceAll([const LoginRoute()]);
        },
      )
    ], child: child);
  }
}
