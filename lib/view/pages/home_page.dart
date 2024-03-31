import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:snake_game/services/auth_services.dart';
import 'package:snake_game/utils/Route/app_routes.dart';
import 'package:snake_game/utils/space.dart';
import 'package:snake_game/view/widgets/main_button.dart';
import 'package:snake_game/view_models/auth_cubit/auth_cubit.dart';
import 'package:snake_game/view_models/scoreboard_cubit/scoreboard_cubit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void fun() async {
    print((await AuthServicesImpl().currentUser()).toString() +
        "-------------------------------");
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scoreboardCubit = BlocProvider.of<ScoreboardCubit>(context);
    final authCubit = BlocProvider.of<AuthCubit>(context);
    scoreboardCubit.getUpdate();

    fun();
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/images/jens-granstrom-highresscreenshot00000.jpg",
            height: 10000,
            width: 10000,
            fit: BoxFit.cover,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MainButton(
                  child: const Text("Play"),
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.playground).then(
                      (value) {
                        authCubit.emitAuthSuccess();
                        scoreboardCubit.getUpdate();
                      },
                    );
                  },
                ),
                verticalSpace(size.height / 30),
                MainButton(
                  child: const Text("Settings"),
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.settings);
                    // .then(
                    //   (value) => scoreboardCubit.getUpdate(),
                    // );
                  },
                ),
              ],
            ),
          ),
          Positioned(
            height: 140.h,
            width: 80.w,
            top: 0,
            right: 0,
            child: DecoratedBox(
              decoration: BoxDecoration(color: Colors.black.withOpacity(0.4)),
              child: Center(
                child: BlocBuilder<ScoreboardCubit, ScoreboardState>(
                  bloc: scoreboardCubit,
                  buildWhen: (previous, current) =>
                      current is ScoreboardLoading ||
                      current is ScoreboardUpdated,
                  builder: (context, state) {
                    if (state is ScoreboardLoading) {
                      return const CircularProgressIndicator.adaptive();
                    } else if (state is ScoreboardUpdated) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: state.top10
                              .map((e) => Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        e.$1,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 3.sp,
                                        ),
                                      ),
                                      Text(
                                        "${e.$2}",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 3.sp,
                                        ),
                                      ),
                                    ],
                                  ))
                              .toList(),
                        ),
                      );
                    } else {
                      return const Text(
                        "Global Scoreboard...",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 8,
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
