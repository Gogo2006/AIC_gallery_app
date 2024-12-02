import 'dart:convert';
//import 'dart:math';

import '../models/exhibition_model.dart';
import '../models/image_desc_model.dart';
import 'package:http/http.dart' as http;

import '../models/num_results_model.dart';

class GalleryService {
  final String searchReq;
  final int pageNum;

  GalleryService(this.searchReq, this.pageNum);

  // 'static' means belonging to the class itself
  //static var randomPage = Random().nextInt(10);

  // 'final' means a variable can only be assigned once: at the time of declaration;
  // it also allows the variable to be calculated at runtime, which is useful if its
  // value isn't known at compile time
  static const gallUrl = "https://api.artic.edu/api/v1/artworks/search?q=";
  static const exhibUrl = "https://api.artic.edu/api/v1/exhibitions?limit=";
  static const _exhibLimit = 40;

  int getExhibLimit() {
    return _exhibLimit;
  }

  Future<NumResults> getNumResults() async {
    final response = await http.get(Uri.parse("$gallUrl$searchReq&query[term][is_public_domain]=true&page=$pageNum&limit=1&fields=title,artist_display,date_display,description,image_id"));

    if (response.statusCode == 200) {
      return NumResults.fromJson(jsonDecode(response.body));
    }
    else {
      throw Exception("Failed to load image data");
    }
  }

  Future<ImageDesc> getImageDesc(imgIndex, limit) async {
    final response = await http.get(Uri.parse("$gallUrl$searchReq&query[term][is_public_domain]=true&page=$pageNum&limit=$limit&fields=title,artist_display,date_display,description,image_id"));

    if (response.statusCode == 200){
      return ImageDesc.fromJson(jsonDecode(response.body), imgIndex);
    }
    else{
      throw Exception("Failed to load image data");
    }
  }

  Future<Exhibition> getExhibition(exhibIndex) async {
    final response = await http.get(Uri.parse("$exhibUrl$_exhibLimit&fields=title,aic_start_at,aic_end_at,image_id,alt_image_ids"));

    if (response.statusCode == 200) {
      return Exhibition.fromJson(jsonDecode(response.body), exhibIndex);
    }
    else {
      throw Exception("Failed to load exhibition");
    }
  }
}

