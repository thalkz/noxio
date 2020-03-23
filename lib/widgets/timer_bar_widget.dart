import 'package:flutter/material.dart';
import 'package:noxio/models.dart';
import 'package:noxio/models/game_model.dart';
import 'package:noxio/rules.dart';
import 'package:noxio/utils/colors.dart';
import 'package:provider/provider.dart';

class TimerBarWidget extends StatefulWidget {
  const TimerBarWidget({@required this.player});

  final Player player;

  @override
  _TimerBarWidgetState createState() => _TimerBarWidgetState();
}

class _TimerBarWidgetState extends State<TimerBarWidget> with TickerProviderStateMixin {
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: double.infinity,
          height: 8,
          color: NoxioColors.player(context, widget.player).withOpacity(0.3),
        ),
        Consumer<GameModel>(
          builder: (context, model, child) {
            _updateTimer(model);
            return Center(
              child: LayoutBuilder(
                builder: (context, BoxConstraints box) {
                  return AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Container(
                        width: !model.hasTimer && model.currentPlayer == widget.player
                            ? box.maxWidth
                            : box.maxWidth * _controller.value,
                        height: 8,
                        color: NoxioColors.player(context, widget.player),
                      );
                    },
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  void _updateTimer(GameModel model) {
    if (model.currentPlayer != widget.player || model.winner != null) {
      _controller.reset();
    } else if (lastTurnStart != model.turnStart) {
      _controller.reverse(from: Rules.turnPercent(model.turnStart, model.turnDuration));
      lastTurnStart = model.turnStart;
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
