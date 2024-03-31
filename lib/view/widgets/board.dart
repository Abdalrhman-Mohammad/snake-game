import 'package:flutter/material.dart';
import 'package:snake_game/models/cell.dart';

class Board extends StatelessWidget {
  final int numberOfRowCells;
  final int numberOfColumnCells;
  List<TableRow> grid = [];
  final double lengthSquareSide;
  Board({
    super.key,
    required this.numberOfRowCells,
    required this.numberOfColumnCells,
    required this.lengthSquareSide,
  });
  void initGrid() {
    for (int i = 0; i < numberOfColumnCells; i++) {
      List<Widget> row = [];
      for (int j = 0; j < numberOfRowCells; j++) {
        Color selectedColor;
        int rowNumber = i;
        int colNumber = j;
        if (rowNumber % 2 == 0) {
          if (colNumber % 2 == 0) {
            selectedColor = Colors.green;
          } else {
            selectedColor = Colors.green.shade300;
          }
        } else {
          if (colNumber % 2 == 0) {
            selectedColor = Colors.green.shade300;
          } else {
            selectedColor = Colors.green;
          }
        }
        row.add(
          Cell(
            color: selectedColor,
            sideLong: lengthSquareSide,
          ),
        );
      }

      grid.add(TableRow(
        children: row,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    initGrid();
    return SizedBox(
      width: numberOfRowCells * lengthSquareSide,
      height: numberOfColumnCells * lengthSquareSide,
      child: Table(
        defaultColumnWidth: FlexColumnWidth(lengthSquareSide),
        children: grid,
      ),
    );
  }
}
