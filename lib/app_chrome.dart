import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/app_state.dart';
import 'widgets/app_switcher.dart';
import 'widgets/viewport_container.dart';
import 'widgets/viewport_settings.dart';
import 'apps/todo_app.dart';
import 'apps/tic_tac_toe.dart';
import 'apps/snake_game.dart';

class AppChrome extends StatelessWidget {
  const AppChrome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            const AppSwitcher(),
            const SizedBox(height: 8),
            _buildViewportLabel(context),
            const SizedBox(height: 16),
            Expanded(
              child: ViewportContainer(
                child: _buildCurrentApp(context),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      floatingActionButton: const ViewportSettings(),
    );
  }

  Widget _buildViewportLabel(BuildContext context) {
    final preset = context.watch<AppState>().viewportPreset;
    return Text(
      '${preset.name} (${preset.width.toInt()} x ${preset.height.toInt()})',
      style: TextStyle(
        fontSize: 12,
        color: Colors.grey.shade600,
      ),
    );
  }

  Widget _buildCurrentApp(BuildContext context) {
    final currentApp = context.watch<AppState>().currentApp;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: switch (currentApp) {
        AppType.todo => const TodoApp(key: ValueKey('todo')),
        AppType.ticTacToe => const TicTacToe(key: ValueKey('tictactoe')),
        AppType.snake => const SnakeGame(key: ValueKey('snake')),
      },
    );
  }
}
