import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum Direction { up, down, left, right }

class SnakeGame extends StatefulWidget {
  const SnakeGame({super.key});

  @override
  State<SnakeGame> createState() => _SnakeGameState();
}

class _SnakeGameState extends State<SnakeGame> {
  static const int gridSize = 20;
  static const int cellCount = gridSize * gridSize;
  static const Duration gameSpeed = Duration(milliseconds: 150);

  List<int> snake = [42, 41, 40];
  int food = 100;
  Direction direction = Direction.right;
  Direction? nextDirection;
  bool isPlaying = false;
  bool isGameOver = false;
  int score = 0;
  Timer? gameTimer;
  final FocusNode _focusNode = FocusNode();
  final Random _random = Random();

  @override
  void dispose() {
    gameTimer?.cancel();
    _focusNode.dispose();
    super.dispose();
  }

  void startGame() {
    setState(() {
      snake = [42, 41, 40];
      direction = Direction.right;
      nextDirection = null;
      isPlaying = true;
      isGameOver = false;
      score = 0;
      _generateFood();
    });

    gameTimer?.cancel();
    gameTimer = Timer.periodic(gameSpeed, (_) => _moveSnake());
    _focusNode.requestFocus();
  }

  void _generateFood() {
    do {
      food = _random.nextInt(cellCount);
    } while (snake.contains(food));
  }

  void _moveSnake() {
    if (!isPlaying) return;

    setState(() {
      if (nextDirection != null) {
        direction = nextDirection!;
        nextDirection = null;
      }

      int head = snake.first;
      int newHead;

      switch (direction) {
        case Direction.up:
          newHead = head - gridSize;
          if (newHead < 0) newHead += cellCount;
          break;
        case Direction.down:
          newHead = head + gridSize;
          if (newHead >= cellCount) newHead -= cellCount;
          break;
        case Direction.left:
          newHead = head % gridSize == 0 ? head + gridSize - 1 : head - 1;
          break;
        case Direction.right:
          newHead = (head + 1) % gridSize == 0 ? head - gridSize + 1 : head + 1;
          break;
      }

      if (snake.contains(newHead)) {
        _gameOver();
        return;
      }

      snake.insert(0, newHead);

      if (newHead == food) {
        score += 10;
        _generateFood();
      } else {
        snake.removeLast();
      }
    });
  }

  void _gameOver() {
    gameTimer?.cancel();
    isPlaying = false;
    isGameOver = true;
  }

  void _setDirection(Direction newDir) {
    if (!isPlaying) return;

    if ((direction == Direction.up && newDir == Direction.down) ||
        (direction == Direction.down && newDir == Direction.up) ||
        (direction == Direction.left && newDir == Direction.right) ||
        (direction == Direction.right && newDir == Direction.left)) {
      return;
    }

    nextDirection = newDir;
  }

  void _handleKey(KeyEvent event) {
    if (event is! KeyDownEvent) return;

    switch (event.logicalKey) {
      case LogicalKeyboardKey.arrowUp:
      case LogicalKeyboardKey.keyW:
        _setDirection(Direction.up);
        break;
      case LogicalKeyboardKey.arrowDown:
      case LogicalKeyboardKey.keyS:
        _setDirection(Direction.down);
        break;
      case LogicalKeyboardKey.arrowLeft:
      case LogicalKeyboardKey.keyA:
        _setDirection(Direction.left);
        break;
      case LogicalKeyboardKey.arrowRight:
      case LogicalKeyboardKey.keyD:
        _setDirection(Direction.right);
        break;
      case LogicalKeyboardKey.space:
        if (!isPlaying) startGame();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        title: const Text('Snake'),
        centerTitle: true,
        backgroundColor: Colors.grey.shade800,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: KeyboardListener(
        focusNode: _focusNode,
        autofocus: true,
        onKeyEvent: _handleKey,
        child: GestureDetector(
          onVerticalDragUpdate: (details) {
            if (details.delta.dy < -5) _setDirection(Direction.up);
            if (details.delta.dy > 5) _setDirection(Direction.down);
          },
          onHorizontalDragUpdate: (details) {
            if (details.delta.dx < -5) _setDirection(Direction.left);
            if (details.delta.dx > 5) _setDirection(Direction.right);
          },
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.star, color: Colors.amber.shade400, size: 24),
                    const SizedBox(width: 8),
                    Text(
                      'Score: $score',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      margin: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade800,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.grey.shade700,
                          width: 2,
                        ),
                      ),
                      child: Stack(
                        children: [
                          GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: gridSize,
                            ),
                            itemCount: cellCount,
                            itemBuilder: (context, index) {
                              final isSnakeHead = snake.isNotEmpty && snake.first == index;
                              final isSnakeBody = snake.contains(index) && !isSnakeHead;
                              final isFood = index == food;

                              Color cellColor;
                              BorderRadius? borderRadius;

                              if (isSnakeHead) {
                                cellColor = Colors.green.shade400;
                                borderRadius = BorderRadius.circular(4);
                              } else if (isSnakeBody) {
                                cellColor = Colors.green.shade600;
                                borderRadius = BorderRadius.circular(2);
                              } else if (isFood) {
                                cellColor = Colors.red.shade400;
                                borderRadius = BorderRadius.circular(8);
                              } else {
                                return const SizedBox();
                              }

                              return Container(
                                margin: const EdgeInsets.all(1),
                                decoration: BoxDecoration(
                                  color: cellColor,
                                  borderRadius: borderRadius,
                                ),
                              );
                            },
                          ),
                          if (!isPlaying)
                            Container(
                              color: Colors.black54,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (isGameOver) ...[
                                      const Text(
                                        'Game Over!',
                                        style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Score: $score',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey.shade300,
                                        ),
                                      ),
                                      const SizedBox(height: 24),
                                    ],
                                    ElevatedButton.icon(
                                      onPressed: startGame,
                                      icon: const Icon(Icons.play_arrow),
                                      label: Text(
                                          isGameOver ? 'Play Again' : 'Start'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 24,
                                          vertical: 12,
                                        ),
                                      ),
                                    ),
                                    if (!isGameOver) ...[
                                      const SizedBox(height: 16),
                                      Text(
                                        'Use arrow keys or swipe',
                                        style: TextStyle(
                                          color: Colors.grey.shade400,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              _buildControls(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControls() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildControlButton(Icons.arrow_upward, () => _setDirection(Direction.up)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildControlButton(Icons.arrow_back, () => _setDirection(Direction.left)),
              const SizedBox(width: 48),
              _buildControlButton(Icons.arrow_forward, () => _setDirection(Direction.right)),
            ],
          ),
          _buildControlButton(Icons.arrow_downward, () => _setDirection(Direction.down)),
        ],
      ),
    );
  }

  Widget _buildControlButton(IconData icon, VoidCallback onPressed) {
    return Container(
      margin: const EdgeInsets.all(4),
      child: Material(
        color: Colors.grey.shade700,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
        ),
      ),
    );
  }
}
