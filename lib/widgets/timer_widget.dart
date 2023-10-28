import 'package:flutter/material.dart';
import 'package:noxio/models.dart';
import 'package:noxio/models/game_model.dart';
import 'package:noxio/rules.dart';
import 'package:noxio/utils/colors.dart';
import 'package:provider/provider.dart';

class TimerWidget extends StatefulWidget {
  const TimerWidget({@required this.player});

  final Player player;

  @override
  _TimerBarWitState createState() => _TimerBarWitState();
}

class _TimerBarWitState extends State<TimerWidget> with TickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;
  DateTime lastTurnStart;

  @override
  void initState() {
    super.initState();
    Duration turnDuration = Provider.of<GameModel>(context, listen: false).turnDuration;
    _controller = AnimationController(vsync: this, duration: turnDuration);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.linear);
  }

  String timeLeft(Duration turnDuration) {
    double remaining = _controller.value * turnDuration.inSeconds;
    if (turnDuration.inSeconds == 0) {
      return '-';
    } else if (remaining <= 9.9) {
      return remaining.toStringAsFixed(1);
    } else {
      return remaining.toStringAsFixed(0);
    }
  }

  bool _computerPlaying(GameModel model) =>
      model.vsAi && model.currentPlayer == Player.red && widget.player == Player.red && model.winner == null;

  @override
  Widget build(BuildContext context) {
    return Consumer<GameModel>(
      builder: (context, model, child) {
        _updateTimer(model);
        return AnimatedContainer(
          duration: Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 12),
          width: 90,
          decoration: BoxDecoration(
            color: model.currentPlayer == widget.player && model.winner == null
                ? NoxioColors.player(context, widget.player).withOpacity(0.5)
                : NoxioColors.white(context).withOpacity(0.5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: _computerPlaying(model)
              ? Center(
                  child: Container(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(NoxioColors.black(context)),
                    ),
                  ),
                )
              : AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Center(
                      child: Text(
                        model.currentPlayer == widget.player && model.winner == null
                            ? timeLeft(model.turnDuration)
                            : '-',
                        style: Theme.of(context).textTheme.titleMedium,
                        textAlign: TextAlign.right,
                      ),
                    );
                  },
                ),
        );
      },
    );
  }

  void _updateTimer(GameModel model) {
    if (model.currentPlayer != widget.player || model.winner != null) {
      _controller.stop();
    } else if (lastTurnStart != model.turnStart) {
      _controller.reverse(from: Rules.turnPercent(model.turnStart, model.turnDuration));
      lastTurnStart = model.turnStart;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
