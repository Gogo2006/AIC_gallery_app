class ImageDesc {
  final String? title;
  final String? date;
  final String? artistDesc;
  final String? artDesc;
  final String? imgID;

  ImageDesc ({
    required this.title,
    required this.date,
    required this.artistDesc,
    required this.artDesc,
    required this.imgID,
  });

  // Factory method that translates a JSON file into appropriate member variables and returns an ImageDesc with said variables
  factory ImageDesc.fromJson(Map<String, dynamic> json, imgIndex) {
    return ImageDesc(
        title: json['data'][imgIndex]['title'],
        date: json['data'][imgIndex]['date_display'],
        artistDesc: json['data'][imgIndex]['artist_display'],
        artDesc: json['data'][imgIndex]['description'],
        imgID: json['data'][imgIndex]['image_id'],
    );
  }
}
