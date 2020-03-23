import 'dart:async';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:noxio/models/app_model.dart';
import 'package:noxio/models.dart';
import 'package:noxio/utils/board_builder.dart';
import 'package:noxio/utils/colors.dart';
import 'package:noxio/utils/database.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
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
            minimum: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  'noxio',
                  style: GoogleFonts.righteous(
                    textStyle: Theme.of(context).textTheme.display3,
                    color: NoxioColors.black(context),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 32),
                RaisedButton(
                  onPressed: () => showComputerGameDialog(),
                  child: Text("Play vs Computer"),
                  padding: const EdgeInsets.all(16),
                ),
                SizedBox(height: 8),
                RaisedButton(
                  onPressed: () => showOfflineGameDialog(),
                  child: Text("Play Offline"),
                  padding: const EdgeInsets.all(16),
                ),
                SizedBox(height: 8),
                RaisedButton(
                  onPressed: () => showOnlineGameDialog(),
                  child: Text("Play Online"),
                  padding: const EdgeInsets.all(16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void showComputerGameDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Difficulty'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              RaisedButton(
                onPressed: () => Navigator.popAndPushNamed(
                  context,
                  '/game',
                  arguments: GameParams(seconds: 0, mode: Mode.ai, aiLevel: 0),
                ),
                child: Text("Easy"),
                padding: const EdgeInsets.all(16),
              ),
              SizedBox(height: 8),
              RaisedButton(
                onPressed: () => Navigator.popAndPushNamed(
                  context,
                  '/game',
                  arguments: GameParams(seconds: 0, mode: Mode.ai, aiLevel: 1),
                ),
                child: Text("Normal"),
                padding: const EdgeInsets.all(16),
              ),
              SizedBox(height: 8),
              RaisedButton(
                onPressed: () => Navigator.popAndPushNamed(
                  context,
                  '/game',
                  arguments: GameParams(seconds: 0, mode: Mode.ai, aiLevel: 2),
                ),
                child: Text("Hard"),
                padding: const EdgeInsets.all(16),
              ),
              SizedBox(height: 8),
              RaisedButton(
                onPressed: () => Navigator.popAndPushNamed(
                  context,
                  '/game',
                  arguments: GameParams(seconds: 0, mode: Mode.ai, aiLevel: 3),
                ),
                child: Text("Expert"),
                padding: const EdgeInsets.all(16),
              ),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            )
          ],
        );
      },
    );
  }

  void showOfflineGameDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Time per turn'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              RaisedButton(
                onPressed: () => Navigator.popAndPushNamed(
                  context,
                  '/game',
                  arguments: GameParams(seconds: 30, mode: Mode.offline),
                ),
                child: Text("30s per turn"),
                padding: const EdgeInsets.all(16),
              ),
              SizedBox(height: 8),
              RaisedButton(
                onPressed: () => Navigator.popAndPushNamed(
                  context,
                  '/game',
                  arguments: GameParams(seconds: 60, mode: Mode.offline),
                ),
                child: Text("60s per turn"),
                padding: const EdgeInsets.all(16),
              ),
              SizedBox(height: 8),
              RaisedButton(
                onPressed: () => Navigator.popAndPushNamed(
                  context,
                  '/game',
                  arguments: GameParams(seconds: 0, mode: Mode.offline),
                ),
                child: Text("Unlimited"),
                padding: const EdgeInsets.all(16),
              ),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            )
          ],
        );
      },
    );
  }

  void showOnlineGameDialog() {
    showDialog(
      context: context,
      builder: (context) => OnlineGameDialog(),
    );
  }
}

class OnlineGameDialog extends StatefulWidget {
  @override
  _OnlineGameDialogState createState() => _OnlineGameDialogState();
}

class _OnlineGameDialogState extends State<OnlineGameDialog> {
  StreamSubscription _sub;
  String _pendingGameId;

  @override
  void initState() {
    super.initState();
    joinOnlineGame();
  }

  void joinOnlineGame() async {
    Game game = await Database.getOpenGame();
    if (game != null) {
      await Database.joinGame(game);
      _startGame(game);
    } else {
      String gameId = await Database.createGame();
      _pendingGameId = gameId;
      _sub = Database.waitForOpponent(gameId).listen((Game game) {
        if (!game.pending) {
          _pendingGameId = null;
          _startGame(game);
        }
      });
    }
  }

  _startGame(Game game) {
    print('I play as ${game.me}');

    GameParams params = GameParams(
      seconds: 60,
      mode: Mode.online,
      onlineGameId: game.id,
      onlineMe: game.me,
      boardIndex: game.boardIndex,
      startingPlayer: game.startingPlayer,
    );
    Navigator.popAndPushNamed(context, '/game', arguments: params);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Searching for an opponent...'),
      content: Container(
        width: 60,
        height: 60,
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(NoxioColors.black(context)),
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        )
      ],
    );
  }

  @override
  void dispose() {
    if (_pendingGameId != null) {
      Database.abortGame(_pendingGameId);
    }
    _sub?.cancel();
    super.dispose();
  }
}
