import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:spend_spent_spent/api_keys/models/api_key.dart';
import 'package:spend_spent_spent/api_keys/states/api_key_management.dart';
import 'package:spend_spent_spent/utils/dialogs.dart';

final _df = DateFormat.yMMMd().add_Hms();

class ApiKeyView extends StatelessWidget {
  final ApiKey apiKey;

  const ApiKeyView({super.key, required this.apiKey});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ListTile(
      title: Text(apiKey.keyName),
      trailing: IconButton(
        onPressed: () {
          okCancelDialog(
            context,
            title: 'Delete Key',
            content: Text('This is not reversible.'),
            onOk: () {
              context.read<ApiKeyManagementCubit>().deleteKey(apiKey);
            },
          );
        },
        icon: Icon(Icons.delete),
        color: colors.error,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text('Expires: '),
              Expanded(
                child: Text(
                  apiKey.expiryDate != null
                      ? _df.format(DateTime.fromMillisecondsSinceEpoch(apiKey.expiryDate!))
                      : 'Never',
                  style: textTheme.bodyMedium?.copyWith(color: apiKey.expiryDate == null ? colors.error : null),
                ),
              ),
            ],
          ),
          Text(
            'Last used: ${apiKey.lastUsed != null ? _df.format(DateTime.fromMillisecondsSinceEpoch(apiKey.lastUsed!)) : 'Never'}',
          ),
        ],
      ),
    );
  }
}
