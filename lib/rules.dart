import 'dart:math';

import 'package:noxio/models.dart';

class Rules {
  static bool isSame(Cell from, Cell to) {
    if (from == null || to == null) return false;
    return from.x == to.x && from.y == to.y;
  }

  static bool adjacentTo(Cell from, Cell to) {
    if (from == null || to == null) return false;
    return ((from.x == to.x + 1) || (from.x == to.x) || (from.x == to.x - 1)) &&
        ((from.y == to.y + 1) || (from.y == to.y) || (from.y == to.y - 1));
  }

  static bool canDuplicateTo(Cell from, Cell to) {
    if (from == null || to == null) return false;
    if (to.state != CellState.empty) return false;
    return ((from.x == to.x + 1) || (from.x == to.x) || (from.x == to.x - 1)) &&
        ((from.y == to.y + 1) || (from.y == to.y) || (from.y == to.y - 1));
  }

  static bool canJumpTo(Cell from, Cell to) {
    if (from == null || to == null) return false;
    if (to.state != CellState.empty) return false;
    return (from.x == to.x && (from.y == to.y + 2 || from.y == to.y - 2)) ||
        (from.y == to.y && (from.x == to.x + 2 || from.x == to.x - 2));
  }

  static void convertAdjacent(Cell cell, Board board) {
    if (cell == null) return;
    for (Cell toConvert in board.cells) {
      if (Rules.adjacentTo(cell, toConvert) &&
          (toConvert.state == CellState.red || toConvert.state == CellState.blue)) {
        toConvert.state = cell.state;
      }
    }
  }

  static bool isPlayer(Player player, Cell cell) {
    return player == Player.blue && cell.state == CellState.blue || player == Player.red && cell.state == CellState.red;
  }

  static bool isOtherPlayer(Player player, Cell cell) {
    return Rules.isPlayer(Rules.other(player), cell);
  }

  static bool isBlocked(Player player, Board board) {
    for (Cell cell in board.cells) {
      if (isPlayer(player, cell) && _canBePlayed(cell, board)) {
        return false;
      }
    }
    return true;
  }

  static bool _canBePlayed(Cell cell, Board board) {
    for (Cell other in Rules.getAllAdjacentCells(board, cell)) {
      if (other.state == CellState.empty) {
        return true;
      }
    }
    for (Cell other in Rules.getAllJumpableCells(board, cell)) {
      if (other.state == CellState.empty) {
        return true;
      }
    }
    return false;
  }

  static int count(Board board, CellState state) {
    return board.cells.where((cell) => cell.state == state).toList().length;
  }

  static void fillBoard(Board board, Player player) {
    for (Cell cell in board.cells) {
      if (cell.state == CellState.empty) {
        cell.state = player == Player.red ? CellState.red : CellState.blue;
      }
    }
  }

  static Player hasMostPoints(Board board) {
    int blueScore = count(board, CellState.blue);
    int redScore = count(board, CellState.red);
    if (blueScore > redScore) {
      return Player.blue;
    } else if (redScore > blueScore) {
      return Player.red;
    } else {
      return Player.none;
    }
  }

  static double turnPercent(DateTime start, Duration duration) {
    Duration sinceStart = DateTime.now().difference(start);
    final double percent = (duration.inMilliseconds - sinceStart.inMilliseconds) / duration.inMilliseconds;
    percent.clamp(0.0, 1.0);
    return percent;
  }

  static Player randomPlayer() {
    return Random().nextInt(2) == 0 ? Player.blue : Player.red;
  }

  static Cell hasCellThatCanDuplacateTo(Board board, Cell cell, CellState withState) {
    for (Cell cell in Rules.getAllAdjacentCells(board, cell)) {
      if (cell.state == withState) {
        return cell;
      }
    }
    return null;
  }

  static bool hasCellThatCanJumpTo(Board board, Cell cell, CellState withState) {
    for (Cell cell in Rules.getAllJumpableCells(board, cell)) {
      if (cell.state == withState) {
        return true;
      }
    }
    return false;
  }

  static List<Cell> getAllJumpableCells(Board board, Cell cell) {
    List<Cell> result = [];
    result.add(board.getCell(cell.x + 2, cell.y));
    result.add(board.getCell(cell.x - 2, cell.y));
    result.add(board.getCell(cell.x, cell.y + 2));
    result.add(board.getCell(cell.x, cell.y - 2));
    return result.where((cell) => cell != null).toList();
  }

  static List<Cell> getAllAdjacentCells(Board board, Cell cell) {
    List<Cell> result = [];
    result.add(board.getCell(cell.x + 1, cell.y));
    result.add(board.getCell(cell.x + 1, cell.y + 1));
    result.add(board.getCell(cell.x + 1, cell.y - 1));
    result.add(board.getCell(cell.x, cell.y + 1));
    result.add(board.getCell(cell.x, cell.y - 1));
    result.add(board.getCell(cell.x - 1, cell.y));
    result.add(board.getCell(cell.x - 1, cell.y + 1));
    result.add(board.getCell(cell.x - 1, cell.y - 1));
    return result.where((cell) => cell != null).toList();
  }

  static bool isValidMove(Board board, Move move) {
    if (!isOnBoard(move.from) || !isOnBoard(move.to)) return false;
    if (Rules.isSame(move.from, move.to)) return false;
    if (move.from.state == CellState.empty || move.from.state == CellState.stone) return false;
    if (move.type == MoveType.duplicate && !Rules.canDuplicateTo(move.from, move.to)) return false;
    if (move.type == MoveType.jump && !Rules.canJumpTo(move.from, move.to)) return false;
    return true;
  }

  static bool isOnBoard(Cell cell) {
    return cell.x >= 0 && cell.x < 8 && cell.y >= 0 && cell.y < 8;
  }

  static void playMove(Board board, Move move) {
    if (!Rules.isValidMove(board, move)) {
      throw Exception('Invalid move : $move');
    }
    switch (move.type) {
      case MoveType.duplicate:
        Cell to = board.getCell(move.to.x, move.to.y);
        to.state = CellState.values[move.from.state.index];
        Rules.convertAdjacent(to, board);
        break;
      case MoveType.jump:
        Cell to = board.getCell(move.to.x, move.to.y);
        to.state = CellState.values[move.from.state.index];

        Cell from = board.getCell(move.from.x, move.from.y);
        from.state = CellState.empty;
        Rules.convertAdjacent(to, board);
        break;
    }
  }

  static Player other(Player player) {
    return player == Player.blue ? Player.red : Player.blue;
  }

  static bool isGameOver(Position position, bool bluePlayer) {
    Board board = position.toBoard();
    return Rules.isBlocked(!bluePlayer ? Player.red : Player.blue, board);
  }
}
