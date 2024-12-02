import 'package:aic_gallery_app/pages/exhibs_display_page.dart';
import 'package:aic_gallery_app/services/gallery_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:string_validator/string_validator.dart';

import '../main.dart';
import '../models/exhibition_model.dart';
import '../models/image_desc_model.dart';
import '../models/num_results_model.dart';
import 'image_in_depth_page.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPage();
}

// Structure of GalleryPage: Column composed of a TextField and a GridView
// holding 10 image slots
class _GalleryPage extends State<GalleryPage> {
  var selectedIndex = 0;

  var imageDescs = <ImageDesc?>[];
  var exhibitions = <Exhibition?>[];

  int currPageNum = 1;

  // _galleryService is initially set to an empty search on the 1st page
  final _galleryService = GalleryService("", 1);

  // object to store the # of results for a given search
  NumResults? _numResults;

  // when _galleryService is updated, currSearch is passed to get the new correct API call url
  String currSearch = "";
  late TextEditingController _controller;

  // _favImages stores ImageDesc objects through String lists containing their titles, dates, imgIDs, etc.
  SharedPreferences? _favImages;

  // Exhibition objects aren't dependent on # of search results, so this is a separate async func to generate them at the start of the page's lifespan
  _fetchExhibitions() async {
    for(int j = 0; j < _galleryService.getExhibLimit(); j++) {
      final newExhib = await _galleryService.getExhibition(j);

      if (mounted && newExhib.primaryImgID != null && newExhib.altImageIDs!.isNotEmpty) {
        setState(() {
          exhibitions.add(newExhib);
        });
      }
    }
  }

  // Finds the # of search results, then instantiates that many ImageDesc objects (max is 100)
  _fetchImageDesc() async {
    try {
      final favImages = await SharedPreferences.getInstance();
      final numResults = await _galleryService.getNumResults();
      int limit;

      if (mounted) {
        setState(() {
          _favImages = favImages;
          _numResults = numResults;
        });
      }

      if (_numResults!.count >= 100) {
        limit = 100;
      }
      else {
        limit = _numResults!.count;
      }

      int i = 0;
      while (currSearch == "" && i < limit) {
        final newImageDesc = await _galleryService.getImageDesc(i, limit);

        if (mounted) {
          setState(() {
            imageDescs.add(newImageDesc);
          });
        }

        // if the current search changes while ImageDesc objects are being generated, this will clear all of them so that
        // the results of the previous search don't show up with the current one's
        if (currSearch != "") {
          imageDescs = <ImageDesc?>[];
        }

        i++;
      }
    }
    catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();

    _fetchExhibitions();
    _fetchImageDesc();
    _controller = TextEditingController();
  }

  // updates _galleryService with the new search and page #, which depends on whether the user went forward or back;
  // finds the new # of results and instantiates that many new ImageDesc objects
  _updateGallery(pageNum) async {
    try {
      final searchGallery = GalleryService(currSearch, pageNum);
      final searchNumResults = await searchGallery.getNumResults();
      int limit;
      String prevSearch = currSearch;

      if (searchNumResults.count >= 100) {
        limit = 100;
      }
      else {
        limit = searchNumResults.count;
      }

      if (limit * pageNum <= searchNumResults.count) {
        if (mounted) {
          setState(() {
            imageDescs = <ImageDesc?>[];
          });
        }

        int i = 0;

        while (currSearch == prevSearch && i < limit) {
          final newImageDesc = await searchGallery.getImageDesc(i, limit);

          if (mounted) {
            setState(() {
              imageDescs.add(newImageDesc);
            });
          }

          if (currSearch != prevSearch) {
            imageDescs = <ImageDesc?>[];
          }

          i++;
        }
      }
    }
    catch (e) {
      print(e);
    }
  }

  // updates the favorite icon next to each artwork
  IconData _getFavIcon(ImageDesc? imgDesc) {
    if (_favImages?.getStringList("titles") == null || !_favImages!.getStringList("titles")!.contains(imgDesc?.title)) {
      return Icons.favorite_border;
    }
    return Icons.favorite;
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }


  // UI: Textfield for user searches, OutlinedButton for viewing individual Exhibition pages, GridView to display all ImageDesc objects
  // as artworks, 2 IconButtons for switching back and forth between pages of results
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
            children: [
              const SizedBox(height: 20),
              SizedBox(
                width: 425,
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    labelText: "Search by keyword, artist, or reference",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (String value) {
                    if (isAlpha(value)) {
                      setState(() {
                        currSearch = value;
                      });
                      _updateGallery(1);
                    }
                  },
                ),
              ),
              const SizedBox(height: 3),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  )
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context)
                    => ExhibitionsDisplayPage(exhibs: exhibitions)),
                  );
                },
                child: Text("EXHIBITIONS", style: GoogleFonts.openSans(fontSize: 15,
                    color: Theme.of(context).colorScheme.tertiary),),
              ),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  children: [
                    for (ImageDesc? imageDesc in imageDescs)
                      ImageSlot(imageDesc),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    iconSize: 15,
                    icon: const Column(
                      children: [
                        Icon(Icons.arrow_back),
                        Text("Back", style: TextStyle(fontSize: 11),),
                      ],
                    ),
                    onPressed: () {
                      if (currPageNum > 1) {
                        currPageNum--;
                        _updateGallery(currPageNum);
                      }
                    },
                  ),
                  IconButton(
                    iconSize: 15,
                    icon: const Column(
                      children: [
                        Icon(Icons.arrow_forward),
                        Text("Next", style: TextStyle(fontSize: 11),),
                      ],
                    ),
                    onPressed: () {
                      currPageNum++;
                      _updateGallery(currPageNum);
                    },
                  ),
                ],
              ),
            ],
          )
      ),
    );
  }

  Container ImageSlot(ImageDesc? imgDesc) {
    var appState = context.watch<MyAppState>();

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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                IconButton(
                  icon: SizedBox(
                    width: 150,
                    height: 150,
                    child: CachedNetworkImage(
                      imageUrl: "https://www.artic.edu/iiif/2/${imgDesc?.imgID}/full/843,/0/default.jpg",
                      errorWidget: (context, url, error) => const Icon(Icons.hourglass_top),
                    ),

                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context)
                      => ImageInDepthPage(imgDesc: imgDesc)),
                    );
                  },
                ),
                Positioned(
                  bottom: -20,
                  right: -20,
                  child: IconButton (
                    onPressed: () async {
                      if (mounted) {
                        setState(() {
                          if (_favImages?.getStringList("titles") == null) {
                            _favImages?.setStringList("titles", <String>[]);
                          }
                          if (_favImages?.getStringList("dates") == null) {
                            _favImages?.setStringList("dates", <String>[]);
                          }
                          if (_favImages?.getStringList("artistDescs") == null) {
                            _favImages?.setStringList("artistDescs", <String>[]);
                          }
                          if (_favImages?.getStringList("artDescs") == null) {
                            _favImages?.setStringList("artDescs", <String>[]);
                          }
                          if (_favImages?.getStringList("imgIDs") == null) {
                            _favImages?.setStringList("imgIDs", <String>[]);
                          }

                          _favImages!.setStringList(
                              "titles",
                              _favImages!.getStringList("titles")! +
                                  <String>["${imgDesc?.title}"]);
                          _favImages!.setStringList(
                              "dates",
                              _favImages!.getStringList("dates")! +
                                  <String>["${imgDesc?.date}"]);
                          _favImages!.setStringList(
                              "artistDescs",
                              _favImages!.getStringList("artistDescs")! +
                                  <String>["${imgDesc?.artistDesc}"]);
                          _favImages!.setStringList(
                              "artDescs",
                              _favImages!.getStringList("artDescs")! +
                                  <String>["${imgDesc?.artDesc}"]);
                          _favImages!.setStringList(
                              "imgIDs",
                              _favImages!.getStringList("imgIDs")! +
                                  <String>["${imgDesc?.imgID}"]);
                        });
                      }
                    },
                    icon: Icon(_getFavIcon(imgDesc)),
                  ),
                ),
              ],
            ),
            Text("${appState.shrtndLine(imgDesc?.title)}, ${appState.shrtndDate(imgDesc?.date)}", style: GoogleFonts.openSans(textStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600))),
            Text(appState.shrtndLine(imgDesc?.artistDesc?.replaceAll("\n", " ")), style: GoogleFonts.openSans(textStyle: const TextStyle(fontSize: 10))),
          ],
        ),
    );
  }
}