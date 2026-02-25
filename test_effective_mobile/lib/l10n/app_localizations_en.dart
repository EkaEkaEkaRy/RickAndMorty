// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get settings => 'Settings';

  @override
  String get dark_theme => 'Dark theme';

  @override
  String get light_theme => 'Light theme';

  @override
  String get home => 'Home';

  @override
  String get favorite => 'Favorite';

  @override
  String get error => 'Error';

  @override
  String get empty_list => 'No cards';

  @override
  String get sort => 'Sort';

  @override
  String get date_new => 'Date (new)';

  @override
  String get date_old => 'Date (old)';

  @override
  String get name_abs => 'A → Z';

  @override
  String get name_desc => 'Z → A';

  @override
  String get all => 'All';
}
