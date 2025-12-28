import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';

class ViewportSettings extends StatelessWidget {
  const ViewportSettings({super.key});

  void _showSettingsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => const _SettingsSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _showSettingsSheet(context),
      tooltip: 'Viewport Settings',
      child: const Icon(Icons.phone_android),
    );
  }
}

class _SettingsSheet extends StatelessWidget {
  const _SettingsSheet();

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final currentPreset = appState.viewportPreset;

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Viewport Size',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          ...ViewportPreset.presets.map((preset) => ListTile(
                leading: Icon(
                  preset == currentPreset
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  color: preset == currentPreset
                      ? Theme.of(context).colorScheme.primary
                      : null,
                ),
                title: Text(preset.name),
                subtitle: Text('${preset.width.toInt()} x ${preset.height.toInt()}'),
                onTap: () {
                  appState.setViewportPreset(preset);
                  Navigator.pop(context);
                },
              )),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
