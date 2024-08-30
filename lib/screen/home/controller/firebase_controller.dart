import 'package:get/get.dart';
import 'package:shopping_exam/screen/home/model/firestore_model.dart';
import 'package:shopping_exam/utils/helpers/cloud_firestore_helper.dart';

class FireBaseController extends GetxController{
 RxDouble sliderP=0.0.obs;
 RxList<FireStoreModel> productList=<FireStoreModel>[].obs;
 Future<void> getData()
 async {
  productList.value=await CloudFirestoreHelper.fireDBHelper.readData();
 }
}