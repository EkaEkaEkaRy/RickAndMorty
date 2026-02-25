class Item {
  final int id;
  final String name;
  final String image;
  final String status;
  final String date;
  bool favorite;

  Item({
    required this.id,
    required this.name,
    required this.image,
    required this.status,
    required this.date,
    this.favorite = false,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      status: json['status'],
      date: json['created'],
    );
  }

  Item copyWith({bool? favorite}) {
    return Item(
      id: id,
      favorite: favorite ?? this.favorite,
      name: name,
      image: image,
      status: status,
      date: date,
    );
  }
}
