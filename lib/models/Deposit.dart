class Deposit {
  var id;
  List<LinksURL> links;

  Deposit({this.id, this.links});

  factory Deposit.fromJson(dynamic json) {
    var id = json['id'] as String ?? "";
    var tagObjJson = json['links'] as List ?? [];
    List<LinksURL> datas =
        tagObjJson.map((tagJson) => LinksURL.fromJson(tagJson)).toList();
    return new Deposit(
      id: id,
      links: datas,
    );
  }
}

class LinksURL {
  var href;
  var rel;
  var method;

  LinksURL({this.href, this.rel, this.method});

  factory LinksURL.fromJson(dynamic json) {
    return LinksURL(
      href: json['href'] as String ?? "",
      rel: json['rel'] ?? "",
      method: json['method'] as String ?? "",
    );
  }
}
