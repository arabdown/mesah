abstract class SearchEvent {}

class OnSearch extends SearchEvent {
  final String keyword;
  OnSearch({required this.keyword});
}
