import 'package:material_ui/material_ui.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/login/views/components/login.dart';

class ResetPassword extends StatefulWidget {
  final Function onBack;
  final String server;

  /// The server has no SMTP configured, the reset link is printed in its logs instead of emailed.
  final bool viaLogs;

  const ResetPassword({super.key, required this.onBack, required this.server, this.viaLogs = false});

  @override
  ResetPasswordState createState() => ResetPasswordState();
}

class ResetPasswordState extends State<ResetPassword> {
  TextEditingController usernameController = TextEditingController();

  Future<void> resetPassword(BuildContext context) async {
    await service.resetPassword(widget.server, usernameController.text.trim());
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.viaLogs
              ? "Reset password request sent. Ask your server administrator for the reset link, it's in the server logs"
              : "Reset password request sent successfully, check your email for instructions",
        ),
      ),
    );

    widget.onBack();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(70.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.viaLogs)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'This server does not send emails. After requesting a reset, your server administrator '
                'will find a reset link (valid for 24h) in the server logs.',
                style: TextStyle(color: colors.onPrimaryContainer),
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text('Email', style: TextStyle(color: colors.onPrimaryContainer)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: usernameController,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: getFieldDecoration("Email", "user@example.org", colors),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: FilledButton.tonal(
                    onPressed: () => resetPassword(context),
                    child: const Text('Reset password'),
                  ),
                ),
              ],
            ),
          ),
          TextButton(onPressed: () => widget.onBack(), child: const Text('Back')),
        ],
      ),
    );
  }
}
