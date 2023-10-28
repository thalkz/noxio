import 'package:flutter/material.dart';
import 'package:noxio/models.dart';
import 'package:noxio/models/game_model.dart';
import 'package:noxio/rules.dart';
import 'package:noxio/utils/colors.dart';
import 'package:provider/provider.dart';

class PlayerWidget extends StatefulWidget {
  const PlayerWidget({this.player});

  final Player player;

  @override
  _PlayerWidgetState createState() => _PlayerWidgetState();
}

class _PlayerWidgetState extends State<PlayerWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<GameModel>(
      builder: (context, model, child) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Chip(
                label: Text(
                  _playerName(model),
                  style: TextStyle(
                    fontWeight: widget.player == model.winner ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                avatar: CircleAvatar(
                  child: Text(_getAvatar(model)),
                ),
                backgroundColor: model.currentPlayer == widget.player && model.winner == null
                    ? NoxioColors.player(context, widget.player).withOpacity(0.5)
                    : NoxioColors.white(context),
              ),
              Container(
                height: 25,
                child: Text(
                  _cellCount(model),
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _playerName(GameModel model) {
    if (model.online) {
      if (model.onlineMe == widget.player) {
        return 'Me';
      } else {
        return 'Opponent';
      }
    } else {
      if (widget.player == Player.blue) {
        return 'Player 1';
      } else if (model.vsAi) {
        return 'AI lvl ${model.aiLevel}';
      } else {
        return 'Player 2';
      }
    }
  }

  String _cellCount(GameModel model) {
    String suffix = '';
    if (model.winner != null) {
      if (model.winner == widget.player) {
        suffix = ' ● Victory !';
      } else if (model.winner == Player.none) {
        suffix = ' ● Equality';
      } else {
        suffix = ' ● Defeat';
      }
    } else if (model.currentPlayer == widget.player) {
      suffix = ' ● Playing';
    }

    if (widget.player == Player.blue) {
      int cellCount = Rules.count(model.board, CellState.blue);
      return '$cellCount pts' + suffix;
    } else {
      int cellCount = Rules.count(model.board, CellState.red);
      return '$cellCount pts' + suffix;
    }
  }

  String _getAvatar(GameModel model) {
    if (model.winner != null) {
      if (model.winner == widget.player) {
        return '👑';
      } else if (model.winner == Player.none) {
        return '⚖️';
      } else {
        return '⚑';
      }
    }

    if (model.vsAi && widget.player == Player.red) {
      return '🤖';
    }

    int score = Rules.count(model.board, CellState.blue) - Rules.count(model.board, CellState.red);
    if (widget.player == Player.red) score = -score;
    if (score > 10) {
      return '😁';
    } else if (score > 5) {
      return '😀';
    } else if (score >= -2) {
      return '🙂';
    } else if (score >= -7) {
      return '😐';
    } else if (score >= -12) {
      return '😦';
    } else {
      return '😱';
    }
  }
}
