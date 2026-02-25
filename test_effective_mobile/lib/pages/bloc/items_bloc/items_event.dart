abstract class ItemsEvent {}

// Загрузка карточек
class LoadItems extends ItemsEvent {
  final bool isRefresh;
  LoadItems({this.isRefresh = false});
}

// Загрузка избранных карточек
class LoadFavoriteItems extends ItemsEvent {
  final bool isRefresh;
  LoadFavoriteItems({this.isRefresh = false});
}

// Нажатие на кнопку-звездочку
class ToggleFavoriteItem extends ItemsEvent {
  final int itemId;
  ToggleFavoriteItem(this.itemId);
}

// Сортировка
enum SortType { alphabetAsc, alphabetDesc, dateDesc, dateAsc }

class SortItems extends ItemsEvent {
  final SortType sortType;
  SortItems(this.sortType);
}

// Фильтрация
enum StatusFilter { alive, dead, unknown, all }

class FilterStatus extends ItemsEvent {
  final StatusFilter filter;
  FilterStatus(this.filter);
}

extension StatusFilterExtension on StatusFilter {
  String get statusValue {
    switch (this) {
      case StatusFilter.alive:
        return "Alive";
      case StatusFilter.dead:
        return "Dead";
      case StatusFilter.unknown:
        return "unknown";
      default:
        return "";
    }
  }
}
