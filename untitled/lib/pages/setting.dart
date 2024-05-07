import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}

class DarkMode extends StatelessWidget {
  const DarkMode({super.key});

  @override
  Widget build(BuildContext context) {
     return  MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: context.watch<ThemeProvider>().isDarkMode
          ? ThemeMode.dark
          : ThemeMode.light,
      
      home: const DarkModePage(),
    );
      
    
  }
}

class DarkModePage extends StatelessWidget {
  const DarkModePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Theme',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            ListTile(
              title: const Text('Dark Mode'),
              trailing: Switch(
                value: context.watch<ThemeProvider>().isDarkMode,
                onChanged: (value) {
                  context.read<ThemeProvider>().toggleTheme();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}