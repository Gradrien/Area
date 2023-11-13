import 'package:client_mobile/styles/glassmorphism_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// A widget for connecting to a service.
class ConnectWith extends StatelessWidget {
  /// The name of the service to connect
  final String serviceName;
  /// The icon of the service to connect
  final String serviceIcon;
  /// A callback function to be called when the button is pressed.
  final Function onPressed;

  /// Constructor for the `ConnectWith` widget.
  /// 
  /// - `serviceName`: The name of the service to connect
  /// - `serviceIcon`: The icon of the service to connect
  /// - `onPressed`: A callback function to be called when the button is pressed
  const ConnectWith(
      {super.key,
      required this.serviceName,
      required this.serviceIcon,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GlassContainerRounded(
      width: Size.infinite.width,
      height: 50,
      borderRadius: 15,
      borderColor: Colors.white,
      colorOpacity: 0.9,
      child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: BorderSide.none,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          onPressed: () async {
            onPressed();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.network(serviceIcon, width: 24, height: 24),
              const SizedBox(width: 12),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    "Se connecter avec $serviceName",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}

/// A widget for displaying the connected service.
class ConnectedTo extends StatefulWidget {
  /// The icon of the service connected
  final String serviceIcon;
  /// A callback function to be called when the service is deleted.
  final Function onDelete;
  /// The name of the service connected
  final String serviceName;

  /// Constructor for the `ConnectedTo` widget.
  /// 
  /// - `serviceIcon`: The icon of the service connected
  /// - `onDelete`: A callback function to be called when the service is deleted
  /// - `serviceName`: The name of the service connected
  const ConnectedTo(
      {super.key,
      required this.serviceIcon,
      required this.onDelete,
      required this.serviceName});

  @override
  _ConnectedToState createState() => _ConnectedToState();
}

/// The state of the [ConnectedTo] widget.
class _ConnectedToState extends State<ConnectedTo> {
  /// Function to be called when the delete button is pressed.
  void _handleDelete() async {
      if (widget.serviceName != "FootLive" &&
          widget.serviceName != "Bordeaux Métropole") {
        final bool result =
            await showDeleteConfirmationDialog(context, widget.serviceName);
        if (result) {
          widget.onDelete();
        }
      }
  }

  @override
  Widget build(BuildContext context) {
    return GlassContainerRounded(
      width: Size.infinite.width,
      height: 50,
      borderRadius: 15,
      borderColor: Colors.white,
      colorOpacity: 0.9,
      child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: BorderSide.none,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onPressed: _handleDelete,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      SvgPicture.network(widget.serviceIcon,
                          width: 24, height: 24),
                      const SizedBox(width: 12),
                      const Text(
                        "Connecté",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  SvgPicture.asset("assets/connectedIcon.svg",
                      width: 24, height: 24),
                ],
              ),
            ),
    );
  }

  Future<bool> showDeleteConfirmationDialog(
      BuildContext context, String serviceName) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation de suppression'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  'Êtes-vous sûr de vouloir supprimer le service $serviceName ?'),
              const SizedBox(height: 12),
              const Text(
                  'Toutes vos areas associées à ce service seront supprimées.'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Fermer'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Supprimer'),
            ),
          ],
        );
      },
    );
    return confirmed ?? false;
  }
}
