import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snake_game/services/firestore_services.dart';
import 'package:snake_game/utils/firestore_constants.dart';

part 'scoreboard_state.dart';

class ScoreboardCubit extends Cubit<ScoreboardState> {
  ScoreboardCubit() : super(ScoreboardInitial());
  final firestoreService = FirestoreService.instance;
  void setLoadingState() {
    emit(ScoreboardLoading());
  }

  void getUpdate() async {
    try {
      List<(String, int)> top10 = [];
      final allData = await firestoreService.getDocument(
        path: FirestoreConstants.allScores,
        builder: (data, documentID) {
          return data;
        },
      );
      final scores = allData.keys.map((key) {
        return int.parse(key);
      }).toList();
      scores.sort();
      for (int i = scores.length - 1; i >= 0; i--) {

        for (int j = 0; j < (allData["${scores[i]}"] as List).length; j++) {
          top10.add((allData["${scores[i]}"][j], scores[i]));
          if (top10.length == 10) break;
        }
        if (top10.length == 10) break;
      }
      print(top10);
      emit(ScoreboardUpdated(top10: top10));
    } catch (e) {
      return emit(ScoreboardError(message: e.toString()));
    }
  }
}
