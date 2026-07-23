import 'package:equatable/equatable.dart';

enum SelectedBottomNavigationPage {
  home,
  placeholderOne,
  placeholderTwo,
  settings,
}

class BottomNavigationState extends Equatable {
  final SelectedBottomNavigationPage page;

  const BottomNavigationState({
    required this.page,
  });

  @override
  List<Object?> get props => [page];
}
