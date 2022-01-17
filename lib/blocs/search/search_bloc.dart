import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:listar_flutter_pro/blocs/bloc.dart';
import 'package:listar_flutter_pro/configs/config.dart';
import 'package:listar_flutter_pro/repository/list_repository.dart';
import 'package:rxdart/rxdart.dart';

import 'bloc.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(InitialSearchState());

  @override
  Stream<Transition<SearchEvent, SearchState>> transformEvents(
    events,
    transitionFn,
  ) {
    final nonDebounceStream = events.where((event) => event is! OnSearch);
    final debounceStream = events.where((event) {
      return event is OnSearch;
    }).debounceTime(
      const Duration(milliseconds: 1000),
    );
    return super.transformEvents(
      MergeStream([nonDebounceStream, debounceStream]),
      transitionFn,
    );
  }

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    if (event is OnSearch && event.keyword.isNotEmpty) {
      yield SearchLoading();
      final result = await ListRepository.loadList(
        keyword: event.keyword,
        perPage: ListSetting.perPage,
        page: 1,
      );
      if (result != null) {
        yield SearchSuccess(list: result[0]);
      }
    }
  }
}
