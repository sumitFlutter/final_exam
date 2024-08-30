import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopping_exam/screen/home/model/firestore_model.dart';

class CloudFirestoreHelper{
  static CloudFirestoreHelper fireDBHelper= CloudFirestoreHelper._();
  CloudFirestoreHelper._();
  var db=FirebaseFirestore.instance;
  Future<void> addData(FireStoreModel model)
  async {
    await db.collection("shopping").add({"name":model.name,"price":model.price,"dec":model.dec,"image":model.image});
  }
  Future<List<FireStoreModel>> readData()
  async {
    QuerySnapshot qds=await db.collection("shopping").get();
    List<QueryDocumentSnapshot<Object?>> qd=qds.docs;
    List<FireStoreModel> model=qd.map((e) => FireStoreModel.mapToModel(e.data()! as Map,e.id),).toList();
    return model;
  }
  Future<void> updateData(FireStoreModel model)
  async {
    await db.collection("shopping").doc(model.id).set({"name":model.name,"price":model.price,"dec":model.dec,"image":model.image});
  }
  Future<void> deleteData(String dId)
  async {
    await db.collection("shopping").doc(dId).delete();
  }
}