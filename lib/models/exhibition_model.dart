class Exhibition {
  final String? title;
  final String? primaryImgID;
  final List<dynamic>? altImageIDs;
  final String? startDate;
  final String? endDate;

  Exhibition({
    required this.title,
    required this.primaryImgID,
    required this.altImageIDs,
    required this.startDate,
    required this.endDate,
  });

  factory Exhibition.fromJson(Map<String, dynamic> json, exhibIndex) {
    return Exhibition(
      title: json['data'][exhibIndex]['title'],
      primaryImgID: json['data'][exhibIndex]['image_id'],
      altImageIDs: json['data'][exhibIndex]['alt_image_ids'],
      startDate: json['data'][exhibIndex]['aic_start_at'],
      endDate: json['data'][exhibIndex]['aic_end_at'],
    );
  }
}