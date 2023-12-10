class RelatedSearchTerm {
  List<List<dynamic>> liberal;
  List<List<dynamic>> conservative;

  RelatedSearchTerm({required this.liberal, required this.conservative});

  factory RelatedSearchTerm.fromJson(Map<String, dynamic> json) {
    return RelatedSearchTerm(
      liberal: List.generate(
          json['liberal'].length, (index) => json['liberal'][index]),
      conservative: List.generate(
          json['conservative'].length, (index) => json['conservative'][index]),
    );
  }
}
