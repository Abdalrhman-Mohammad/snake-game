import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:snake_game/firebase_options.dart';
import 'package:snake_game/utils/Route/app_router.dart';
import 'package:snake_game/utils/Route/app_routes.dart';
import 'package:snake_game/view_models/auth_cubit/auth_cubit.dart';
import 'package:snake_game/view_models/scoreboard_cubit/scoreboard_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
  //   statusBarColor: Colors.transparent, // Status bar color
  // ));
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ],
  );
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) {
                final cubit = AuthCubit();
                cubit.getCurrentUser();
                return cubit;
              },
            ),
            BlocProvider(
              create: (context) {
                final cubit = ScoreboardCubit();
                cubit.setLoadingState();
                cubit.getUpdate();

                return cubit;
              },
            ),
          ],
          child: Builder(builder: (context) {
            return BlocBuilder<AuthCubit, AuthState>(
              bloc: BlocProvider.of<AuthCubit>(context),
              buildWhen: (previous, current) =>
                  current is AuthInitial ||
                  current is AuthSuccess ||
                  current is AuthLoading ||
                  current is AuthFailure,
              builder: (context, state) {
                print(state);
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  initialRoute: state is AuthSuccess
                      ? AppRoutes.homePage
                      : AppRoutes.authPage,
                  onGenerateRoute: AppRouter.onGenerateRoute,
                );
              },
            );
          }),
        );
      },
    );
  }
}
