import 'package:test_effective_mobile/models/item.dart';

abstract class ItemsState {}

class ItemsInitial extends ItemsState {}

class ItemsLoading extends ItemsState {}

class ItemsLoaded extends ItemsState {
  final List<Item> items;
  final int page;

  ItemsLoaded({required this.items, this.page = 0});

  ItemsLoaded copyWith({List<Item>? items, int? page}) {
    return ItemsLoaded(items: items ?? this.items, page: page ?? this.page);
  }
}

class ItemsError extends ItemsState {
  final String message;
  ItemsError(this.message);
}

class ItemsEmpty extends ItemsState {
  ItemsEmpty();
}
