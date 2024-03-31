part of 'scoreboard_cubit.dart';

sealed class ScoreboardState {}

final class ScoreboardInitial extends ScoreboardState {}

final class ScoreboardLoading extends ScoreboardState {}

final class ScoreboardUpdated extends ScoreboardState {
  final List<(String, int)> top10;

  ScoreboardUpdated({required this.top10});
}

final class ScoreboardError extends ScoreboardState {
  final String message;

  ScoreboardError({required this.message});
}
