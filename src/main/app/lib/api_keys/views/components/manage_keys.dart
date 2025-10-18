import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_loading_indicator/loading_indicator.dart';
import 'package:spend_spent_spent/api_keys/states/api_key_management.dart';
import 'package:spend_spent_spent/api_keys/views/components/add_api_key_dialog.dart';
import 'package:spend_spent_spent/api_keys/views/components/api_key.dart';
import 'package:spend_spent_spent/home/views/components/menu.dart';
import 'package:spend_spent_spent/utils/dialogs.dart';
import 'package:spend_spent_spent/utils/views/components/error_listener.dart';

class ManageApiKeys extends StatelessWidget {
  const ManageApiKeys({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    ;

    return BlocProvider(
      create: (context) => ApiKeyManagementCubit(ApiKeyManagementState()),
      child: BlocBuilder<ApiKeyManagementCubit, ApiKeyManagementState>(
        builder: (context, state) {
          final cubit = context.read<ApiKeyManagementCubit>();

          if (state.loading) {
            return Center(child: LoadingIndicator());
          }
          return ErrorHandler<ApiKeyManagementCubit, ApiKeyManagementState>(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'API Keys can be used to access your data using the api or the MCP server',
                          style: textTheme.titleMedium,
                        ),
                      ),
                      Expanded(
                        child: ListView.separated(
                          itemCount: state.keys.length,
                          itemBuilder: (context, index) => ApiKeyView(
                            key: ValueKey(state.keys[index].id),
                            apiKey: state.keys[index],
                          ),
                          separatorBuilder: (BuildContext context, int index) =>
                              Divider(),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 32,
                  right: 32,
                  child: FloatingActionButton(
                    onPressed: () async {
                      final newKey = await AddApiKeyDialog.show(context);
                      if (newKey != null) {
                        var createdKey = await cubit.addKey(newKey);

                        if (context.mounted) {
                          okCancelDialog(
                            context,
                            title: 'API key created',
                            showCancel: false,
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  'This is the only time you will see the API key, make sure to make a copy of it',
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        readOnly: true,
                                        initialValue: createdKey.apiKey,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () async {
                                        await Clipboard.setData(
                                          ClipboardData(
                                            text: createdKey.apiKey ?? '',
                                          ),
                                        );
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'API key copied to the clipboard',
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      icon: Icon(Icons.copy),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            onOk: () {},
                          );
                        }
                      }
                    },
                    child: Icon(Icons.add),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
