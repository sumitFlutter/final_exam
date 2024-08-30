class FireStoreModel{
  String? id,name,dec,image;
  double? price;

  FireStoreModel({this.id,required this.name,required this.dec,required this.image,required this.price});
  factory FireStoreModel.mapToModel(Map m1,String dId)
  {
    return FireStoreModel(id: dId, name: m1["name"], dec: m1["dec"], image: m1["image"], price: m1["price"]);
  }
}