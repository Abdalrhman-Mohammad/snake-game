// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:snake_game/models/cell.dart';
// import 'package:snake_game/models/snake_peace.dart';
// import 'package:snake_game/view/widgets/board.dart';
// import 'package:snake_game/view/widgets/snake.dart';
// import 'package:snake_game/view_models/figure_cubit/figure_cubit.dart';
// import 'package:snake_game/view_models/playground_cubit/playground_cubit.dart';
// import 'package:snake_game/view_models/snake_cubit/snake_cubit.dart';

// class Playground extends StatefulWidget {
//   final size;
//   const Playground({super.key, required this.size});

//   @override
//   State<Playground> createState() => _PlaygroundState();
// }

// class _PlaygroundState extends State<Playground> with TickerProviderStateMixin {
//   List<Cell> gridCells = [];
//   late AnimationController _animationController;
//   late List<SnakePeace> snakePeaces = [];
//   late List<SnakePeace> newSnakePeaces = [];
//   String headDirection = "R";
//   int movingTime = 1000;
//   int initialSnakeLength = 2;
//   late double padding;
//   late double lengthSquareSide;
//   late int numberOfRowCells;
//   late int numberOfColumnCells;
//   Offset applePosition = const Offset(5, 5);
//   Offset applePastPosition = const Offset(5, 5);
//   Offset? startDragging;
//   Offset? endDragging;
//   bool gameState = false; // true-> started , false-> stopped

//   void initGrid() {
//     gridCells = [];
//     for (int index = 0;
//         index < numberOfRowCells * numberOfColumnCells;
//         index++) {
//       Color selectedColor;
//       int row = index ~/ numberOfRowCells;
//       int col = index % numberOfRowCells + 1;
//       if (row % 2 == 0) {
//         if (col % 2 == 0) {
//           selectedColor = Colors.green;
//         } else {
//           selectedColor = Colors.green.shade300;
//         }
//       } else {
//         if (col % 2 == 0) {
//           selectedColor = Colors.green.shade300;
//         } else {
//           selectedColor = Colors.green;
//         }
//       }
//       gridCells.add(
//         Cell(
//           color: selectedColor,
//           sideLong: lengthSquareSide,
//         ),
//       );
//       // print("index: $index");
//       // print(gridCells.length);
//     }
//   }

//   void initSnake() {
//     // snakePeaces = [];
//     // for (int i = 0; i < initialSnakeLength; i++) {
//     //   snakePeaces.add(
//     //     SnakePeace(
//     //       animationController: _animationController,
//     //       lengthSquareSide: lengthSquareSide,
//     //       beginPosition: Offset((initialSnakeLength - i - 1), 0),
//     //       endPosition: Offset((initialSnakeLength - i - 1) + 1, 0),
//     //       index: i,
//     //       direction: "R",
//     //     ),
//     //   );
//     // }
//     // newSnakePeaces = snakePeaces.toList();

//     // snake[0] = snake[0].copyWith(
//     //   direction: "D",
//     //   color: Colors.black,
//     //   beginPosition: Offset(3, 0),
//     //   endPosition: Offset(3, 1),
//     // );

//     ////////////////////////////////////////////////
//     newSnakePeaces = [];
//     for (int i = 0; i < initialSnakeLength; i++) {
//       newSnakePeaces.add(
//         SnakePeace(
//           animationController: _animationController,
//           lengthSquareSide: lengthSquareSide,
//           beginPosition: Offset((initialSnakeLength - i - 1), 0),
//           endPosition: Offset((initialSnakeLength - i - 1) + 1, 0),
//           index: i,
//           direction: "R",
//         ),
//       );
//     }
//     // // snake[0] = snake[0].copyWith(
//     // //   direction: "D",
//     // //   color: Colors.black,
//     // //   beginPosition: Offset(3, 0),
//     // //   endPosition: Offset(3, 1),
//     // // );
//     // // newSnakePeaces = snakePeaces.toList();
//   }

//   void calcs() {
//     padding = widget.size.width / 60;
//     lengthSquareSide = 30;
//     numberOfRowCells = (widget.size.width - padding * 2) ~/ lengthSquareSide;
//     numberOfColumnCells =
//         (widget.size.height - padding * 2) ~/ lengthSquareSide;
//   }

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: movingTime),
//     );
//     calcs();
//     initGrid();
//     initSnake();
//     // cubut.startRunning();
//   }

//   void directionDeciding(double xDiff, double yDiff) {
//     // print(xDiff.abs());
//     // print(yDiff.abs());
//     if (xDiff.abs() > yDiff.abs()) {
//       if (xDiff > 0) {
//         headDirection = "R";
//       } else {
//         headDirection = "L";
//       }
//     } else {
//       if (yDiff > 0) {
//         headDirection = "D";
//       } else {
//         headDirection = "U";
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final figuresCubit = BlocProvider.of<FiguresCubit>(context);
//     final playgroundCubit = BlocProvider.of<PlaygroundCubit>(context);

//     final snakeCubit = BlocProvider.of<SnakeCubit>(context);
//     snakeCubit.startRunning();

//     return Scaffold(
//       backgroundColor: Colors.green[700],
//       body: Padding(
//         padding: EdgeInsets.all(padding),
//         child: GestureDetector(
//           onHorizontalDragStart: (details) {
//             startDragging = details.localPosition;
//           },
//           onHorizontalDragUpdate: (details) {
//             endDragging = details.localPosition;
//           },
//           onHorizontalDragEnd: (details) {
//             double xDiff = endDragging!.dx - startDragging!.dx;
//             double yDiff = endDragging!.dy - startDragging!.dy;
//             directionDeciding(xDiff, yDiff);
//           },
//           onVerticalDragStart: (details) {
//             startDragging = details.localPosition;
//           },
//           onVerticalDragUpdate: (details) {
//             endDragging = details.localPosition;
//           },
//           onVerticalDragEnd: (details) {
//             double xDiff = endDragging!.dx - startDragging!.dx;
//             double yDiff = endDragging!.dy - startDragging!.dy;
//             directionDeciding(xDiff, yDiff);
//           },
//           child: Stack(
//             children: [
//               Board(
//                 numberOfRowCells: numberOfRowCells,
//                 gridCells: gridCells,
//               ),
//               BlocBuilder<FiguresCubit, FiguresState>(
//                 bloc: figuresCubit,
//                 buildWhen: (previous, current) =>
//                     current is FiguresChangeApplePosition,
//                 builder: (context, state) {
//                   // applePosition = Offset(2, 2);
//                   return Positioned(
//                     top: lengthSquareSide * applePosition.dy,
//                     left: lengthSquareSide * applePosition.dx,
//                     child: SizedBox(
//                       height: lengthSquareSide - 1,
//                       width: lengthSquareSide - 1,
//                       child: Image.asset("assets/images/apple.png"),
//                     ),
//                   );
//                 },
//               ),
//               // ...snake.map(
//               //   (snakePeace) {
//               //     return BlocConsumer<SnakeCubit, SnakeState>(
//               //       listenWhen: (previous, current) =>
//               //           current is SnakeStartRunning ||
//               //           current is SnakeStopRunning ||
//               //           current is SnakeBodyAssign,
//               //       listener: (context, state) async {
//               //         noOfUpdates++;
//               //         if (state is SnakeBodyAssign) {
//               //           snakePeace = newSnake[snakePeace.index];
//               //         }
//               //         if (noOfUpdates < snake.length) {
//               //           return;
//               //         }
//               //         if (state is SnakeStartRunning) {
//               //           noOfUpdates = 0;
//               //           snakeCubit.running();
//               //         } else if (state is SnakeStopRunning) {
//               //           snake = newSnake.toList();
//               //           // newSnake = [];
//               //           noOfUpdates = 0;
//               //           snakeCubit.stoped();
//               //         } else {
//               //           _animationController.reset();
//               //           noOfUpdates = 0;
//               //           snakeCubit.startRunning();
//               //         }
//               //       },
//               //       bloc: snakeCubit,
//               //       buildWhen: (previous, current) =>
//               //           current is SnakeRuning ||
//               //           current is SnakeStopped ||
//               //           current is SnakeInitial,
//               //       builder: (context, state) {
//               //         if (state is SnakeStopped) {
//               //           if (snakePeace.index != 0) {
//               //             newSnake[snakePeace.index] = snakePeace.changeDirection(
//               //               direction: snake[snakePeace.index - 1].direction,
//               //             );
//               //             // newSnake.add(
//               //             //   snakePeace.changeDirection(
//               //             //     direction: snake[snakePeace.index - 1].direction,
//               //             //   ),
//               //             // );
//               //           } else {
//               //             newSnake[snakePeace.index] = snakePeace.changeDirection(
//               //               direction: snake[snakePeace.index].direction,
//               //             );
//               //             // newSnake.add(
//               //             //   snakePeace.changeDirection(
//               //             //     direction: snake[snakePeace.index].direction,
//               //             //   ),
//               //             // );
//               //           }
//               //           snakeCubit.startAssigningNewSnakeBody();
//               //         } else if (state is SnakeRuning) {
//               //           _animationController.forward().then(
//               //             (value) {
//               //               snakeCubit.stopRunning();
//               //             },
//               //           );
//               //         } else {
//               //           _animationController.stop();
//               //         }
//               //         return snakePeace;
//               //       },
//               //     );
//               //   },
//               // ),
//               BlocListener<SnakeCubit, SnakeState>(
//                 bloc: snakeCubit,
//                 listenWhen: (previous, current) =>
//                     current is SnakeStartRunning ||
//                     current is SnakeCreateNewBody,
//                 listener: (context, state) async {
//                   if (state is SnakeStartRunning) {
//                     _animationController.forward().then(
//                       (value) {
//                         snakeCubit.createNewBody();
//                       },
//                     );
//                   } else if (state is SnakeCreateNewBody) {
//                     // newSnakePeaces[0] = snakePeaces[0]
//                     //     .changeDirection(direction: headDirection);

//                     // if (newSnakePeaces[0].beginPosition == applePastPosition) {
//                     //   // print(newSnake[0].beginPosition);
//                     //   // print(applePastPosition);
//                     //   snakePeaces.add(
//                     //     SnakePeace(
//                     //       animationController: _animationController,
//                     //       lengthSquareSide: lengthSquareSide,
//                     //       beginPosition: const Offset(-1, -1),
//                     //       endPosition: newSnakePeaces[initialSnakeLength - 1]
//                     //           .beginPosition,
//                     //       index: initialSnakeLength,
//                     //       direction:
//                     //           newSnakePeaces[initialSnakeLength - 1].direction,
//                     //     ),
//                     //   );
//                     //   newSnakePeaces.add(
//                     //     SnakePeace(
//                     //       animationController: _animationController,
//                     //       lengthSquareSide: lengthSquareSide,
//                     //       beginPosition: const Offset(-1, -1),
//                     //       endPosition: newSnakePeaces[initialSnakeLength - 1]
//                     //           .endPosition,
//                     //       index: initialSnakeLength,
//                     //       direction:
//                     //           newSnakePeaces[initialSnakeLength - 1].direction,
//                     //     ),
//                     //   );
//                     //   playgroundCubit.rebuildGrid();

//                     //   // await Future.delayed(Duration(seconds: 5));
//                     //   initialSnakeLength++;
//                     // }
//                     // for (int i = 1; i < initialSnakeLength; i++) {
//                     //   newSnakePeaces[i] = snakePeaces[i].changeDirection(
//                     //       direction: snakePeaces[i - 1].direction);
//                     // }

//                     // snakePeaces = newSnakePeaces.toList();
// ///////////////////////////////////////////////////////////////////////////////////////////////////////

//                     if (newSnakePeaces[0]
//                             .changeDirection(direction: headDirection)
//                             .endPosition ==
//                         applePastPosition) {
//                       newSnakePeaces.add(
//                         SnakePeace(
//                           animationController: _animationController,
//                           lengthSquareSide: lengthSquareSide,
//                           beginPosition: const Offset(-1, -1),
//                           endPosition: newSnakePeaces[initialSnakeLength - 1]
//                               .beginPosition,
//                           index: initialSnakeLength,
//                           direction:
//                               newSnakePeaces[initialSnakeLength - 1].direction,
//                         ),
//                       );
//                       initialSnakeLength++;
//                     }
//                     for (int i = initialSnakeLength - 1; i >= 1; i--) {
//                       newSnakePeaces[i] = newSnakePeaces[i].changeDirection(
//                           direction: newSnakePeaces[i - 1].direction);
//                     }
//                     newSnakePeaces[0] = newSnakePeaces[0]
//                         .changeDirection(direction: headDirection);

// ///////////////////////////////////////////////////////////////////////////////////////////////////////

//                     if (newSnakePeaces[0].endPosition == applePosition) {
//                       Future.delayed(
//                         Duration(milliseconds: movingTime ~/ 2),
//                         () {
//                           figuresCubit.changeApplePosition(true);
//                           playgroundCubit.rebuildGrid();
//                         },
//                       );
//                     }
//                     snakeCubit.AssigningNewSnakeBody();
//                     _animationController.reset();
//                     snakeCubit.startRunning();
//                   }
//                 },
//                 child: const SizedBox(),
//               ),

//               Snake(
//                 snakePeaces: newSnakePeaces,
//               ),

//               Positioned(
//                 left: 200,
//                 top: 200,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     snakeCubit.startRunning();
//                   },
//                   child: const Text("Go"),
//                 ),
//               ),
//               Positioned(
//                 left: 300,
//                 top: 200,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     snakeCubit.emit(SnakeInitial());
//                   },
//                   child: const Text("Stop"),
//                 ),
//               ),
//               Positioned(
//                 left: 50,
//                 top: 250,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     headDirection = "D";
//                   },
//                   child: const Text("down"),
//                 ),
//               ),
//               Positioned(
//                 left: 130,
//                 top: 250,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     headDirection = "U";
//                   },
//                   child: const Text("up"),
//                 ),
//               ),
//               Positioned(
//                 left: 190,
//                 top: 250,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     headDirection = "R";
//                   },
//                   child: const Text("right"),
//                 ),
//               ),
//               Positioned(
//                 left: 270,
//                 top: 250,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     headDirection = "L";
//                   },
//                   child: const Text("left"),
//                 ),
//               ),
//               //  Positioned(
//               //   left: 200,
//               //   top: 200,
//               //   child: ElevatedButton(
//               //     onPressed: () {
//               //       snakeCubit.startRunning();
//               //     },
//               //     child: const Text("Go"),
//               //   ),
//               // ),
//               // Positioned(
//               //   left: 300,
//               //   top: 200,
//               //   child: ElevatedButton(
//               //     onPressed: () {
//               //       snakeCubit.emit(SnakeInitial());
//               //     },
//               //     child: Text("Stop"),
//               //   ),
//               // ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
