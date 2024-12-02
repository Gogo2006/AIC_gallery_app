import 'package:aic_gallery_app/pages/exhib_in_depth_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/exhibition_model.dart';

class ExhibitionsDisplayPage extends StatefulWidget {
  final List<Exhibition?> exhibs;

  const ExhibitionsDisplayPage({super.key, required this.exhibs});

  @override
  State<ExhibitionsDisplayPage> createState() => _ExhibitionsDisplayPage();
}

// displays all Exhibition objects
class _ExhibitionsDisplayPage extends State<ExhibitionsDisplayPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Exhibitions"),
      ),
      body: Center(
        child:
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text("Exhibitions", style: GoogleFonts.montserrat(fontSize: 30, fontWeight: FontWeight.w600)),
              ),
              Divider(
                indent: 25,
                endIndent: 25,
                color: Theme.of(context).colorScheme.tertiary,
              ),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  children: [
                    for (Exhibition? exhib in widget.exhibs)
                      ExhibitionSlot(exhib),
                  ],
                ),
              ),
            ],
          ),
      ),
    );
  }

  Container ExhibitionSlot(Exhibition? exhib) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: const BorderRadius.all(Radius.circular(2)),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.15),
            spreadRadius: 5,
            blurRadius: 7,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              width: 180,
              child: Align(
                alignment: Alignment.center,
                child: Text("${exhib?.title}",
                  style: GoogleFonts.openSans(fontSize: 10, fontWeight: FontWeight.w600),
                ),
              )
          ),
          const SizedBox(height: 5),
          IconButton(
            icon: SizedBox(
              child: CachedNetworkImage(
                imageUrl: "https://www.artic.edu/iiif/2/${exhib?.primaryImgID}/full/843,/0/default.jpg",
                errorWidget: (context, url, error) => const Icon(Icons.hourglass_top),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context, MaterialPageRoute(builder: (context) => ExhibitionPage(exhib: exhib))
              );
            },
          ),
        ],
      ),
    );
  }
}