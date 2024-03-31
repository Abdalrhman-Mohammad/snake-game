part of 'snake_cubit.dart';

sealed class SnakeState {}

final class SnakeInitial extends SnakeState {}

final class SnakeStartRunning extends SnakeState {}

final class SnakeBodyAssigning extends SnakeState {}

final class SnakeCreateNewBody extends SnakeState {}


/*

final class SnakeBodyAssign extends SnakeState {}

final class SnakeStop extends SnakeState {}

final class SnakeBuildAndAssignNewBody extends SnakeState {}
 

final class SnakeStopRunning extends SnakeState {}

final class SnakeRuning extends SnakeState {}

final class SnakeStopped extends SnakeState {}

final class SnakeBodyAssigning extends SnakeState {}

final class SnakeBodyAssign extends SnakeState {}

final class SnakeStop extends SnakeState {}

final class SnakeCreateNewBody extends SnakeState {}


*/