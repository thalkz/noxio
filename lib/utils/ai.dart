import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:noxio/models.dart';
import 'package:noxio/rules.dart';

// Blue is Human and is maximizing
// Red is Computer and is minimizing

const verbose = false;

class AiLevel {
  final int maxDepth;
  final double randomWeight;
  final double centerWeight;

  const AiLevel({@required this.maxDepth, @required this.randomWeight, @required this.centerWeight});
}

const List<AiLevel> difficulty = [
  const AiLevel(
    maxDepth: 1,
    randomWeight: 3.0,
    centerWeight: 0.3,
  ),
  const AiLevel(
    maxDepth: 2,
    randomWeight: 1.5,
    centerWeight: 0.5,
  ),
  const AiLevel(
    maxDepth: 3,
    randomWeight: 0.5,
    centerWeight: 0.5,
  ),
  const AiLevel(
    maxDepth: 4,
    randomWeight: 0.2,
    centerWeight: 0.5,
  ),
];

class AI {
  static int level;
  static int maxDepth;
  static double randomWeight;
  static double centerWeight;

  static Future<Move> computeMove(Board board, int level) async {
    return compute(AI._syncComputeMove, {'board': board, 'level': level});
  }

  static Future<Move> _syncComputeMove(Map<String, dynamic> params) async {
    AI.level = params['level'];
    AI.maxDepth = difficulty[level].maxDepth;
    AI.randomWeight = difficulty[level].randomWeight;
    AI.centerWeight = difficulty[level].centerWeight;

    if (verbose) print('AI: Evaluating... (level=$level)');
    await Future.delayed(Duration(milliseconds: 200));
    return Future.microtask(() {
      Position best = _minmax(
        Position(params['board']),
        maxDepth,
        -double.infinity,
        double.infinity,
        false,
      );
      if (verbose) print('AI: Best is $best');
      return best.moves[0];
    });
  }

  static _minmax(Position position, int depth, double alpha, double beta, bool maximizingPlayer) {
    if (depth == 0 || Rules.isGameOver(position, maximizingPlayer)) {
      return evaluate(position);
    }

    if (maximizingPlayer) {
      double maxEval = -double.infinity;
      List<Position> availableMoves = _availableMoves(position, maximizingPlayer);
      Position best;
      for (Position child in availableMoves) {
        double eval = _minmax(child, depth - 1, alpha, beta, false);
        if (eval > maxEval) {
          maxEval = eval;
          best = child;
        }
        alpha = max(alpha, eval);
        if (beta <= alpha) {
          if (verbose) print('AI: Pruning branche');
          break;
        }
      }
      if (verbose) print('AI: $position $maxEval');
      if (depth == maxDepth) {
        if (verbose) print('AI: Max is $maxEval for $best');
        return best;
      }
      return maxEval;
    } else {
      double minEval = double.infinity;
      List<Position> availableMoves = _availableMoves(position, maximizingPlayer);
      Position best;
      for (Position child in availableMoves) {
        double eval = _minmax(child, depth - 1, alpha, beta, true);
        if (eval < minEval) {
          minEval = eval;
          best = child;
        }
        beta = min(beta, eval);
        if (beta <= alpha) {
          if (verbose) print('AI: Pruning branche');
          break;
        }
      }
      if (verbose) print('AI: $position $minEval');
      if (depth == maxDepth) {
        if (verbose) print('AI: Min is $minEval for $best');
        return best;
      }
      return minEval;
    }
  }

  static List<Position> _availableMoves(Position position, bool maximizingPlayer) {
    CellState state = maximizingPlayer ? CellState.blue : CellState.red;
    List<Position> result = [];
    Board board = position.toBoard();
    for (Cell cell in board.cells) {
      if (cell.state == CellState.empty) {
        // Duplicates
        Cell from = Rules.hasCellThatCanDuplacateTo(board, cell, state);
        if (from != null) {
          result.add(Position.from(position, Move.duplicate(from, cell)));
        }

        // Jumps
        for (Cell from in Rules.getAllJumpableCells(board, cell)) {
          if (from.state == state) {
            result.add(Position.from(position, Move.jump(from, cell)));
          }
        }
      }
    }
    return result;
  }

  static double evaluate(Position position) {
    Board board = position.toBoard();
    final double result = _weightedCount(board, CellState.blue) -
        _weightedCount(board, CellState.red) +
        Random().nextDouble() * randomWeight;
    if (verbose) print('AI: $position ${result.toStringAsPrecision(1)}');
    return result;
  }

  static double _weightedCount(Board board, CellState state) {
    if (board.cells.where((cell) => cell.state == state).toList().isEmpty) return 0.0;
    return board.cells
        .where((cell) => cell.state == state)
        .map(((cell) => 1.0 + centerWeight * _cellWeight(cell)))
        .reduce((a, b) => a + b);
  }

  static double _cellWeight(Cell cell) {
    double xWeight = (1.0 - ((cell.x / 4.0) - 1.0).abs());
    double yWeight = (1.0 - ((cell.y / 4.0) - 1.0).abs());
    return xWeight + yWeight;
  }
}
