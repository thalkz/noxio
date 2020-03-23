import 'dart:math';

import 'package:noxio/models.dart';

class BoardBuilder {
  static Board empty() {
    List<Cell> cells = [];
    for (var i = 0; i < 8; i++) {
      for (var j = 0; j < 8; j++) {
        cells.add(Cell(i, j));
      }
    }
    return Board(cells);
  }

  static int randomBoardIndex() {
    return Random().nextInt(boards.length);
  }

  static Board random() {
    int random = Random().nextInt(boards.length);
    List<List<int>> board = boards[random];

    List<Cell> cells = [];
    for (var i = 0; i < 8; i++) {
      for (var j = 0; j < 8; j++) {
        CellState state = _toCellState(board[i][j]);
        cells.add(Cell(i, j, state: state));
      }
    }
    return Board(cells);
  }

  static Board build(int index) {
    List<List<int>> board = boards[index];

    List<Cell> cells = [];
    for (var i = 0; i < 8; i++) {
      for (var j = 0; j < 8; j++) {
        CellState state = _toCellState(board[i][j]);
        cells.add(Cell(i, j, state: state));
      }
    }
    return Board(cells);
  }

  static CellState _toCellState(int value) {
    if (value == 1) return CellState.stone;
    if (value == 2) return CellState.red;
    if (value == 3) return CellState.blue;
    return CellState.empty;
  }

  static final boards = [
    [
      [2, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 1, 0, 0, 1, 0],
      [0, 1, 0, 1, 0, 0, 1, 0],
      [0, 1, 0, 0, 1, 0, 1, 0],
      [0, 1, 0, 1, 0, 0, 1, 0],
      [0, 1, 0, 0, 1, 0, 1, 0],
      [0, 1, 0, 0, 1, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 3],
    ],
    [
      [2, 0, 0, 0, 0, 0, 0, 0],
      [0, 1, 0, 0, 0, 1, 0, 0],
      [0, 0, 1, 0, 1, 0, 0, 0],
      [0, 0, 0, 0, 0, 1, 0, 0],
      [0, 0, 1, 0, 0, 0, 0, 0],
      [0, 0, 0, 1, 0, 1, 0, 0],
      [0, 0, 1, 0, 0, 0, 1, 0],
      [0, 0, 0, 0, 0, 0, 0, 3],
    ],
    [
      [2, 0, 0, 1, 0, 0, 0, 0],
      [0, 1, 0, 0, 1, 1, 0, 0],
      [0, 1, 0, 0, 0, 0, 1, 0],
      [0, 1, 0, 1, 0, 0, 1, 0],
      [0, 1, 0, 0, 1, 0, 1, 0],
      [0, 1, 0, 0, 0, 0, 1, 0],
      [0, 0, 1, 1, 0, 0, 1, 0],
      [0, 0, 0, 0, 1, 0, 0, 3],
    ],
    [
      [0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 1, 1, 0, 0, 0],
      [0, 0, 1, 0, 0, 1, 0, 0],
      [0, 0, 1, 0, 0, 1, 0, 0],
      [0, 0, 0, 1, 1, 0, 0, 0],
      [0, 0, 1, 0, 0, 1, 0, 0],
      [0, 0, 0, 1, 1, 0, 0, 0],
      [2, 0, 0, 0, 0, 0, 0, 3],
    ],
    [
      [0, 0, 0, 0, 0, 0, 0, 2],
      [0, 1, 0, 0, 0, 1, 0, 0],
      [0, 0, 1, 0, 1, 0, 1, 0],
      [0, 0, 0, 0, 0, 1, 0, 0],
      [0, 0, 1, 0, 0, 0, 0, 0],
      [0, 1, 0, 1, 0, 1, 0, 0],
      [0, 0, 1, 0, 0, 0, 1, 0],
      [3, 0, 0, 0, 0, 0, 0, 0],
    ],
    [
      [1, 0, 0, 1, 1, 0, 2, 1],
      [0, 1, 0, 0, 0, 0, 1, 0],
      [0, 1, 0, 0, 0, 0, 1, 0],
      [0, 0, 0, 1, 0, 0, 0, 0],
      [0, 0, 0, 0, 1, 0, 0, 0],
      [0, 1, 0, 0, 0, 0, 1, 0],
      [0, 1, 0, 0, 0, 0, 1, 0],
      [1, 3, 0, 1, 1, 0, 0, 1],
    ]
  ];
}
