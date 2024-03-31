import 'package:flutter/material.dart';
import 'package:snake_game/utils/Route/app_routes.dart';
import 'package:snake_game/view/pages/auth_page.dart';
import 'package:snake_game/view/pages/home_page.dart';
import 'package:snake_game/view/pages/login_page.dart';
import 'package:snake_game/view/pages/playground.dart';
import 'package:snake_game/view/pages/settings.dart';
import 'package:snake_game/view/pages/signup.dart';
import 'package:snake_game/view_models/figure_cubit/figure_cubit.dart';
import 'package:snake_game/view_models/playground_cubit/playground_cubit.dart';
import 'package:snake_game/view_models/snake_cubit/snake_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.homePage:
        return MaterialPageRoute(
          builder: (context) {
            return const HomePage();
          },
        );

      case AppRoutes.playground:
        return MaterialPageRoute(
          builder: (context) {
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) {
                    final cubit = SnakeCubit();
                    cubit.startRunning();
                    return cubit;
                  },
                ),
                BlocProvider(
                  create: (context) {
                    final figuresCubit = FiguresCubit();
                    figuresCubit.changeApplePosition(false);
                    return figuresCubit;
                  },
                ),
                BlocProvider(
                  create: (context) {
                    final playgroundCubit = PlaygroundCubit();
                    return playgroundCubit;
                  },
                ),
              ],
              child: Playground(size: MediaQuery.of(context).size),
            );
          },
        );
      case AppRoutes.settings:
        return MaterialPageRoute(
          builder: (context) {
            return const Settings();
          },
        );
      case AppRoutes.signIn:
        return MaterialPageRoute(
          builder: (context) {
            return const LoginPage();
          },
        );
      case AppRoutes.signUp:
        return MaterialPageRoute(
          builder: (context) {
            return const Signup();
          },

        );
      case AppRoutes.authPage:
        return MaterialPageRoute(
          builder: (context) {
            return const AuthPage();
          },
        );
      default:
        return MaterialPageRoute(
          builder: (context) {
            return const Scaffold(
              body: Center(
                child: Text("Unkown Page"),
              ),
            );
          },
        );
    }
  }
}
