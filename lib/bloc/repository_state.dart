import 'package:equatable/equatable.dart';

import '../models/repository.dart';

abstract class RepositoryState extends Equatable {
  const RepositoryState();

  @override
  List<Object> get props => [];
}

class RepositoryInitial extends RepositoryState {}
class RepositoryLoadInProgress extends RepositoryState {}
class RepositoryLoadSuccess extends RepositoryState {
  final List<Repository> repositories;

  const RepositoryLoadSuccess(this.repositories);

  @override
  List<Object> get props => [repositories];
}
class RepositoryLoadFailure extends RepositoryState {}