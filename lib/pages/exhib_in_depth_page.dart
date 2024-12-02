import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/exhibition_model.dart';

class ExhibitionPage extends StatefulWidget {
  final Exhibition? exhib;

  const ExhibitionPage({super.key, this.exhib});

  @override
  State<ExhibitionPage> createState() => _ExhibitionPage();
}

// displays all of the images associated with a given Exhibition
class _ExhibitionPage extends State<ExhibitionPage> {
  String getMonthName(String? date) {
    switch(date) {
      case "01":
        return "Jan";
      case "02":
        return "Feb";
      case "03":
        return "March";
      case "04":
        return "April";
      case "05":
        return "May";
      case "06":
        return "June";
      case "07":
        return "July";
      case "08":
        return "Aug";
      case "09":
        return "Sept";
      case "10":
        return "Oct";
      case "11":
        return "Nov";
      case "12":
        return "Dec";
      default:
        return "";
    }
  }

  String? getDayNum(String? date) {
    if (date?[0] == "0") {
      return date?[1];
    }

    return date;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.exhib?.title}"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Text("${widget.exhib?.title}",
                  style: GoogleFonts.ebGaramond(fontSize: 30, fontWeight: FontWeight.w500)),
            ),
            Text("${getMonthName(widget.exhib?.startDate?.substring(5, 7))} ${getDayNum(widget.exhib?.startDate?.substring(8, 10))}, "
                "${widget.exhib?.startDate?.substring(0, 4)}-${getMonthName(widget.exhib?.endDate?.substring(5, 7))} "
                "${getDayNum(widget.exhib?.endDate?.substring(8, 10))}, ${widget.exhib?.endDate?.substring(0, 4)}",
                style: GoogleFonts.ebGaramond(fontSize: 20)),
            const SizedBox(height: 25),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).colorScheme.secondary.withOpacity(0.15),
                            spreadRadius: 5,
                            blurRadius: 7,
                          )
                        ]
                    ),
                    child: SizedBox(
                        width: 160,
                        height: 160,
                        child: CachedNetworkImage(
                          imageUrl: "https://www.artic.edu/iiif/2/${widget.exhib?.primaryImgID}/full/843,/0/default.jpg",
                          errorWidget: (context, url, error) => const Icon(Icons.hourglass_top),
                        ),
                      ),
                  ),
                  for (dynamic i = 0; i < widget.exhib?.altImageIDs?.length; i++)
                    Container(
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
                      child: SizedBox(
                        width: 160,
                        height: 160,
                        child: CachedNetworkImage(
                          imageUrl: "https://www.artic.edu/iiif/2/${widget.exhib?.altImageIDs?[i]}/full/843,/0/default.jpg",
                          errorWidget: (context, url, error) => const Icon(Icons.hourglass_top),
                        ),
                      ),
                    )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}