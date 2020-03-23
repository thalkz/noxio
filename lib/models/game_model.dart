import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:noxio/models.dart';
import 'package:noxio/rules.dart';
import 'package:noxio/utils/ai.dart';
import 'package:noxio/utils/board_builder.dart';
import 'package:noxio/utils/database.dart';

class GameModel with ChangeNotifier {
  Board _board;
  DateTime _turnStart;
  Player _currentPlayer;
  Timer _timer;
  Duration _turnDuration;
  Player _winner;
  Mode _gameType;
  int _aiLevel;
  Player _onlineMe;
  Player _onlineOther;
  String _onlineGameId;
  StreamSubscription _sub;

  GameModel(GameParams params) {
    _board = params.boardIndex != null ? BoardBuilder.build(params.boardIndex) : BoardBuilder.random();
    _turnStart = DateTime.now();
    _turnDuration = Duration(seconds: params.seconds);
    _currentPlayer = params.startingPlayer ?? Rules.randomPlayer();
    _gameType = params.mode;
    _aiLevel = params.aiLevel;
    _onlineMe = params.onlineMe;
    _onlineOther = Rules.other(_onlineMe);
    _onlineGameId = params.onlineGameId;

    if (vsAi && _currentPlayer == Player.red) {
      AI.computeMove(board, params.aiLevel).then((Move move) => nextTurn(move));
    } else if (online) {
      _sub = Database.listenMoves(_onlineGameId, _onlineOther).listen((OnlineMove onlineMove) {
        if (onlineMove == null) return;
        _turnStart = onlineMove.date;
        nextTurn(onlineMove.move);
      });
    }

    if (hasTimer) {
      _timer = Timer(_turnDuration, _turnTimeout);
    }
  }

  Board get board => _board;
  Player get currentPlayer => _currentPlayer;
  DateTime get turnStart => _turnStart;
  Duration get turnDuration => _turnDuration;
  Player get winner => _winner;
  bool get hasTimer => _turnDuration.inSeconds != 0;
  bool get vsAi => _gameType == Mode.ai;
  bool get offline => _gameType == Mode.offline;
  bool get online => _gameType == Mode.online;
  Player get onlineMe => _onlineMe;
  int get aiLevel => _aiLevel + 1;

  Future<void> nextTurn(Move move) async {
    // Play Move
    Rules.playMove(board, move);

    // Switch Player
    _currentPlayer = Rules.other(currentPlayer);

    // Send online
    if (online && _currentPlayer == _onlineOther) {
      await Database.sendMove(_onlineGameId, _onlineMe, move, _turnStart);
    }

    // Check victory
    if (Rules.isBlocked(_currentPlayer, board)) {
      Rules.fillBoard(board, Rules.other(_currentPlayer));
      _timer?.cancel();
      _winner = Rules.hasMostPoints(board);
      notifyListeners();
      return;
    }

    // Reset timer
    if (hasTimer) {
      _turnStart = DateTime.now();
      _timer?.cancel();
      _timer = new Timer(_turnDuration, _turnTimeout);
      // TODO only set timer for REMAINING duration since turnStart
    }

    if (vsAi && _currentPlayer == Player.red) {
      AI.computeMove(board, _aiLevel).then((Move move) => nextTurn(move));
    }

    notifyListeners();
  }

  void _turnTimeout() {
    _timer?.cancel();
    _winner = _currentPlayer == Player.red ? Player.blue : Player.red;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _sub?.cancel();
    super.dispose();
  }
}
