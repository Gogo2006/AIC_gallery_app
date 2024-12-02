import 'package:aic_gallery_app/pages/favorites_page.dart';
import 'package:aic_gallery_app/pages/gallery_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../theme/themes.dart';

// StatefulWidget lets HomePage change itself
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}


// Structure of HomePage: App bar on top, a column in the body composed of an Expanded
// which displays the current page and a SafeArea which contains Navigation buttons
// (which switch the page)
class _HomePage extends State<HomePage> {
  var selectedIndex = 0;
  //bool _isLightMode = true;

  @override
  void initState() {
    super.initState();

    var appState = Provider.of<MyAppState>(context, listen: false);
    appState.updateTheme();
  }


  @override
  Widget build(BuildContext context) {
    Widget page;
    var appState = context.watch<MyAppState>();

    String getLogo() {
      if (appState.currTheme == lightMode) {
        return 'assets/aic_logo.png';
      }
      return 'assets/dark_mode_logo.png';
    }

    AlertDialog showLoc = AlertDialog(
      title: Text("Visit the Art Institute of Chicago", style: GoogleFonts.openSans(fontWeight: FontWeight.w600),),
      content: Text("111 S Michigan Ave, Chicago, IL 60603", style: GoogleFonts.openSans(fontSize: 17)),
      actions: [
        TextButton(
        child: const Text("OK"),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
        ),
      ],
    );

    switch (selectedIndex) {
      case 0:
        page = const GalleryPage();
        break;
      case 1:
        page = const FavoritesPage();
        break;
      default:
        throw UnimplementedError('No widget for $selectedIndex.');
    }

    var mainArea = ColoredBox(
      color: Theme.of(context).colorScheme.primary,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: page,
      ),
    );

    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 70,
          title: SizedBox(
              width: 70,
              height: 70,
              child: Image.asset(getLogo())
          ),
          actions: <Widget>[
            IconButton(
                icon: const Icon(Icons.location_city),
              tooltip: "View location",
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return showLoc;
                  },
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.lightbulb),
              tooltip: "Switch theme",
              onPressed: () {
                appState.switchTheme();
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(child: mainArea),
            SafeArea(
              child: BottomNavigationBar(
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home, color: Theme.of(context).colorScheme.tertiary,),
                    label: "Home",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.favorite, color: Theme.of(context).colorScheme.tertiary,),
                    label: "Favorites",
                  ),
                ],
                currentIndex: selectedIndex,
                onTap: (value) {
                  setState(() {
                    selectedIndex = value;
                  });
                },
              ),
            )
          ],
        )
    );
  }

}

