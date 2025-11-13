import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:material_loading_indicator/loading_indicator.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/settings/state/notification_listener_settings.dart';

class NotificationListenerSetup extends StatelessWidget {
  const NotificationListenerSetup({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: BlocProvider(
        create: (context) => NotificationListenerSettingsCubit(
          NotificationListenerSettingsState(),
        ),
        child:
            BlocBuilder<
              NotificationListenerSettingsCubit,
              NotificationListenerSettingsState
            >(
              builder: (context, state) {
                final cubit = context.read<NotificationListenerSettingsCubit>();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'SpendSpentSpent can listen to the notifications on your phone and detect if it could be logged as an expense. The app will then send you a notification and by tapping it you can add an expense.\n\nNo notification data is ever sent to the server you\'re using, ALL the processing is done locally.',
                      ),
                    ),
                    SwitchListTile(
                      value: state.enabled,
                      onChanged: cubit.enable,
                      title: Text(
                        'Watch device notifications for possible expenses',
                      ),
                    ),
                    Gap(16),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                        'Notifications caught by SpendSpentSpent',
                        style: textTheme.bodyLarge,
                      ),
                    ),
                    !state.loading && state.history.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Text(
                              'No relevant notifications caught by SpendSpentSpent yet',
                            ),
                          )
                        : Expanded(
                            child: ListView.builder(
                              itemCount: state.hasMore || state.loading
                                  ? state.history.length + 1
                                  : state.history.length,
                              itemBuilder: (context, index) {
                                if (index == state.history.length) {
                                  return state.loading
                                      ? Center(
                                          key: ValueKey('loading'),
                                          child: LoadingIndicator(),
                                        )
                                      : FilledButton.tonal(
                                          key: ValueKey('add-more'),
                                          onPressed: () => cubit.loadMore(),
                                          child: Text('Load more'),
                                        );
                                }

                                var h = state.history[index];
                                return ListTile(
                                  key: ValueKey(h.time),
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        DateTime.fromMillisecondsSinceEpoch(
                                          h.time,
                                        ).toString(),
                                        style: textTheme.labelSmall?.copyWith(
                                          fontSize: 10,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      Text(h.appName ?? h.package ?? ''),
                                    ],
                                  ),
                                  subtitle: Text(
                                    'Amount found: ${formatCurrency(h.amountFound)}',
                                  ),
                                  leading: h.icon != null
                                      ? Image.memory(
                                          h.icon!,
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.contain,
                                        )
                                      : SizedBox(width: 50, height: 50),
                                  trailing: InkWell(
                                    onTap: () =>
                                        cubit.toggleIgnore(h.package ?? ''),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text('Ignore app'),
                                        SizedBox(
                                          height: 40,
                                          child: FittedBox(
                                            child: Switch(
                                              value: state.ignoreList.contains(
                                                h.package,
                                              ),
                                              onChanged: (value) =>
                                                  cubit.toggleIgnore(
                                                    h.package ?? '',
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                  ],
                );
              },
            ),
      ),
    );
  }
}
