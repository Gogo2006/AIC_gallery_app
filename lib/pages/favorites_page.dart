import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import '../models/image_desc_model.dart';
import 'image_in_depth_page.dart';

// Structure of FavoritesPage: GridView holding however many favorite image slots
class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPage();
}

// uses the stored data in SharedPreferences to display all favorited ImageDesc objects as artworks
class _FavoritesPage extends State<FavoritesPage> {
  SharedPreferences? favImages;
  String userEmail = "";

  _getFavImages() async {
    final favImgs = await SharedPreferences.getInstance();

    try {
      setState(() {
        favImages = favImgs;
      });
    }
    catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();

    _getFavImages();
  }


  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    // String getFavoritesTag() {
    //   _getFavImages();
    //
    //   if (favImages?.getStringList("titles")?.length == 1) {
    //     return "You have "
    //         "${favImages?.getStringList("titles")?.length} favorite:";
    //   }
    //
    //   return "You have "
    //       "${favImages?.getStringList("titles")?.length ?? "0"} favorites:";
    // }

    return Scaffold(
      body: Center(
        child: Column(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Favorites", style: GoogleFonts.montserrat(fontSize: 30, fontWeight: FontWeight.w600),),
                          const SizedBox(width: 10),
                          const Icon(Icons.favorite),
                        ],
                      ),
                    const SizedBox(height: 13),
                    Divider(
                      indent: 5,
                      endIndent: 5,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ],
                )
              ),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  children: [
                    for (var index = 0; index < (favImages?.getStringList("titles")?.length ?? 0); index++)
                      FavImageSlot(index, context, appState),
                  ],
                ),
              ),
            ],
        ),
      ),
    );
  }

  Container FavImageSlot(int index, BuildContext context, MyAppState appState) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: const BorderRadius.all(Radius.circular(2)),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.15),
              spreadRadius: 5,
              blurRadius: 7,
            )
          ]
      ),
      child: Column(
        children: [
          Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                IconButton(
                  icon: SizedBox(
                    width: 160,
                    height: 160,
                    child: CachedNetworkImage(
                      imageUrl: "https://www.artic.edu/iiif/2/${favImages?.getStringList("imgIDs")?[index]}/full/843,/0/default.jpg",
                      errorWidget: (context, url, error) => const Icon(Icons.hourglass_top),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context)
                      => ImageInDepthPage(imgDesc: ImageDesc(
                          title: "${favImages?.getStringList("titles")?[index]}",
                          date: "${favImages?.getStringList("dates")?[index]}",
                          artistDesc: "${favImages?.getStringList("artistDescs")?[index]}",
                          artDesc: "${favImages?.getStringList("artDescs")?[index]}",
                          imgID: "${favImages?.getStringList("imgIDs")?[index]}"))),
                    );
                  },
                ),
                Positioned(
                  bottom: -20,
                  right: -20,
                  child: IconButton (
                    onPressed: () {
                      favImages?.setStringList("titles", favImages!.getStringList("titles")!.sublist(0, index) + favImages!.getStringList("titles")!.sublist(index+1, favImages!.getStringList("titles")!.length));
                      favImages?.setStringList("dates", favImages!.getStringList("dates")!.sublist(0, index) + favImages!.getStringList("dates")!.sublist(index+1, favImages!.getStringList("dates")!.length));
                      favImages?.setStringList("artistDescs", favImages!.getStringList("artistDescs")!.sublist(0, index) + favImages!.getStringList("artistDescs")!.sublist(index+1, favImages!.getStringList("artistDescs")!.length));
                      favImages?.setStringList("artDescs", favImages!.getStringList("artDescs")!.sublist(0, index) + favImages!.getStringList("artDescs")!.sublist(index+1, favImages!.getStringList("artDescs")!.length));
                      favImages?.setStringList("imgIDs", favImages!.getStringList("imgIDs")!.sublist(0, index) + favImages!.getStringList("imgIDs")!.sublist(index+1, favImages!.getStringList("imgIDs")!.length));

                      _getFavImages();
                    },
                    icon: const Icon(Icons.delete_outline, semanticLabel: "Delete", size: 25,),
                  ),
                ),
              ]
          ),
          Text("${appState.shrtndLine(favImages?.getStringList("titles")?[index])}, ${appState.shrtndDate(favImages?.getStringList(
              "dates")?[index])})", style: GoogleFonts.openSans(textStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600))),
          Text(appState.shrtndLine(favImages?.getStringList("artistDescs")?[index].replaceAll("\n", " ")), style: GoogleFonts.openSans(textStyle: const TextStyle(fontSize: 10))),
        ],
      )
    );
  }
}