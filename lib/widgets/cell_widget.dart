import 'package:flutter/material.dart';
import 'package:noxio/models.dart';
import 'package:noxio/rules.dart';
import 'package:noxio/utils/colors.dart';

class CellWidget extends StatelessWidget {
  final int animationDuration = 350;

  final Cell cell;
  final Cell selectedCell;
  final Player currentPlayer;
  final VoidCallback onTap;

  const CellWidget({
    @required this.cell,
    @required this.selectedCell,
    @required this.currentPlayer,
    @required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        curve: Curves.easeIn,
        duration: Duration(milliseconds: animationDuration),
        margin: _cellDuplicateMargin,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_borderRadius),
          color: _cellColor(cell, context),
        ),
        child: _buildDot(context),
      ),
    );
  }

  double get _borderRadius {
    if (cell.state == CellState.stone || cell.state == CellState.empty) {
      return 8;
    } else {
      return 30;
    }
  }

  EdgeInsets get _cellDuplicateMargin {
    if (cell.state == CellState.empty) {
      return const EdgeInsets.all(10);
    } else if (cell.state == CellState.stone) {
      return const EdgeInsets.all(5);
    } else {
      return const EdgeInsets.all(3);
    }
  }

  Color _cellColor(Cell cell, BuildContext context) {
    if (cell == null) return NoxioColors.white(context);
    switch (cell.state) {
      case CellState.blue:
        return NoxioColors.blue(context);
      case CellState.red:
        return NoxioColors.red(context);
      case CellState.stone:
        return NoxioColors.black(context);
      default:
        return NoxioColors.white(context).withOpacity(0.6);
    }
  }

  Widget _buildDot(context) {
    if (selectedCell != null && Rules.canJumpTo(selectedCell, cell)) {
      return Center(
        child: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _cellColor(selectedCell, context),
          ),
        ),
      );
    } else if (selectedCell != null && Rules.canDuplicateTo(selectedCell, cell)) {
      return Center(
        child: Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: _cellColor(selectedCell, context),
              width: 3,
            ),
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}
