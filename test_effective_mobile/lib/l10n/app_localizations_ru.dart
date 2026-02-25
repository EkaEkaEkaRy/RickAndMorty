// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get settings => 'Настройки';

  @override
  String get dark_theme => 'Темная тема';

  @override
  String get light_theme => 'Светлая тема';

  @override
  String get home => 'Главная';

  @override
  String get favorite => 'Избранное';

  @override
  String get error => 'Ошибка';

  @override
  String get empty_list => 'Нет карточек';

  @override
  String get sort => 'Сортировка';

  @override
  String get date_new => 'Дата (новые)';

  @override
  String get date_old => 'Дата (старые)';

  @override
  String get name_abs => 'A → Z';

  @override
  String get name_desc => 'Z → A';

  @override
  String get all => 'Всё';
}
