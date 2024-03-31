import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snake_game/utils/Route/app_routes.dart';
import 'package:snake_game/utils/app_colors.dart';
import 'package:snake_game/utils/space.dart';
import 'package:snake_game/view/widgets/main_button.dart';
import 'package:snake_game/view/widgets/score_history_widget.dart';
import 'package:snake_game/view_models/auth_cubit/auth_cubit.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    final authCubit = BlocProvider.of<AuthCubit>(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            "assets/images/jens-granstrom-highresscreenshot00000.jpg",
            height: 10000,
            width: 10000,
            fit: BoxFit.cover,
          ),
          Center(
            child: BlocBuilder<AuthCubit, AuthState>(
              bloc: authCubit,
              buildWhen: (previous, current) =>
                  current is AuthFailure ||
                  current is AuthLoading ||
                  current is AuthInitial ||
                  current is AuthSuccess,
              builder: (context, state) {
                print(state.toString() + "-------------------janem");
                Widget show = SizedBox(child: Text("Something went wrong"));
                if (state is AuthLoading) {
                  show = const CircularProgressIndicator.adaptive();
                } else if (state is AuthSuccess) {
                  // print(state.scoreHistory.toString() +
                  //     "------------------------------------janem");
                  final user = state.userData;
                  show = DefaultTabController(
                    length: 3,
                    child: Column(
                      children: [
                        DecoratedBox(
                          decoration: BoxDecoration(
                              color: AppColors.brown.withOpacity(0.9)),
                          child: const TabBar(
                            labelColor: Colors.black,
                            dividerColor: Colors.transparent,
                            indicatorColor: Colors.transparent,
                            tabs: [
                              Text("Account Information"),
                              Text("Scores history"),
                              Text("General"),
                            ],
                          ),
                        ),
                        Expanded(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.5),
                            ),
                            child: TabBarView(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Username : ",
                                            style: TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.grey2,
                                            ),
                                          ),
                                          Text(
                                            user.username,
                                            style: TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.grey2,
                                            ),
                                          ),
                                        ],
                                      ),
                                      verticalSpace(20),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Max Score : ",
                                            style: TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.grey2,
                                            ),
                                          ),
                                          Text(
                                            user.maxScore.toString(),
                                            style: TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.grey2,
                                            ),
                                          ),
                                        ],
                                      ),
                                      verticalSpace(20),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Max score Date : ",
                                            style: TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.grey2,
                                            ),
                                          ),
                                          Text(
                                            user.maxScoreDate,
                                            style: TextStyle(
                                              fontSize: 28,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.grey2,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Score History",
                                      style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.grey,
                                      ),
                                    ),
                                    ScoreHistoryWidget(
                                      scoreHistory: state.scoreHistory,
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (user.username != "Anonymous")
                                      MainButton(
                                        child: const Text("Sign Out"),
                                        onPressed: () async {
                                          await authCubit.signOut();
                                          Navigator.pushReplacementNamed(
                                              context, AppRoutes.authPage);
                                        },
                                      ),
                                    if (user.username == "Anonymous")
                                      Column(
                                        children: [
                                          MainButton(
                                            child: const Text("Sign In"),
                                            onPressed: () {
                                              Navigator.pushNamed(
                                                  context, AppRoutes.signIn);
                                            },
                                          ),
                                          verticalSpace(size.height / 30),
                                          MainButton(
                                            child: const Text("Sign Up"),
                                            onPressed: () {
                                              Navigator.pushNamed(
                                                  context, AppRoutes.signUp);
                                            },
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        MainButton(
                          color: AppColors.brown2.withOpacity(0.6),
                          borderRadius: 0,
                          width: double.infinity,
                          child: Text(
                            "Back",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )
                      ],
                    ),
                  );
                }
                return show;
              },
            ),
          ),
        ],
      ),
    );
  }
}
