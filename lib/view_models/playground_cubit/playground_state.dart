part of 'playground_cubit.dart';

sealed class PlaygroundState {}

final class PlaygroundInitial extends PlaygroundState {}

final class RebuildSnake extends PlaygroundState {}

final class EndGame extends PlaygroundState {
  final int score;
  final String title;
  final String content;

  EndGame({required this.title, required this.content, required this.score});
}
