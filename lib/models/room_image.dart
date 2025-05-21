class RoomImage {
  final int imgId;
  final String url;

  RoomImage({
    required this.imgId,
    required this.url,
  });

  factory RoomImage.fromJson(Map<String, dynamic> json) {
    return RoomImage(
      imgId: json['imgId'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() => {
    'imgId': imgId,
    'url': url,
  };
}
