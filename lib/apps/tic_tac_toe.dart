import 'package:flutter/material.dart';

class TicTacToe extends StatefulWidget {
  const TicTacToe({super.key});

  @override
  State<TicTacToe> createState() => _TicTacToeState();
}

class _TicTacToeState extends State<TicTacToe> {
  List<String> _board = List.filled(9, '');
  bool _isXTurn = true;
  String? _winner;
  List<int>? _winningLine;

  void _handleTap(int index) {
    if (_board[index].isNotEmpty || _winner != null) return;

    setState(() {
      _board[index] = _isXTurn ? 'X' : 'O';
      _isXTurn = !_isXTurn;
      _checkWinner();
    });
  }

  void _checkWinner() {
    const lines = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (final line in lines) {
      final a = _board[line[0]];
      final b = _board[line[1]];
      final c = _board[line[2]];

      if (a.isNotEmpty && a == b && b == c) {
        _winner = a;
        _winningLine = line;
        return;
      }
    }

    if (!_board.contains('')) {
      _winner = 'Draw';
    }
  }

  void _resetGame() {
    setState(() {
      _board = List.filled(9, '');
      _isXTurn = true;
      _winner = null;
      _winningLine = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Tic-Tac-Toe'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _resetGame,
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset Game',
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildStatus(),
          const SizedBox(height: 32),
          _buildBoard(),
          const SizedBox(height: 32),
          if (_winner != null)
            ElevatedButton.icon(
              onPressed: _resetGame,
              icon: const Icon(Icons.refresh),
              label: const Text('Play Again'),
            ),
        ],
      ),
    );
  }

  Widget _buildStatus() {
    String status;
    Color color;

    if (_winner == 'Draw') {
      status = "It's a Draw!";
      color = Colors.orange;
    } else if (_winner != null) {
      status = '$_winner Wins!';
      color = _winner == 'X' ? Colors.blue : Colors.red;
    } else {
      status = "${_isXTurn ? 'X' : 'O'}'s Turn";
      color = _isXTurn ? Colors.blue : Colors.red;
    }

    return Text(
      status,
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: color,
      ),
    );
  }

  Widget _buildBoard() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: 9,
            itemBuilder: (context, index) => _buildCell(index),
          ),
        ),
      ),
    );
  }

  Widget _buildCell(int index) {
    final value = _board[index];
    final isWinningCell = _winningLine?.contains(index) ?? false;

    return GestureDetector(
      onTap: () => _handleTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isWinningCell
              ? Colors.green.shade100
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: isWinningCell
              ? Border.all(color: Colors.green, width: 3)
              : null,
        ),
        child: Center(
          child: AnimatedScale(
            scale: value.isEmpty ? 0 : 1,
            duration: const Duration(milliseconds: 200),
            child: Text(
              value,
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: value == 'X' ? Colors.blue : Colors.red,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
