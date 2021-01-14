class Pages {
  String place;
  String type;
  int count;
  String title;
  String titleAr;
  String index;
  int pages;
  int pageIndex;
  String juzIndex;

  Pages({
    this.place,
    this.type,
    this.count,
    this.title,
    this.titleAr,
    this.index,
    this.pages,
    this.pageIndex,
    this.juzIndex,
  });

  factory Pages.fromJson(Map<String, dynamic> json) {
    return new Pages(
      place: json['place'] as String,
      type: json['type'] as String,
      count: json['count'] as int,
      title: json['title'] as String,
      titleAr: json['titleAr'] as String,
      index: json['index'] as String,
      // reversed pages
      pages: 569 - int.parse(json['pages']),
      pageIndex: int.parse(json['pages']),
      juzIndex: json['juzIndex'] as String,
    );
  }
}
