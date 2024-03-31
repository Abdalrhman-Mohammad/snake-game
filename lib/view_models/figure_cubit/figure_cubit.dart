import 'package:flutter_bloc/flutter_bloc.dart';

part 'figure_state.dart';

class FiguresCubit extends Cubit<FiguresState> {
  FiguresCubit() : super(FiguresInitial());
  int playerScore = 0;
  void changeApplePosition(bool add) {
    playerScore += add ? 1 : 0;
    emit(FiguresChangeApplePosition());
  }

  int getScore() {
    return playerScore;
  }
}
