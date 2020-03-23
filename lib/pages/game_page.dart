import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:noxio/models/app_model.dart';
import 'package:noxio/models.dart';
import 'package:noxio/models/game_model.dart';
import 'package:noxio/widgets/board_widget.dart';
import 'package:noxio/widgets/player_widget.dart';
import 'package:noxio/widgets/timer_bar_widget.dart';
import 'package:noxio/widgets/timer_widget.dart';
import 'package:provider/provider.dart';

class GamePage extends StatefulWidget {
  final GameParams params;

  const GamePage({@required this.params});

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.params.mode == Mode.ai
            ? Text('Game vs Computer')
            : widget.params.mode == Mode.offline ? Text("Offline Game") : Text('Online Game'),
      ),
      body: Stack(
        children: <Widget>[
          if (Provider.of<AppModel>(context).isSkyTheme)
            FlareActor(
              'res/stars.flr',
              animation: 'idle',
              fit: BoxFit.fitWidth,
            ),
          SafeArea(
            child: ChangeNotifierProvider<GameModel>(
              create: (context) => GameModel(widget.params),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Center(child: TimerBarWidget(player: Player.red)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(child: PlayerWidget(player: Player.red)),
                        TimerWidget(player: Player.red),
                      ],
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: BoardWidget(),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(child: PlayerWidget(player: Player.blue)),
                        TimerWidget(player: Player.blue),
                      ],
                    ),
                  ),
                  Center(child: TimerBarWidget(player: Player.blue)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
