import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// This widget is for displaying a configuration dialog for IP and Port settings.
class ConfigDialog extends StatefulWidget {
  /// Constructor for `ConfigDialog` widget.
  ///
  const ConfigDialog({super.key});

  @override
  State<ConfigDialog> createState() => _ConfigDialogState();
}

/// State class for [ConfigDialog] widget.
class _ConfigDialogState extends State<ConfigDialog> {
  /// The TextController field for IP address.
  TextEditingController ipController = TextEditingController();
  /// The TextController field for Port number.
  TextEditingController portController = TextEditingController();
  /// The store for IP and Port settings
  final storage = const FlutterSecureStorage();


  @override
  void initState() {
    super.initState();
    _loadConfig();
  }
  /// Loads the IP and Port configuration settings from storage.
  void _loadConfig() async {
    final ip = await storage.read(key: 'ip');
    final port = await storage.read(key: 'port');
    if (ip != null && port != null) {
      setState(() {
        ipController.text = ip;
        portController.text = port;
      });
    }
  }
  /// Saves the IP and Port configuration settings to storage.
  void _saveConfig() async {
    await storage.write(key: 'ip', value: ipController.text);
    await storage.write(key: 'port', value: portController.text);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Configuration IP et Port'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            controller: ipController,
            decoration: const InputDecoration(labelText: 'Adresse IP'),
          ),
          TextField(
            controller: portController,
            decoration: const InputDecoration(labelText: 'Port'),
          ),
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            _saveConfig();
            Navigator.of(context).pop();
          },
          child: const Text('Enregistrer'),
        ),
      ],
    );
  }
}

/// This widget is for displaying a configuration dialog for IP and Port settings.
/// 
/// - [context] is the context of the configuration dialog.
void showConfigDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return const ConfigDialog();
    },
  );
}
