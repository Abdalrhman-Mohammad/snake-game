import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snake_game/utils/Route/app_routes.dart';
import 'package:snake_game/utils/app_colors.dart';
import 'package:snake_game/view/widgets/main_button.dart';
import 'package:snake_game/view_models/auth_cubit/auth_cubit.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  bool _visablePassword = false;
  Future<void> login() async {
    if (_formKey.currentState!.validate()) {
      print("login");
      print(_emailController.text + " " + _passwordController.text);
      await BlocProvider.of<AuthCubit>(context).signInWIthEmailAndPassword(
        _emailController.text,
        _passwordController.text,
      );
      print(_emailController.text + " " + _passwordController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authCubit = BlocProvider.of<AuthCubit>(context);
    print(authCubit);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Text(
                  "Login Account",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  "Please login with registered account",
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .copyWith(color: AppColors.grey),
                ),
                const SizedBox(height: 24),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Email or Phone Number",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          prefixIcon: const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Icon(Icons.message_outlined,
                                color: AppColors.grey),
                          ),
                          hintText: "Enter your email or phone number",
                          hintStyle:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    color: AppColors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                          fillColor: AppColors.grey2.withOpacity(0.4),
                          filled: true,
                        ),
                        validator: (email) {
                          print(email);
                          if (email == null || email.isEmpty) {
                            return "Please enter your email or phone number";
                          }

                          final bool emailValid = RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(email);
                          if (!emailValid) {
                            return "Please enter a valid email or phone number";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        "Password",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        obscureText:
                            !_visablePassword, //This will obscure text dynamically

                        controller: _passwordController,
                        decoration: InputDecoration(
                          prefixIcon: const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Icon(Icons.lock_outlined,
                                color: AppColors.grey),
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _visablePassword = !_visablePassword;
                              });
                            },
                            icon: Icon(
                              _visablePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: AppColors.grey,
                            ),
                          ),
                          hintText: "Enter your Password",
                          hintStyle:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    color: AppColors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                          fillColor: AppColors.grey2.withOpacity(0.4),
                          filled: true,
                        ),
                        validator: (password) {
                          // if (password == null || password.isEmpty) {
                          //   return "Please enter your password";
                          // }
                          // final bool passwordValid = RegExp(
                          //         r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                          //     .hasMatch(password);
                          // if (!passwordValid) {
                          //   return "Please enter a valid password";
                          // }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.signIn);
                        },
                        child: const Text("Sign Up"),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text("Forget Password?"),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                BlocConsumer<AuthCubit, AuthState>(
                  bloc: authCubit,
                  listenWhen: (pervios, current) =>
                      current is AuthFailure ||
                      (current is AuthSuccess &&
                          current.userData.username != "Anonymous"),
                  listener: (context, state) {
                    print("----------------------------------------------");
                    if (state is AuthFailure) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Error"),
                            content: Text(state.error),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("Ok"),
                              ),
                            ],
                          );
                        },
                      );
                    } else if (state is AuthSuccess) {
                      Navigator.pushReplacementNamed(
                          context, AppRoutes.homePage);
                    }
                  },
                  buildWhen: (pervios, current) =>
                      current is AuthInitial ||
                      current is AuthLoading ||
                      current is AuthFailure ||
                      current is AuthSuccess,
                  builder: (context, state) {
                    if (state is AuthLoading) {
                      return Center(
                        child: const MainButton(
                          height: 55,
                          child: CircularProgressIndicator.adaptive(),
                        ),
                      );
                    } else {
                      return Center(
                        child: MainButton(
                          child: Text("Sign in"),
                          height: 55,
                          onPressed: login,
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Or using other method",
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: AppColors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton.icon(
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(0),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          side: BorderSide(
                            color: AppColors.grey2,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                    ),
                    onPressed: () {},
                    icon: Image.asset("assets/images/google.png", width: 22),
                    label: Text(
                      "Sign in with Google",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 60,
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(0),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          side: BorderSide(
                            color: AppColors.grey2,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                    ),
                    onPressed: () {},
                    icon: Image.asset("assets/images/facebook.png", width: 22),
                    label: Text(
                      "Sign in with Facebook",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ),
                const Align(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Text(
                        "ready account:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text("a@a.com"),
                      Text("aA111@@@"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
