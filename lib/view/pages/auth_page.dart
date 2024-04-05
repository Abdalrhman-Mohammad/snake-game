import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snake_game/utils/Route/app_routes.dart';
import 'package:snake_game/utils/app_colors.dart';
import 'package:snake_game/utils/space.dart';
import 'package:snake_game/view/widgets/main_button.dart';
import 'package:snake_game/view_models/auth_cubit/auth_cubit.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authCubit = BlocProvider.of<AuthCubit>(context);
    // if (authCubit.state is AuthSuccess) {
    //   print(authCubit.state);
    // }
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MainButton(
                  color: AppColors.brown.withOpacity(0.7),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/images/google.png", width: 22),
                      horizontalSpace(5),
                      Text(
                        "Sign in with Google",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  onPressed: () {
                    authCubit.signUpGoogleUser().then((value) {
                      Navigator.pushNamed(context, AppRoutes.homePage);
                    });
                  },
                ),
                verticalSpace(size.height / 30),
                MainButton(
                  color: AppColors.brown.withOpacity(0.7),
                  child: Text(
                    "Play As a Guest",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  onPressed: () async {
                    authCubit.signUpAsGuest();
                    Navigator.pushNamed(context, AppRoutes.homePage);
                  },
                ),
              ],
            ),
          ),
          BlocListener<AuthCubit, AuthState>(
            listenWhen: (previous, current) => current is AuthSuccess,
            listener: (context, state) {
              print("ajlds--------------------------------");
              Navigator.pushReplacementNamed(context, AppRoutes.homePage);
            },
            child: SizedBox(),
          ),
        ],
      ),
    );
  }
}
