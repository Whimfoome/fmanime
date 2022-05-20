import 'package:flutter/material.dart';
import 'package:fmanime/services/parser/basic_parser.dart';
import 'package:fmanime/utils/constats.dart';
import 'package:fmanime/ui/widgets/anime_grid.dart';

void main() {
  runApp(const Popular());
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
    const Center(child: Text("Anime")),
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

class Popular extends StatefulWidget {
  const Popular({Key? key}) : super(key: key);

  @override
  State<Popular> createState() => _PopularState();
}

class _PopularState extends State<Popular> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AnimeGo Re',
      home: FutureBuilder(
        future: init(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          // The data is simply a `true`
          if (snapshot.hasData) {
            return const LastestAnime();
          } else {
            // A simple loading screen so that it is not that boring
            return Scaffold(
              appBar: AppBar(
                title: const Text('Loading...'),
              ),
              body: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }

  Future<bool> init() async {
    await DomainParser(defaultDomain).getNewDomain();
    return true;
  }
}

class LastestAnime extends StatelessWidget {
  const LastestAnime({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Release'),
      ),
      body: AnimeGrid(
        url: '/page-recent-release.html',
      ),
    );
  }
}
