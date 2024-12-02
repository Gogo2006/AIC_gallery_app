import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:html/parser.dart';
import '../models/image_desc_model.dart';

class ImageInDepthPage extends StatefulWidget {
  final ImageDesc? imgDesc;

  const ImageInDepthPage({super.key, this.imgDesc});

  @override
  State<ImageInDepthPage> createState() => _ImageInDepthPage();
}

// displays everything within an ImageDesc
class _ImageInDepthPage extends State<ImageInDepthPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.imgDesc?.title}")
      ),
      body:
        DraggableScrollableSheet(
          initialChildSize: 1,
          minChildSize: 0.95,
          maxChildSize: 1,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            boxShadow: [BoxShadow(
                              color: Theme.of(context).colorScheme.secondary.withOpacity(0.15),
                              spreadRadius: 5,
                              blurRadius: 7,
                            )]
                        ),
                        height: 400,
                      ),
                      SizedBox(
                        width: 350,
                        height: 350,
                        child: CachedNetworkImage(
                          imageUrl: "https://www.artic.edu/iiif/2/${widget.imgDesc?.imgID}/full/843,/0/default.jpg",
                          placeholder: (context, url) => const CircularProgressIndicator(),
                          errorWidget: (context, url, error) => const Icon(Icons.hourglass_top),
                          ),
                      ),
                    ]
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                      width: 400,
                      child: Align(
                          alignment: Alignment.center,
                          child: Text("${widget.imgDesc?.title}", style: GoogleFonts.ebGaramond(textStyle: const TextStyle(fontSize: 30, fontWeight: FontWeight.w500))))),
                  const SizedBox(height: 15),
                  Text("${widget.imgDesc?.date}", style: GoogleFonts.openSans(textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w300))),
                  const SizedBox(height: 10),
                  SizedBox(
                      width: 400,
                      child: Align(
                        alignment: Alignment.center,
                          child: Text("${widget.imgDesc?.artistDesc?.replaceAll("\n", " ")}", style: GoogleFonts.openSans(textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w300))))),
                  const SizedBox(height: 40),
                  SizedBox(
                      width: 400,
                      child: Align(
                          alignment: Alignment.center,
                          child: ValidArtDesc())),
                ],
              ),
            );
          }
        )
    );
  }

  Text ValidArtDesc() {
    if (widget.imgDesc?.artDesc == null) {
      return Text("No description.", style: GoogleFonts.openSans(fontSize: 20),);
    }

    return Text("${parse(parse(widget.imgDesc?.artDesc).body?.text).documentElement?.text}", style: GoogleFonts.openSans(textStyle: const TextStyle(fontSize: 20)));
  }
}