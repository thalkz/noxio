import 'package:flutter/material.dart';
import 'package:noxio/models.dart';
import 'package:noxio/models/game_model.dart';
import 'package:noxio/rules.dart';
import 'package:noxio/widgets/cell_widget.dart';
import 'package:provider/provider.dart';

class BoardWidget extends StatefulWidget {
  @override
  _BoardWidgetState createState() => _BoardWidgetState();
}

class _BoardWidgetState extends State<BoardWidget> {
  Cell _selectedCell;

  @override
  Widget build(BuildContext context) {
    return Consumer<GameModel>(
      builder: (context, model, child) {
        return AspectRatio(
          aspectRatio: 1,
          child: GridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8, childAspectRatio: 1.0),
            children: _buildCells(model),
            physics: NeverScrollableScrollPhysics(),
          ),
        );
      },
    );
  }

  List<Widget> _buildCells(GameModel model) {
    return model.board.cells.map((cell) {
      return CellWidget(
        cell: cell,
        selectedCell: _selectedCell,
        currentPlayer: model.currentPlayer,
        onTap: model.winner == null && cell.state != CellState.stone ? () => _onCellTap(model, cell) : null,
      );
    }).toList();
  }

  void _onCellTap(GameModel model, Cell cell) {
    if (model.online && model.currentPlayer != model.onlineMe) return;
    if (model.vsAi && model.currentPlayer == Player.red) return;

    if (Rules.isPlayer(model.currentPlayer, cell) && !Rules.isSame(cell, _selectedCell)) {
      setState(() {
        _selectedCell = cell;
      });
    } else {
      if (Rules.canDuplicateTo(_selectedCell, cell)) {
        Provider.of<GameModel>(context, listen: false).nextTurn(Move.duplicate(_selectedCell, cell));
      } else if (Rules.canJumpTo(_selectedCell, cell)) {
        Provider.of<GameModel>(context, listen: false).nextTurn(Move.jump(_selectedCell, cell));
      }
      if (_selectedCell != null) {
        setState(() {
          _selectedCell = null;
        });
      }
    }
  }
}
