import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:noxio/models.dart';
import 'package:noxio/rules.dart';
import 'package:noxio/utils/board_builder.dart';

class Database {
  static Stream<OnlineMove> listenMoves(String gameId, Player onlineOther) {
    return FirebaseFirestore.instance
        .doc('games/$gameId/${onlineOther.index}/move')
        .snapshots()
        .map((DocumentSnapshot snap) => snap.exists ? OnlineMove.fromSnap(snap) : null);
  }

  static sendMove(String gameId, Player onlineMe, Move move, DateTime turnStart) {
    return FirebaseFirestore.instance.doc('games/$gameId/${onlineMe.index}/move').set({
      'date': turnStart,
      'type': move.type.index,
      'from': {
        'x': move.from.x,
        'y': move.from.y,
        'state': onlineMe.index,
      },
      'to': {
        'x': move.to.x,
        'y': move.to.y,
        'state': CellState.empty.index,
      },
    });
  }

  static Future<Game> getOpenGame() async {
    QuerySnapshot query = await FirebaseFirestore.instance.collection('games').where('pending', isEqualTo: true).get();
    if (query.docs.isEmpty) return null;
    return Game.fromSnap(query.docs[0], isCreator: false);
  }

  static Future<void> joinGame(Game game) async {
    return FirebaseFirestore.instance.doc('games/${game.id}').update({
      'pending': false,
    });
  }

  static Future<String> createGame() async {
    String gameId = FirebaseFirestore.instance.collection('games').doc().id;
    await FirebaseFirestore.instance.doc('games/$gameId').set({
      'creator': Rules.randomPlayer().index,
      'starting_player': Rules.randomPlayer().index,
      'pending': true,
      'board_index': BoardBuilder.randomBoardIndex(),
    });
    return gameId;
  }

  static Stream<Game> waitForOpponent(String gameId) {
    return FirebaseFirestore.instance.doc('games/$gameId').snapshots().map((snap) => Game.fromSnap(snap, isCreator: true));
  }

  static Future<void> abortGame(String gameId) {
    return FirebaseFirestore.instance.doc('games/$gameId').delete();
  }
}
