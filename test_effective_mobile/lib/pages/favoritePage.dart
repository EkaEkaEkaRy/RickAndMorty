import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_effective_mobile/l10n/app_localizations.dart';
import 'package:test_effective_mobile/pages/bloc/items_bloc/items_bloc.dart';
import 'package:test_effective_mobile/pages/bloc/items_bloc/items_event.dart';
import 'package:test_effective_mobile/pages/bloc/items_bloc/items_state.dart';
import 'package:test_effective_mobile/pages/components/itemCard.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  static SortType? sort_value = SortType.dateDesc;
  static StatusFilter? filter_value = StatusFilter.all;

  SortType? _getCurrentSort() {
    return sort_value;
  }

  StatusFilter? _getCurrentFilter() {
    return filter_value;
  }

  @override
  Widget build(BuildContext context) {
    filter_value = StatusFilter.all;
    sort_value = SortType.dateDesc;
    return BlocProvider(
      create: (_) => ItemsBloc()..add(LoadFavoriteItems()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.favorite,
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        backgroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
        body: Column(
          children: [
            BlocBuilder<ItemsBloc, ItemsState>(
              builder: (context, state) {
                return Container(
                  color: Theme.of(context).colorScheme.surface,
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.sort),
                      SizedBox(width: 4.0),
                      Expanded(
                        flex: 1,
                        child: DropdownButton<SortType>(
                          isExpanded: true,
                          value: _getCurrentSort(),
                          items: [
                            DropdownMenuItem(
                              value: SortType.alphabetAsc,
                              child: Text(
                                AppLocalizations.of(context)!.name_abs,
                              ),
                            ),
                            DropdownMenuItem(
                              value: SortType.alphabetDesc,
                              child: Text(
                                AppLocalizations.of(context)!.name_desc,
                              ),
                            ),
                            DropdownMenuItem(
                              value: SortType.dateDesc,
                              child: Text(
                                AppLocalizations.of(context)!.date_new,
                              ),
                            ),
                            DropdownMenuItem(
                              value: SortType.dateAsc,
                              child: Text(
                                AppLocalizations.of(context)!.date_old,
                              ),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              sort_value = value;
                              context.read<ItemsBloc>().add(SortItems(value));
                            }
                          },
                        ),
                      ),
                      SizedBox(width: 16.0),
                      Icon(Icons.tune),
                      Expanded(
                        flex: 1,
                        child: BlocBuilder<ItemsBloc, ItemsState>(
                          builder: (context, state) {
                            return DropdownButton<StatusFilter>(
                              isExpanded: true,
                              value: _getCurrentFilter(),
                              items: [
                                DropdownMenuItem(
                                  value: StatusFilter.all,
                                  child: Text(
                                    AppLocalizations.of(context)!.all,
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: StatusFilter.alive,
                                  child: Text("Alive"),
                                ),
                                DropdownMenuItem(
                                  value: StatusFilter.dead,
                                  child: Text("Dead"),
                                ),
                                DropdownMenuItem(
                                  value: StatusFilter.unknown,
                                  child: Text("Unknown"),
                                ),
                              ],
                              onChanged: (value) {
                                filter_value = value;
                                sort_value = SortType.dateDesc;
                                if (value != null) {
                                  context.read<ItemsBloc>().add(
                                    FilterStatus(value),
                                  );
                                }
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            Expanded(
              child: BlocConsumer<ItemsBloc, ItemsState>(
                listener: (context, state) {
                  if (state is ItemsError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '${AppLocalizations.of(context)!.error}: ${state.message}',
                        ),
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is ItemsInitial || state is ItemsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is ItemsEmpty) {
                    return Center(
                      child: Text(
                        AppLocalizations.of(context)!.empty_list,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 16.0,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    );
                  } else if (state is ItemsError) {
                    return Center(
                      child: Text(
                        '${AppLocalizations.of(context)!.error}: ${state.message}',
                      ),
                    );
                  }

                  final itemsState = state as ItemsLoaded;
                  final favoriteItems = itemsState.items;

                  // final favoriteItems = itemsState.items
                  //     .where((element) => element.favorite == true)
                  //     .toList();
                  if (favoriteItems.isEmpty) {
                    return Center(
                      child: Text(
                        AppLocalizations.of(context)!.empty_list,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 16.0,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () async => {
                      context.read<ItemsBloc>().add(
                        LoadFavoriteItems(isRefresh: true),
                      ),
                      filter_value = StatusFilter.all,
                      sort_value = SortType.dateDesc,
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: favoriteItems.length,
                      itemBuilder: (context, index) {
                        final item = favoriteItems[index];
                        return ItemCard(item: item);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
