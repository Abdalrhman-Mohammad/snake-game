import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:snake_game/models/snake_peace.dart';
import 'package:snake_game/utils/Route/app_routes.dart';
import 'package:snake_game/view/widgets/apple.dart';
import 'package:snake_game/view/widgets/board.dart';
import 'package:snake_game/view/widgets/snake.dart';
import 'package:snake_game/view_models/auth_cubit/auth_cubit.dart';
import 'package:snake_game/view_models/figure_cubit/figure_cubit.dart';
import 'package:snake_game/view_models/playground_cubit/playground_cubit.dart';
import 'package:snake_game/view_models/snake_cubit/snake_cubit.dart';

class Playground extends StatefulWidget {
  final Size size;
  const Playground({super.key, required this.size});

  @override
  State<Playground> createState() => _PlaygroundState();
}

class _PlaygroundState extends State<Playground> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late List<SnakePeace> snakePeaces = [];
  String headDirection = "R";
  int movingTime = 500;
  int initialSnakeLength = 3;
  late double topPadding;
  late double bottomPadding;
  late double lengthSquareSide;
  late int numberOfRowCells;
  late int numberOfColumnCells;
  Offset applePosition = const Offset(5, 5);
  Offset applePastPosition = const Offset(5, 5);
  Offset? startDragging;
  Offset? endDragging;
  Set<Offset> positionsOfSnakePeaces = {};

  void initSnake() {
    snakePeaces = [];
    for (int i = 0; i < initialSnakeLength; i++) {
      snakePeaces.add(
        SnakePeace(
          animationController: _animationController,
          lengthSquareSide: lengthSquareSide,
          beginPosition: Offset((initialSnakeLength - i - 1), 0),
          endPosition: Offset((initialSnakeLength - i - 1) + 1, 0),
          index: i,
          direction: "R",
        ),
      );
      positionsOfSnakePeaces.add(Offset((initialSnakeLength - i - 1) + 1, 0));
    }
  }

  void calcs() {
    topPadding = 0;
    bottomPadding = 2.h;
    lengthSquareSide = widget.size.width / 20;
    numberOfRowCells = (widget.size.width) ~/ lengthSquareSide;
    numberOfColumnCells =
        (widget.size.height - topPadding * 2 - bottomPadding) ~/
            lengthSquareSide;
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: movingTime),
    );
    calcs();
    initSnake();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void directionDeciding(double xDiff, double yDiff) {
    if (xDiff.abs() > yDiff.abs()) {
      // if (headDirection == 'R' || headDirection == 'L') return;
      if (snakePeaces[0].beginPosition.dx != snakePeaces[0].endPosition.dx) {
        return;
      }
      if (xDiff > 0) {
        headDirection = "R";
      } else {
        headDirection = "L";
      }
    } else {
      // if (headDirection == 'D' || headDirection == 'U') return;
      if (snakePeaces[0].beginPosition.dy != snakePeaces[0].endPosition.dy) {
        return;
      }
      if (yDiff > 0) {
        headDirection = "D";
      } else {
        headDirection = "U";
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final figuresCubit = BlocProvider.of<FiguresCubit>(context);
    final playgroundCubit = BlocProvider.of<PlaygroundCubit>(context);
    final authCubit = BlocProvider.of<AuthCubit>(context);

    final snakeCubit = BlocProvider.of<SnakeCubit>(context);
    snakeCubit.startRunning();

    return Scaffold(
      // backgroundColor: Colors.green[700],
      backgroundColor: Colors.black,
      body: GestureDetector(
        onHorizontalDragStart: (details) {
          startDragging = details.localPosition;
        },
        onHorizontalDragUpdate: (details) {
          endDragging = details.localPosition;
        },
        onHorizontalDragEnd: (details) {
          double xDiff = endDragging!.dx - startDragging!.dx;
          double yDiff = endDragging!.dy - startDragging!.dy;
          directionDeciding(xDiff, yDiff);
        },
        onVerticalDragStart: (details) {
          startDragging = details.localPosition;
        },
        onVerticalDragUpdate: (details) {
          endDragging = details.localPosition;
        },
        onVerticalDragEnd: (details) {
          print(details);
          double xDiff = endDragging!.dx - startDragging!.dx;
          double yDiff = endDragging!.dy - startDragging!.dy;
          directionDeciding(xDiff, yDiff);
        },
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: (widget.size.height -
                        numberOfColumnCells * lengthSquareSide) /
                    2,
              ),
              child: Board(
                numberOfRowCells: numberOfRowCells,
                numberOfColumnCells: numberOfColumnCells,
                lengthSquareSide: lengthSquareSide,
              ),
            ),
            BlocBuilder<FiguresCubit, FiguresState>(
              bloc: figuresCubit,
              buildWhen: (previous, current) =>
                  current is FiguresChangeApplePosition,
              builder: (context, state) {
                bool found = false;
                Offset? tmpPosition;
                try {
                  while (snakePeaces.length <
                          numberOfColumnCells * numberOfRowCells &&
                      !found) {
                    tmpPosition = Offset(
                        Random().nextInt(numberOfRowCells) * 1.0 + 0,
                        Random().nextInt(numberOfColumnCells) + 0);
                    if (positionsOfSnakePeaces.contains(tmpPosition) == false) {
                      found = true;
                    }
                  }
                  applePastPosition = applePosition;
                  applePosition = tmpPosition ?? Offset(-1, -1);
                  print(applePosition);
                } catch (e) {
                  print(e.toString());
                }
                return Apple(
                  applePosition: applePosition,
                  lengthSquareSide: lengthSquareSide,
                  topPadding: (widget.size.height -
                          numberOfColumnCells * lengthSquareSide) /
                      2,
                  bottomPadding: bottomPadding,
                );
              },
            ),
            MultiBlocListener(
              listeners: [
                BlocListener<SnakeCubit, SnakeState>(
                  bloc: snakeCubit,
                  listenWhen: (previous, current) =>
                      current is SnakeStartRunning ||
                      current is SnakeCreateNewBody,
                  listener: (context, state) async {
                    if (state is SnakeStartRunning) {
                      _animationController.forward().then(
                        (value) {
                          snakeCubit.createNewBody();
                        },
                      );
                    } else if (state is SnakeCreateNewBody) {
                      if (initialSnakeLength ==
                          numberOfColumnCells * numberOfRowCells) {
                        playgroundCubit.endGame(snakePeaces.length,
                            "You are Win!", "You bigger than get a score!");
                        return;
                      }
                      positionsOfSnakePeaces.remove(
                          snakePeaces[initialSnakeLength - 1].endPosition);
                      if (snakePeaces[0]
                              .changeDirection(direction: headDirection)
                              .endPosition ==
                          applePosition) {
                        snakePeaces.add(
                          SnakePeace(
                            animationController: _animationController,
                            lengthSquareSide: lengthSquareSide,
                            beginPosition: const Offset(-1, -1),
                            endPosition: snakePeaces[initialSnakeLength - 1]
                                .beginPosition,
                            index: initialSnakeLength,
                            direction:
                                snakePeaces[initialSnakeLength - 1].direction,
                          ),
                        );
                        initialSnakeLength++;
                      }
                      for (int i = initialSnakeLength - 1; i >= 1; i--) {
                        snakePeaces[i] = snakePeaces[i].changeDirection(
                            direction: snakePeaces[i - 1].direction);
                      }
                      snakePeaces[0] = snakePeaces[0]
                          .changeDirection(direction: headDirection);

                      if (snakePeaces[0].endPosition == applePosition) {
                        Future.delayed(
                          Duration(milliseconds: movingTime ~/ 4 * 3),
                          () {
                            figuresCubit.changeApplePosition(true);
                            playgroundCubit.rebuildSnake();
                          },
                        );
                      }
                      snakeCubit.AssigningNewSnakeBody();
                      _animationController.reset();
                      if (snakePeaces[0].endPosition.dy >=
                              numberOfColumnCells ||
                          snakePeaces[0].endPosition.dx >= numberOfRowCells ||
                          snakePeaces[0].endPosition.dy < 0 ||
                          snakePeaces[0].endPosition.dx < 0) {
                        playgroundCubit.endGame(
                          figuresCubit.getScore(),
                          "Hit the wall",
                          "Your score is :",
                        );

                        return;
                      } else if (positionsOfSnakePeaces
                          .contains(snakePeaces[0].endPosition)) {
                        playgroundCubit.endGame(
                          figuresCubit.getScore(),
                          "Hitting your self!",
                          "Your score is :",
                        );
                        return;
                      }
                      snakeCubit.startRunning();
                      positionsOfSnakePeaces.add(snakePeaces[0].endPosition);
                    }
                  },
                ),
                BlocListener<PlaygroundCubit, PlaygroundState>(
                  bloc: playgroundCubit,
                  listenWhen: (previous, current) => current is EndGame,
                  listener: (context, state) async {
                    state as EndGame;
                    await Future.delayed(
                        Duration(milliseconds: movingTime ~/ 2));
                    authCubit.updateData(
                      figuresCubit.getScore());
                    showDialog(
                      context: context,
                      builder: (context) {
                        _animationController.stop();
                        return AlertDialog(
                          backgroundColor: state.title == "You are Win!"
                              ? Colors.green
                              : Colors.red[400],
                          title: Text(state.title),
                          content: Text("${state.content} ${state.score}"),
                          surfaceTintColor: Colors.black.withOpacity(0.2),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pushReplacementNamed(AppRoutes.homePage);
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "OK",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        );
                      },
                    ).whenComplete(
                      () {
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ],
              child: const SizedBox(),
            ),
            BlocBuilder<PlaygroundCubit, PlaygroundState>(
              bloc: playgroundCubit,
              buildWhen: (previous, current) => current is RebuildSnake,
              builder: (context, state) {
                print(snakePeaces.length);
                return Padding(
                  padding: EdgeInsets.only(
                    top: (widget.size.height -
                            numberOfColumnCells * lengthSquareSide) /
                        2,
                  ),
                  child: Snake(
                    snakePeaces: snakePeaces,
                  ),
                );
              },
            ),
            BlocBuilder<FiguresCubit, FiguresState>(
              bloc: figuresCubit,
              buildWhen: (previous, current) =>
                  current is FiguresChangeApplePosition,
              builder: (context, state) {
                return Positioned(
                  right: 10,
                  top: (widget.size.height -
                          numberOfColumnCells * lengthSquareSide) /
                      2,
                  child: Text(
                    "Score ${figuresCubit.getScore()}",
                    style: TextStyle(color: Colors.white),
                  ),
                );
              },
            ),
            Positioned(
              top: (widget.size.height -
                      numberOfColumnCells * lengthSquareSide) /
                  2,
              left: 10,
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      _animationController.stop();
                      return AlertDialog.adaptive(
                        backgroundColor: Colors.yellow,
                        title: const Text("Exit Game!"),
                        content: const Text("Are you sure !!!"),
                        actions: [
                          InkWell(
                            child: const Text("OK"),
                            onTap: () {
                              Navigator.of(context)
                                  .pushReplacementNamed(AppRoutes.homePage);
                            },
                          ),
                        ],
                      );
                    },
                  ).whenComplete(() {
                    snakeCubit.startRunning(); //(5)
                  });
                },
                style: ButtonStyle(
                  shape: MaterialStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  backgroundColor:
                      MaterialStatePropertyAll(Colors.green.withOpacity(00.2)),
                  foregroundColor: const MaterialStatePropertyAll(Colors.white),
                  side: const MaterialStatePropertyAll(
                    BorderSide(color: Colors.transparent),
                  ),
                ),
                child: SizedBox(
                  child: Icon(
                    Icons.menu,
                    size: 10.sp,
                    color: Colors.green[800],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
