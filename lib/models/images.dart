class Imagesmodel {
  final String url;

  Imagesmodel({
    required this.url,
  });

  factory Imagesmodel.fromJson(Map<String, dynamic> json) => Imagesmodel(
        url: json['url'],
      );
}
