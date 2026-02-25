import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:test_effective_mobile/database/database.dart';
import 'package:test_effective_mobile/models/item.dart';
import 'package:test_effective_mobile/pages/bloc/items_bloc/items_event.dart';
import 'package:test_effective_mobile/pages/bloc/items_bloc/items_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ItemsBloc extends Bloc<ItemsEvent, ItemsState> {
  final DatabaseHelper databaseHelper = DatabaseHelper();

  ItemsBloc() : super(ItemsInitial()) {
    on<LoadItems>(_onLoadItems);
    on<LoadFavoriteItems>(_onLoadFavoriteItems);
    on<ToggleFavoriteItem>(_onToggleFavoriteItem);
    on<SortItems>(_onSortItems);
    on<FilterStatus>(_onFilterStatus);
  }

  // При загрузке карточек
  Future<void> _onLoadItems(LoadItems event, Emitter<ItemsState> emit) async {
    emit(ItemsLoading());

    final cachedItems = await databaseHelper.getCachedItems();

    if (cachedItems.isNotEmpty && event.isRefresh == false) {
      emit(ItemsLoaded(items: cachedItems));

      // Если нет интернета
      if (!await _hasInternet()) return;
    }

    try {
      final newItems = await _fetchItems();

      if (newItems.isEmpty) {
        final currentItems = state is ItemsLoaded
            ? (state as ItemsLoaded).items
            : <Item>[];
        emit(ItemsLoaded(items: currentItems));
        return;
      }

      await databaseHelper.deleteCache();
      await databaseHelper.cacheItems(newItems);
      final cached = await databaseHelper.getCachedItems();

      emit(ItemsLoaded(items: cached));
    } catch (e) {
      final cached = await databaseHelper.getCachedItems();
      if (cached.isEmpty) {
        emit(ItemsError(e.toString()));
      } else {
        emit(ItemsLoaded(items: cached));
      }
    }
  }

  // При загрузке избранных карточек
  Future<void> _onLoadFavoriteItems(
    LoadFavoriteItems event,
    Emitter<ItemsState> emit,
  ) async {
    emit(ItemsLoading());

    try {
      final favoriteItems = await databaseHelper.getFavoriteItems();

      if (favoriteItems.isNotEmpty && event.isRefresh == false) {
        emit(ItemsLoaded(items: favoriteItems));
      }

      if (favoriteItems.isEmpty) {
        emit(ItemsEmpty());
        return;
      }

      emit(ItemsLoaded(items: favoriteItems));
    } catch (e) {
      emit(ItemsError(e.toString()));
    }
  }

  // При добавлении и удалении карточки в избранном
  Future<void> _onToggleFavoriteItem(
    ToggleFavoriteItem event,
    Emitter<ItemsState> emit,
  ) async {
    if (state is! ItemsLoaded) return;

    final currentState = state as ItemsLoaded;
    final updatedItems = currentState.items
        .map((item) {
          return item.id == event.itemId
              ? item.copyWith(favorite: !item.favorite)
              : item;
        })
        .cast<Item>()
        .toList();

    emit(ItemsLoaded(items: updatedItems));
  }

  // При сортивке
  Future<void> _onSortItems(SortItems event, Emitter<ItemsState> emit) async {
    if (state is! ItemsLoaded) return;

    final currentState = state as ItemsLoaded;

    List<Item> sortedItems = [...currentState.items];

    sortedItems.where((el) => el.favorite);
    switch (event.sortType) {
      case SortType.alphabetAsc:
        sortedItems.sort((a, b) => a.name.compareTo(b.name));
        break;
      case SortType.alphabetDesc:
        sortedItems.sort((a, b) => b.name.compareTo(a.name));
        break;
      case SortType.dateDesc:
        sortedItems.sort((a, b) => b.date.compareTo(a.date));
        break;
      case SortType.dateAsc:
        sortedItems.sort((a, b) => a.date.compareTo(b.date));
        break;
    }

    emit(currentState.copyWith(items: sortedItems));
  }

  // При фильтрации
  Future<void> _onFilterStatus(
    FilterStatus event,
    Emitter<ItemsState> emit,
  ) async {
    if (state is! ItemsLoaded) return;

    final currentState = state as ItemsLoaded;

    List<Item> filteredItems;
    final favoriteItems = await databaseHelper.getFavoriteItems();

    if (event.filter == StatusFilter.all) {
      filteredItems = favoriteItems;
    } else {
      filteredItems = favoriteItems
          .where((item) => item.status == event.filter.statusValue)
          .toList();
    }

    emit(currentState.copyWith(items: filteredItems));
  }

  // API
  Future<List<Item>> _fetchItems() async {
    final String baseUrl = dotenv.env['API_BASE_URL'] ?? '';
    await Future.delayed(const Duration(milliseconds: 500));
    final response = await http.get(Uri.parse('${baseUrl}/character'));

    final List<dynamic> data = json.decode(response.body)['results'];
    return data.map((json) => Item.fromJson(json)).toList();
  }

  Future<bool> _hasInternet() async {
    try {
      final result = await InternetAddress.lookup(
        'google.com',
      ).timeout(const Duration(seconds: 3));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }
}
