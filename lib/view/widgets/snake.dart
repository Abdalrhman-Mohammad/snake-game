import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snake_game/models/snake_peace.dart';
import 'package:snake_game/view_models/playground_cubit/playground_cubit.dart';
import 'package:snake_game/view_models/snake_cubit/snake_cubit.dart';

class Snake extends StatelessWidget {
  final List<SnakePeace> snakePeaces;
  const Snake({super.key, required this.snakePeaces});

  @override
  Widget build(BuildContext context) {
    // (1)(2)(3)(4) can called nither (5) , no different because i don't use setState and the player will not make save for project frequantly (LOL)
    // bool gameState = false; // true-> started , false-> stopped    (1)
    final snakeCubit = BlocProvider.of<SnakeCubit>(context);
    snakeCubit.startRunning(); //(5)

    final playgroundCubit = BlocProvider.of<PlaygroundCubit>(context);

    return Stack(
      fit: StackFit.passthrough,
      children: snakePeaces.map(
        (snakePeace) {
          return BlocBuilder<SnakeCubit, SnakeState>(
            buildWhen: (previous, current) => current is SnakeBodyAssigning,
            builder: (context, state) {
              return snakePeaces[snakePeace.index];
            },
          );
        },
      ).toList(),
    );
    // if (!gameState) {   (2)
    //   gameState = true; (3)
    // }                   (4)
    // return ret;
  }
}
