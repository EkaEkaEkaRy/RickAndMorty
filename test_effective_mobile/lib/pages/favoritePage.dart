import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_effective_mobile/l10n/app_localizations.dart';
import 'package:test_effective_mobile/pages/bloc/items_bloc/items_bloc.dart';
import 'package:test_effective_mobile/pages/bloc/items_bloc/items_event.dart';
import 'package:test_effective_mobile/pages/bloc/items_bloc/items_state.dart';
import 'package:test_effective_mobile/pages/components/filters.dart';
import 'package:test_effective_mobile/pages/components/itemCard.dart';

class FavoritePage extends StatelessWidget {
  FavoritePage({super.key});
  final GlobalKey<FiltersState> _filtersKey = GlobalKey<FiltersState>();

  @override
  Widget build(BuildContext context) {
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
            // Фильтр и сортировка
            BlocBuilder<ItemsBloc, ItemsState>(
              builder: (context, state) {
                return Container(
                  color: Theme.of(context).colorScheme.surface,
                  padding: EdgeInsets.all(16),
                  child: Filters(key: _filtersKey),
                );
              },
            ),
            // Список избранных
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
                  }
                  if (state is ItemsError) {
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
                  // if (favoriteItems.isEmpty) {
                  //   return Center(
                  //     child: Text(
                  //       AppLocalizations.of(context)!.empty_list,
                  //       style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  //         fontSize: 16.0,
                  //         color: Theme.of(context).colorScheme.onPrimary,
                  //       ),
                  //     ),
                  //   );
                  // }
                  return RefreshIndicator(
                    onRefresh: () async => {
                      _filtersKey.currentState?.resetFilters(),
                      context.read<ItemsBloc>().add(
                        LoadFavoriteItems(isRefresh: true),
                      ),
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
