import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snake_game/services/auth_services.dart';
import 'package:snake_game/services/firestore_services.dart';

part 'playground_state.dart';

class PlaygroundCubit extends Cubit<PlaygroundState> {
  PlaygroundCubit() : super(PlaygroundInitial());
  void rebuildSnake() {
    emit(RebuildSnake());
  }

  final firestoreService = FirestoreService.instance;
  final authServices = AuthServicesImpl();
  void endGame(
    int score,
    String title,
    String content,
  ) async {
    String now = DateTime.now()
        .toString()
        .substring(0, DateTime.now().toString().indexOf('.'));

    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // final List<ConnectivityResult> connectivityResult =
    //     await (Connectivity().checkConnectivity());
    // String now = DateTime.now()
    //     .toString()
    //     .substring(0, DateTime.now().toString().indexOf('.'));
    // if (!(connectivityResult.contains(ConnectivityResult.mobile) ||
    //     connectivityResult.contains(ConnectivityResult.wifi))) {
    //   prefs.setStringList(
    //     "tmpScoresHistory",
    //     prefs.getStringList("tmpScoresHistory")!
    //       ..addAll([now, score.toString()]), // back to ..
    //   );
    //   prefs.setInt(
    //     "maxScore",
    //     prefs.getInt("maxScore")! > score ? prefs.getInt("maxScore")! : score,
    //   );
    // } else {
    //   final user = await authServices.currentUser();
    //   final customUserData = await firestoreService.getDocument(
    //     path: FirestoreConstants.userData(user!.uid),
    //     builder: (data, documentID) {
    //       return data;
    //     },
    //   );
    //   firestoreService.deleteArrayItem(
    //     path: FirestoreConstants.allScores,
    //     fieldName: "${customUserData["maxScore"]}",
    //     fieldValue: customUserData["username"],
    //   );
    //   for (int i = 0;
    //       i < prefs.getStringList("tmpScoresHistory")!.length;
    //       i += 2) {
    //     firestoreService.updateData(
    //         path: FirestoreConstants.scoresHistory(user.uid),
    //         fieldName: prefs.getStringList("tmpScoresHistory")![i],
    //         fieldValue:
    //             int.parse(prefs.getStringList("tmpScoresHistory")![i + 1]));

    //     customUserData["maxScoreDate"] = customUserData["maxScore"] >
    //             int.parse(prefs.getStringList("tmpScoresHistory")![i + 1])
    //         ? customUserData["maxScoreDate"]
    //         : now;

    //     customUserData["maxScore"] = customUserData["maxScore"] >
    //             int.parse(prefs.getStringList("tmpScoresHistory")![i + 1])
    //         ? customUserData["maxScore"]
    //         : int.parse(prefs.getStringList("tmpScoresHistory")![i + 1]);
    //   }
    //   prefs.remove("tmpScoresHistory");
    //   firestoreService.addArrayItem(
    //     path: FirestoreConstants.allScores,
    //     fieldName: "${customUserData["maxScore"]}",
    //     fieldValue: customUserData["username"],
    //   );
    //   firestoreService.deleteArrayItem(
    //     path: FirestoreConstants.allScores,
    //     fieldName: "${customUserData["maxScore"]}",
    //     fieldValue: customUserData["username"],
    //   );
    //   firestoreService.updateData(
    //       path: FirestoreConstants.scoresHistory(user.uid),
    //       fieldName: now,
    //       fieldValue: score);

    //   customUserData["maxScoreDate"] = customUserData["maxScore"] > score
    //       ? customUserData["maxScoreDate"]
    //       : DateTime.now().toString();

    //   customUserData["maxScore"] = customUserData["maxScore"] > score
    //       ? customUserData["maxScore"]
    //       : score;

    //   firestoreService.addArrayItem(
    //     path: FirestoreConstants.allScores,
    //     fieldName: "${customUserData["maxScore"]}",
    //     fieldValue: customUserData["username"],
    //   );

    //   firestoreService.setData(
    //       path: FirestoreConstants.userData(user.uid), data: customUserData);
    // }
    emit(EndGame(
      score: score,
      title: title,
      content: content,
    ));
    // animationController.dispose();
  }
}
