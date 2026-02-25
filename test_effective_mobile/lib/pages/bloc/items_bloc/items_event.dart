abstract class ItemsEvent {}

class LoadItems extends ItemsEvent {
  final bool isRefresh;
  LoadItems({this.isRefresh = false});
}

class LoadFavoriteItems extends ItemsEvent {
  final bool isRefresh;
  LoadFavoriteItems({this.isRefresh = false});
}

class ToggleFavoriteItem extends ItemsEvent {
  final int itemId;
  ToggleFavoriteItem(this.itemId);
}

enum SortType { alphabetAsc, alphabetDesc, dateDesc, dateAsc }

class SortItems extends ItemsEvent {
  final SortType sortType;
  SortItems(this.sortType);
}

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
