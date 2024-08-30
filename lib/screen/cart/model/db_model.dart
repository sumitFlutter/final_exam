class DBModel{
  String? name,dec,image;
  String? price;
  int? id;

  DBModel({this.id,required this.name,required this.dec,required this.image,required this.price});
  factory DBModel.mapToModel(Map m1)
  {
    return DBModel(id: m1["id"], name: m1["name"], dec: m1["dec"], image: m1["image"], price: m1["price"]);
  }
}