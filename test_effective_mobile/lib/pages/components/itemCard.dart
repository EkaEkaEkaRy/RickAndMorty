import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_effective_mobile/database/database.dart';
import 'package:test_effective_mobile/models/item.dart';
import 'package:test_effective_mobile/pages/bloc/items_bloc/items_bloc.dart';
import 'package:test_effective_mobile/pages/bloc/items_bloc/items_event.dart';
import 'package:test_effective_mobile/pages/bloc/items_bloc/items_state.dart';

class ItemCard extends StatelessWidget {
  const ItemCard({super.key, required this.item});
  final Item item;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: BlocBuilder<ItemsBloc, ItemsState>(
        builder: (context, state) {
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Изображение персонажа
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      color: Theme.of(context).colorScheme.tertiary,
                      child: Image.network(
                        item.image,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 80,
                          height: 80,
                          color: Theme.of(context).colorScheme.tertiary,
                          child: const Icon(Icons.image_not_supported),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Имя персонажа
                        Text(
                          item.name,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontSize: 16.0,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item.status,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                color: item.status == "Alive"
                                    ? Theme.of(context).colorScheme.primary
                                    : item.status == "Dead"
                                    ? Theme.of(context).colorScheme.error
                                    : Theme.of(context).colorScheme.tertiary,
                                fontWeight: FontWeight.bold,
                                fontSize: 12.0,
                              ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      final DatabaseHelper databaseHelper = DatabaseHelper();
                      BlocProvider.of<ItemsBloc>(
                        context,
                      ).add(ToggleFavoriteItem(item.id));
                      if (item.favorite == true) {
                        databaseHelper.deleteFavoriteItem(item.id);
                      } else {
                        databaseHelper.addFavoriteItem(item);
                      }
                    },
                    icon: item.favorite
                        ? Icon(
                            Icons.star,
                            color: Theme.of(context).colorScheme.primary,
                          )
                        : const Icon(Icons.star_border_outlined),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
