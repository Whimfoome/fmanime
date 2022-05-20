import 'package:flutter/material.dart';
import 'package:fmanime/ui/pages/anime_discover.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Fmanime",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const NavBar(title: "Fmanime"),
    );
  }
}

class NavBar extends StatefulWidget {
  const NavBar({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int currentIndex = 2;
  final screens = [
    const Discover(),
    const Center(child: Text("Manga")),
    const Center(child: Text("Settings")),
  ];

  void updateIndex(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: myNavBar(),
    );
  }

  BottomNavigationBar myNavBar() {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (newIndex) => updateIndex(newIndex),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.play_arrow),
          label: "Anime",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.book),
          label: "Manga",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: "Settings",
        ),
      ],
    );
  }
}
