import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';

class AppSwitcher extends StatelessWidget {
  const AppSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildPill(
          context,
          'To-Do',
          AppType.todo,
          appState.currentApp == AppType.todo,
          () => appState.setCurrentApp(AppType.todo),
        ),
        const SizedBox(width: 8),
        _buildPill(
          context,
          'Tic-Tac-Toe',
          AppType.ticTacToe,
          appState.currentApp == AppType.ticTacToe,
          () => appState.setCurrentApp(AppType.ticTacToe),
        ),
        const SizedBox(width: 8),
        _buildPill(
          context,
          'Snake',
          AppType.snake,
          appState.currentApp == AppType.snake,
          () => appState.setCurrentApp(AppType.snake),
        ),
      ],
    );
  }

  Widget _buildPill(
    BuildContext context,
    String label,
    AppType appType,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline.withValues(alpha: 0.5),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
