import 'package:flutter/material.dart';
import 'package:fmanime/route_generator.dart';
import 'package:fmanime/ui/pages/anime_page.dart';
import 'package:fmanime/ui/pages/manga_page.dart';
import 'package:fmanime/utils/boxes.dart';
import 'package:fmanime/utils/theme.dart';

void main() async {
  await Boxes.initializeBoxes();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fmanime',
      darkTheme: appTheme(),
      themeMode: ThemeMode.dark,
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
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
  int currentIndex = 0;
  final screens = [
    const AnimePage(),
    const MangaPage(),
    //const Center(child: Text('Settings')),
  ];

  void updateIndex(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          label: 'Anime',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.book),
          label: 'Manga',
        ),
        // BottomNavigationBarItem(
        //   icon: Icon(Icons.settings),
        //   label: 'Settings',
        // ),
      ],
    );
  }
}
