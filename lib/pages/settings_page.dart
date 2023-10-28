import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:noxio/models/app_model.dart';
import 'package:noxio/utils/themes.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(24.0),
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text('Choose Theme'),
              subtitle: Text(Provider.of<AppModel>(context).themeName),
              onTap: () => showThemeBottomSheet(context),
            ),
            Divider(),
            ListTile(
              title: Text('Choose Player 1 Color'),
              trailing: Container(
                height: 32,
                width: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Provider.of<AppModel>(context).primary,
                ),
              ),
              onTap: () => showPrimaryColorBottomSheet(context),
            ),
            Divider(),
            ListTile(
              title: Text('Choose Player 2 Color'),
              trailing: Container(
                height: 32,
                width: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Provider.of<AppModel>(context).secondary,
                ),
              ),
              onTap: () => showSecondaryColorBottomSheet(context),
            ),
            Divider(),
            AboutListTile(
              applicationName: 'Noxio',
              applicationVersion: '1.0.0',
            )
          ],
        ),
      ),
    );
  }

  void showPrimaryColorBottomSheet(context) => showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Choose Player 1 Color',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: MaterialColorPicker(
                  onColorChange: (Color color) {
                    Provider.of<AppModel>(context, listen: false).setPrimaryColor(color);
                    Navigator.pop(context);
                  },
                  selectedColor: Provider.of<AppModel>(context).primary,
                  physics: NeverScrollableScrollPhysics(),
                ),
              ),
            ],
          );
        },
      );

  void showSecondaryColorBottomSheet(context) => showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Choose Player 2 Color',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: MaterialColorPicker(
                  onColorChange: (Color color) {
                    Provider.of<AppModel>(context, listen: false).setSecondaryColor(color);
                    Navigator.pop(context);
                  },
                  selectedColor: Provider.of<AppModel>(context).secondary,
                  physics: NeverScrollableScrollPhysics(),
                ),
              ),
            ],
          );
        },
      );

  void showThemeBottomSheet(context) => showModalBottomSheet(
        context: context,
        builder: (context) {
          return ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Choose Theme',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              ...NoxioThemes().map.keys.map(
                    (String themeName) => ListTile(
                      title: Text(themeName),
                      onTap: () {
                        Provider.of<AppModel>(context, listen: false).setTheme(themeName);
                        Navigator.pop(context);
                      },
                      selected: themeName == Provider.of<AppModel>(context).themeName,
                    ),
                  )
            ],
          );
        },
      );
}
