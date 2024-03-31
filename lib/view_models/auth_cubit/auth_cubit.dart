import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snake_game/models/custom_user.dart';
import 'package:snake_game/services/auth_services.dart';
import 'package:snake_game/services/firestore_services.dart';
import 'package:snake_game/utils/firestore_constants.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final AuthServices authServices = AuthServicesImpl();
  final firestoreService = FirestoreService.instance;
  CustomUser? userData;
  List<(String, int)>? scoreHistory;
  int lastScoreHistoryItemAdded = -1;
  int? maxScore;
  String? uid;
  Future<void> signInWIthEmailAndPassword(String email, String password) async {
    emit(AuthLoading());
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove("maxScore");
      prefs.remove("maxScoreDate");
      prefs.remove("name");
      prefs.remove("tmpScoresHistory");
      prefs.remove("signUpDate");

      final result =
          await authServices.signInWithEmailAndPassword(email, password);
      if (result) {
        uid = (await authServices.currentUser())!.uid;
        await initReturnedDataWithAuthSuccess("NotGuest");
        emit(AuthSuccess(userData: userData!, scoreHistory: scoreHistory!));
      } else {
        emit(AuthFailure('Faild to sign in'));
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> signUpWIthEmailAndPassword(
      String email, String password, String username) async {
    emit(AuthLoading());
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove("maxScore");
      prefs.remove("maxScoreDate");
      prefs.remove("name");
      prefs.remove("tmpScoresHistory");
      prefs.remove("signUpDate");

      bool result;
      result = await authServices.signUpWithEmailAndPassword(
          email, password, username);

      if (result) {
        String now = DateTime.now()
            .toString()
            .substring(0, DateTime.now().toString().indexOf('.'));
        uid = (await authServices.currentUser())!.uid;

        await firestoreService
            .setData(path: FirestoreConstants.userData(uid!), data: {
          "email": email,
          "maxScore": 0,
          "id": uid,
          "signUpDate": now,
          "maxScoreDate": now,
          "username": username,
        });
        firestoreService.setData(
            path: FirestoreConstants.scoresHistory(uid!), data: {"init": -1});
        userData = CustomUser.fromMap({
          "email": email,
          "maxScore": 0,
          "id": uid,
          "signUpDate": now,
          "maxScoreDate": now,
          "username": username,
        });
        await initReturnedDataWithAuthSuccess("NotGuest");

        emit(AuthSuccess(userData: userData!, scoreHistory: scoreHistory!));
      } else {
        emit(AuthFailure('Faild to sign out'));
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> signUpAsGuest() async {
    emit(AuthLoading());
    try {
      String now = DateTime.now()
          .toString()
          .substring(0, DateTime.now().toString().indexOf('.'));
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt("maxScore", 0);
      prefs.setString("maxScoreDate", now);
      prefs.setString("name", "Guest");
      prefs.setStringList("tmpScoresHistory", ["init", "-1"]);
      prefs.setString("signUpDate", now);
      userData = userData = CustomUser(
        id: "Guest",
        email: "Guest@Guest.com",
        maxScore: 0,
        maxScoreDate: now,
        signUpDate: now,
        username: "Guest",
      );
      scoreHistory = [];
      await initReturnedDataWithAuthSuccess("Guest");
      emit(
        AuthSuccess(
          userData: userData!,
          scoreHistory: scoreHistory!,
        ),
      );
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> signUpGoogleUser() async {
    emit(AuthLoading());
    try {
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      print(googleAuth);

      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth!.accessToken,
        idToken: googleAuth.idToken,
      );
      print(credential);
      UserCredential user =
          await FirebaseAuth.instance.signInWithCredential(credential);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      print(credential);
      prefs.clear();
      if (user.user != null) {
        String now = DateTime.now()
            .toString()
            .substring(0, DateTime.now().toString().indexOf('.'));
        uid = user.user!.uid;
        try {
          await initReturnedDataWithAuthSuccess("NotGuest");
        } catch (e) {
          await firestoreService
              .setData(path: FirestoreConstants.userData(uid!), data: {
            "email": user.user!.email,
            "maxScore": 0,
            "id": uid,
            "signUpDate": now,
            "maxScoreDate": now,
            "username": user.user!.displayName,
          });
          firestoreService.setData(
              path: FirestoreConstants.scoresHistory(uid!), data: {"init": -1});
          userData = CustomUser.fromMap({
            "email": user.user!.email,
            "maxScore": 0,
            "id": uid,
            "signUpDate": now,
            "maxScoreDate": now,
            "username": user.user!.displayName,
          });
        }
        await initReturnedDataWithAuthSuccess("NotGuest");

        emit(AuthSuccess(userData: userData!, scoreHistory: scoreHistory!));
      } else {
        emit(AuthFailure('Faild to sign out'));
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> signOut() async {
    emit(AuthLoading());
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (!prefs.containsKey("name")) {
        await authServices.signOut();
      }
      userData = null;
      scoreHistory = null;
      prefs.remove("maxScore");
      prefs.remove("maxScoreDate");
      prefs.remove("name");
      prefs.remove("tmpScoresHistory");
      prefs.remove("signUpDate");

      emit(AuthInitial());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> getCurrentUser() async {
    emit(AuthLoading());
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      User? user;
      if (!prefs.containsKey("name")) {
        user = await authServices.currentUser();
      }
      if (user != null) {
        uid = user.uid;
        await initReturnedDataWithAuthSuccess("NotGuest");
        emit(AuthSuccess(userData: userData!, scoreHistory: scoreHistory!));
      } else if (prefs.containsKey("name")) {
        await initReturnedDataWithAuthSuccess("Guest");
        print(prefs.containsKey("name").toString());
        emit(AuthSuccess(userData: userData!, scoreHistory: scoreHistory!));
      } else {
        emit(AuthInitial());
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> initReturnedDataWithAuthSuccess(String userType) async {
    if (userType == "Guest") {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      userData = CustomUser(
        id: "Guest",
        email: "Guest@Guest.com",
        maxScore: prefs.getInt("maxScore")!,
        maxScoreDate: prefs.getString("maxScoreDate")!,
        signUpDate: prefs.getString("signUpDate")!,
        username: "Guest",
      );
      scoreHistory = [("init", -1)];
      for (int i = prefs.getStringList("tmpScoresHistory")!.length - 1;
          i >= 3;
          i -= 2) {
        scoreHistory!.add((
          prefs.getStringList("tmpScoresHistory")![i - 1],
          int.parse(prefs.getStringList("tmpScoresHistory")![i])
        ));
      }
    } else {
      userData = CustomUser.fromMap(await firestoreService.getDocument(
        path: FirestoreConstants.userData(uid!),
        builder: (data, documentID) {
          return data;
        },
      ));
      scoreHistory = (await firestoreService.getDocument(
        path: FirestoreConstants.scoresHistory(uid!),
        builder: (data, documentID) {
          return data;
        },
      ))
          .entries
          .map((e) {
        return (e.key, e.value as int);
      }).toList();
      scoreHistory!.sort((e1, e2) => e1.$1.compareTo(e2.$1));
      scoreHistory = scoreHistory!.reversed.toList();
    }
  }

  void updateData(int score) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String now = DateTime.now()
        .toString()
        .substring(0, DateTime.now().toString().indexOf('.'));
    if (prefs.containsKey("name")) {
      scoreHistory!.insert(1, (now, score));
      if (score > prefs.getInt("maxScore")!) {
        prefs.setInt("maxScore", score);
        prefs.setString("maxScoreDate", now);
      }
      userData = userData!.copyWith(
        maxScore: score > userData!.maxScore ? score : userData!.maxScore,
        maxScoreDate: score > userData!.maxScore ? now : userData!.maxScoreDate,
      );
      prefs.setStringList(
        "tmpScoresHistory",
        prefs.getStringList("tmpScoresHistory")!
          ..add(now)
          ..add(score.toString()),
      );
      // scoreHistory = [("init", -1)];
      // prefs.remove("tmpScoresHistory");
      // prefs.setStringList("tmpScoresHistory", ["init", "-1"]);
    } else {
      if (score > userData!.maxScore) {
        firestoreService.deleteArrayItem(
          path: FirestoreConstants.allScores,
          fieldName: "${userData!.maxScore}",
          fieldValue: userData!.username,
        );
        userData = userData!.copyWith(
          maxScore: score > userData!.maxScore ? score : userData!.maxScore,
          maxScoreDate: score > userData!.maxScore
              ? DateTime.now()
                  .toString()
                  .substring(0, DateTime.now().toString().indexOf('.'))
              : userData!.maxScoreDate,
        );

        firestoreService.addArrayItem(
          path: FirestoreConstants.allScores,
          fieldName: "${userData!.maxScore}",
          fieldValue: userData!.username,
        );
        firestoreService.setData(
            path: FirestoreConstants.userData(uid!), data: userData!.toMap());
      }
      String now = DateTime.now()
          .toString()
          .substring(0, DateTime.now().toString().indexOf('.'));
      scoreHistory!.insert(1, (now, score));
      firestoreService.updateData(
        path: FirestoreConstants.scoresHistory(uid!),
        fieldName: now,
        fieldValue: score,
      );
      //  firestoreService.addArrayItem(
      //   path: FirestoreConstants.allScores,
      //   fieldName: "${userData!.maxScore}",
      //   fieldValue: userData!.username,
      // );
    }
  }

  emitAuthSuccess() {
    emit(AuthSuccess(userData: userData!, scoreHistory: scoreHistory!));
  }
  // Future<void> dataEnsurence() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String now = DateTime.now()
  //       .toString()
  //       .substring(0, DateTime.now().toString().indexOf('.'));
  //   for (int i = 0;
  //       i < prefs.getStringList("tmpScoresHistory")!.length;
  //       i += 2) {
  //     scoreHistory!.add(
  //       (
  //         prefs.getStringList("tmpScoresHistory")![i],
  //         int.parse(prefs.getStringList("tmpScoresHistory")![i + 1]),
  //       ),
  //     );
  //   }
  //   prefs.setStringList("tmpScoresHistory", []);
  //   userData = userData!.copyWith(
  //     maxScoreDate: userData!.maxScore > prefs.getInt("maxScore")!
  //         ? userData!.maxScoreDate
  //         : prefs.getString("maxScoreDate")!,
  //     maxScore: userData!.maxScore > prefs.getInt("maxScore")!
  //         ? userData!.maxScore
  //         : prefs.getInt("maxScore")!,
  //   );
  //   //  final List<ConnectivityResult> connectivityResult =
  //   //       await (Connectivity().checkConnectivity());
  //   //   if (connectivityResult.contains(ConnectivityResult.mobile) ||
  //   //       connectivityResult.contains(ConnectivityResult.wifi)) {

  //   //       }
  // }

  // Future<void> dataEnsurence() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   if (!prefs.containsKey("tmpScoresHistory")) {
  //     prefs.setStringList("tmpScoresHistory", []);
  //   }
  //   if (!prefs.containsKey("maxScore")) {
  //     prefs.setInt("maxScore", -1);
  //   }
  //   String now = DateTime.now()
  //       .toString()
  //       .substring(0, DateTime.now().toString().indexOf('.'));
  //   final List<ConnectivityResult> connectivityResult =
  //       await (Connectivity().checkConnectivity());
  //   for (int i = 0;
  //       i < prefs.getStringList("tmpScoresHistory")!.length;
  //       i += 2) {
  //     scoreHistory!.add((
  //       prefs.getStringList("tmpScoresHistory")![i],
  //       int.parse(prefs.getStringList("tmpScoresHistory")![i + 1])
  //     ));

  //     userData = userData!.copyWith(
  //         maxScoreDate: userData!.maxScore >
  //                 int.parse(prefs.getStringList("tmpScoresHistory")![i + 1])
  //             ? userData!.maxScoreDate
  //             : now);

  //     userData = userData!.copyWith(
  //         maxScore: userData!.maxScore >
  //                 int.parse(prefs.getStringList("tmpScoresHistory")![i + 1])
  //             ? userData!.maxScore
  //             : int.parse(prefs.getStringList("tmpScoresHistory")![i + 1]));
  //   }
  //   prefs.remove("tmpScoresHistory");
  //   if (connectivityResult.contains(ConnectivityResult.mobile) ||
  //       connectivityResult.contains(ConnectivityResult.wifi)) {
  //     firestoreService.deleteArrayItem(
  //       path: FirestoreConstants.allScores,
  //       fieldName: "${userData!.maxScore}",
  //       fieldValue: userData!.username,
  //     );
  //     for (int i = lastScoreHistoryItemAdded; i < scoreHistory!.length; i++) {
  //       firestoreService.updateData(
  //           path: FirestoreConstants.scoresHistory(userData!.id),
  //           fieldName: scoreHistory![i].$1,
  //           fieldValue: scoreHistory![i].$2);
  //     }
  //     firestoreService.addArrayItem(
  //       path: FirestoreConstants.allScores,
  //       fieldName: "${userData!.maxScore}",
  //       fieldValue: userData!.username,
  //     );

  //     firestoreService.deleteArrayItem(
  //       path: FirestoreConstants.allScores,
  //       fieldName: "${userData!.maxScore}",
  //       fieldValue: userData!.username,
  //     );

  //     firestoreService.addArrayItem(
  //       path: FirestoreConstants.allScores,
  //       fieldName: "${userData!.maxScore}",
  //       fieldValue: userData!.username,
  //     );

  //     firestoreService.setData(
  //         path: FirestoreConstants.userData(userData!.id),
  //         data: userData!.toMap());
  //   }
  // }
}
