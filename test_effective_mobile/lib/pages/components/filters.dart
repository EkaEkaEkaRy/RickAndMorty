import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_effective_mobile/l10n/app_localizations.dart';
import 'package:test_effective_mobile/pages/bloc/items_bloc/items_bloc.dart';
import 'package:test_effective_mobile/pages/bloc/items_bloc/items_event.dart';
import 'package:test_effective_mobile/pages/bloc/items_bloc/items_state.dart';

class Filters extends StatefulWidget {
  Filters({super.key});

  @override
  State<Filters> createState() => FiltersState();
}

class FiltersState extends State<Filters> {
  SortType? sort_value = SortType.dateDesc;
  StatusFilter? filter_value = StatusFilter.all;

  void resetFilters() {
    setState(() {
      sort_value = SortType.dateDesc;
      filter_value = StatusFilter.all;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.sort),
        SizedBox(width: 4.0),
        // Сортировка
        Expanded(
          flex: 1,
          child: DropdownButton<SortType>(
            isExpanded: true,
            value: sort_value,
            items: [
              DropdownMenuItem(
                value: SortType.alphabetAsc,
                child: Text(AppLocalizations.of(context)!.name_abs),
              ),
              DropdownMenuItem(
                value: SortType.alphabetDesc,
                child: Text(AppLocalizations.of(context)!.name_desc),
              ),
              DropdownMenuItem(
                value: SortType.dateDesc,
                child: Text(AppLocalizations.of(context)!.date_new),
              ),
              DropdownMenuItem(
                value: SortType.dateAsc,
                child: Text(AppLocalizations.of(context)!.date_old),
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  sort_value = value;
                });
                context.read<ItemsBloc>().add(SortItems(value));
              }
            },
          ),
        ),
        SizedBox(width: 16.0),
        Icon(Icons.tune),
        // Фильрт по статусу
        Expanded(
          flex: 1,
          child: BlocBuilder<ItemsBloc, ItemsState>(
            builder: (context, state) {
              return DropdownButton<StatusFilter>(
                isExpanded: true,
                value: filter_value,
                items: [
                  DropdownMenuItem(
                    value: StatusFilter.all,
                    child: Text(AppLocalizations.of(context)!.all),
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
                  setState(() {
                    filter_value = value;
                    sort_value = SortType.dateDesc;
                  });
                  if (value != null) {
                    context.read<ItemsBloc>().add(FilterStatus(value));
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
