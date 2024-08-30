import 'package:get/get.dart';
import 'package:shopping_exam/screen/cart/model/db_model.dart';
import 'package:shopping_exam/utils/helpers/db_helper.dart';

class DBController extends GetxController{
  RxList<DBModel> dBList=<DBModel>[].obs;
  RxDouble sliderP=0.0.obs;
  Future<void> getData()
  async {
    dBList.value=(await DBHelper.helper.read());
  }
}