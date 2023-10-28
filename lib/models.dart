import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:noxio/rules.dart';

class Board {
  final List<Cell> cells;

  Board(this.cells);

  Board copy() {
    List<Cell> copy = [];
    for (Cell cell in cells) {
      copy.add(cell.copy());
    }
    return Board(copy);
  }

  Cell getCell(int x, int y) {
    if (x < 0 || x >= 8 || y < 0 || y >= 8) return null;
    return cells[y + 8 * x];
  }
}

class Cell {
  int x;
  int y;
  CellState state;

  Cell(this.x, this.y, {this.state = CellState.empty});

  Cell copy() {
    return Cell(x, y, state: CellState.values[state.index]);
  }
}

class Move {
  final Cell from;
  final Cell to;
  final MoveType type;

  Move.duplicate(this.from, this.to) : type = MoveType.duplicate;
  Move.jump(this.from, this.to) : type = MoveType.jump;

  @override
  String toString() {
    return type == MoveType.jump ? 'JMP(${to.x},${to.y})' : 'DUP(${to.x},${to.y})';
  }
}

enum MoveType {
  duplicate,
  jump,
}

enum Player {
  blue,
  red,
  none,
}

enum CellState {
  blue,
  red,
  stone,
  empty,
}

class Position {
  final Board initialBoard;
  List<Move> moves = [];
  double evaluation;

  Position(this.initialBoard);

  Position.from(Position position, Move move) : initialBoard = position.initialBoard {
    moves.addAll(position.moves);
    moves.add(move);
  }

  Board toBoard() {
    Board copy = initialBoard.copy();
    for (Move move in moves) {
      Rules.playMove(copy, move);
    }
    return copy;
  }

  @override
  String toString() {
    if (moves.isEmpty) return '[]';
    StringBuffer buffer = StringBuffer();
    buffer.write('[');
    for (int i = 0; i < moves.length - 1; i++) {
      buffer.write('--------');
    }
    buffer.write('${moves[moves.length - 1]}');
    buffer.write(']');
    return buffer.toString();
  }
}

class GameParams {
  final int seconds;
  final int boardIndex;
  final Mode mode;
  final int aiLevel;
  final Player onlineMe;
  final String onlineGameId;
  final Player startingPlayer;

  GameParams({
    @required this.seconds,
    @required this.mode,
    this.boardIndex,
    this.aiLevel,
    this.onlineMe,
    this.onlineGameId,
    this.startingPlayer,
  });
}

enum Mode {
  online,
  offline,
  ai,
}

class OnlineMove {
  DateTime date;
  Move move;

  OnlineMove.fromSnap(DocumentSnapshot snap) {
    date = snap.get('date').toDate();
    Map fromMap = snap.get('from');
    Cell from = Cell(fromMap['x'], fromMap['y'], state: CellState.values[fromMap['state']]);
    Map toMap = snap.get('to');
    Cell to = Cell(toMap['x'], toMap['y'], state: CellState.values[toMap['state']]);
    if (snap.get('type') == MoveType.duplicate.index) {
      move = Move.duplicate(from, to);
    } else if (snap.get('type') == MoveType.jump.index) {
      move = Move.jump(from, to);
    }
  }
}

class Game {
  String id;
  Player me;
  bool pending;
  int boardIndex;
  Player startingPlayer;

  Game.fromSnap(DocumentSnapshot snap, {@required bool isCreator}) {
    id = snap.id;
    Player creator = Player.values[snap.get('creator')];
    me = isCreator ? creator : Rules.other(creator);
    pending = snap.get('pending');
    boardIndex = snap.get('board_index');
    startingPlayer = Player.values[snap.get('starting_player')];
  }
}
