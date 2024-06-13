import 'package:equatable/equatable.dart';

abstract class RepositoryEvent extends Equatable {
  const RepositoryEvent();

  @override
  List<Object> get props => [];
}

class FetchRepositories extends RepositoryEvent {}
class RefreshRepositories extends RepositoryEvent {}




