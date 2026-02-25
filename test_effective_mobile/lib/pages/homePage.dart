import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_effective_mobile/l10n/app_localizations.dart';
import 'package:test_effective_mobile/pages/bloc/items_bloc/items_bloc.dart';
import 'package:test_effective_mobile/pages/bloc/items_bloc/items_event.dart';
import 'package:test_effective_mobile/pages/bloc/items_bloc/items_state.dart';
import 'package:test_effective_mobile/pages/components/itemCard.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ItemsBloc()..add(LoadItems()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.home,
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        backgroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
        body: BlocConsumer<ItemsBloc, ItemsState>(
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

            if (state is ItemsError) {
              return Center(
                child: Text(
                  '${AppLocalizations.of(context)!.error}: ${state.message}',
                ),
              );
            }

            final itemsState = state as ItemsLoaded;
            return RefreshIndicator(
              onRefresh: () async =>
                  context.read<ItemsBloc>().add(LoadItems(isRefresh: true)),
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: itemsState.items.length,
                itemBuilder: (context, index) {
                  final item = itemsState.items[index];
                  return ItemCard(item: item);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
