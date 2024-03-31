import 'package:flutter_bloc/flutter_bloc.dart';

part 'snake_state.dart';

class SnakeCubit extends Cubit<SnakeState> {
  SnakeCubit() : super(SnakeInitial());
  void startRunning() {
    emit(SnakeStartRunning());
  }

  void AssigningNewSnakeBody() {
    emit(SnakeBodyAssigning());
  }

  void createNewBody() {
    emit(SnakeCreateNewBody());
  }
}
/*

  void stopRunning() {
    emit(SnakeStopRunning());
  }

  void running() {
    emit(SnakeRuning());
  }

  void stoped() {
    emit(SnakeStopped());
  }

  void startAssigningNewSnakeBody() {
    emit(SnakeBodyAssign());
  }



*/