import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_exam/screen/cart/controller/db_controller.dart';
import 'package:shopping_exam/screen/cart/model/db_model.dart';
import 'package:shopping_exam/screen/home/controller/firebase_controller.dart';
import 'package:shopping_exam/screen/home/model/firestore_model.dart';
import 'package:shopping_exam/utils/helpers/cloud_firestore_helper.dart';
import 'package:shopping_exam/utils/helpers/db_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController nameTxt = TextEditingController();
  TextEditingController decTxt = TextEditingController();
  TextEditingController imageTxt = TextEditingController();
  FireBaseController fireBaseController = Get.put(FireBaseController());
  DBController dbController = Get.put(DBController());
  GlobalKey<FormState> key = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fireBaseController.getData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text("Shopping App"),
        actions: [
          IconButton(
              onPressed: () {
                Get.toNamed("cart");
              },
              icon: Icon(Icons.shopping_cart))
        ],
      ),
      body: Obx(
        () => ListView.builder(
          padding: EdgeInsets.all(12),
          itemBuilder: (context, index) {
            return ListTile(
              leading: CachedNetworkImage(
                imageUrl: fireBaseController.productList.value[index].image!,
                height: 50,
                width: 50,
                fit: BoxFit.cover,
                placeholder: (context, url) => Icon(Icons.shopping_cart),
                errorWidget: (context, url, error) => Icon(Icons.shopping_cart),
              ),
              title: Text(fireBaseController.productList.value[index].name!),
              subtitle: Text(
                  "\$ ${fireBaseController.productList.value[index].price!}\n${fireBaseController.productList.value[index].dec!}"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                      onPressed: () {
                        addOrEdit(fireBaseController.productList[index]);
                      },
                      icon: Icon(Icons.edit)),
                  IconButton(
                      onPressed: () {
                        Get.defaultDialog(
                            title: "Are You Sure ?",
                            content: Text(
                                "Are You Sure To Delete ${fireBaseController.productList[index].name} ?"),
                            actions: [
                              ElevatedButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: Text("No!")),
                              SizedBox(
                                width: 2,
                              ),
                              ElevatedButton(
                                  onPressed: () async {
                                    await CloudFirestoreHelper.fireDBHelper
                                        .deleteData(fireBaseController
                                            .productList[index].id!);
                                    Get.back();
                                    await fireBaseController.getData();
                                    Get.snackbar("SuccessFully deleted", "😊");
                                  },
                                  child: Text("Yes")),
                            ]);
                      },
                      icon: Icon(Icons.delete)),
                  SizedBox(
                    width: 2,
                  ),
                  IconButton(
                      onPressed: () async {
                        DBModel model = DBModel(
                            name: fireBaseController.productList[index].name!,
                            dec: fireBaseController.productList[index].dec!,
                            image: fireBaseController.productList[index].image!,
                            price: fireBaseController.productList[index].price!
                                .toString());
                        await DBHelper.helper.insertQuery(model);
                        await dbController.getData();
                        Get.snackbar("SuccessFully Added", "😊");
                      },
                      icon: Icon(Icons.favorite))
                ],
              ),
            );
          },
          itemCount: fireBaseController.productList.length,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addOrEdit(null);
        },
        child: const Icon(Icons.add),
      ),
    ));
  }

  void addOrEdit(FireStoreModel? model1) {
    String dId = "";
    if (model1 == null) {
      nameTxt.clear();
      decTxt.clear();
      imageTxt.clear();
      fireBaseController.sliderP.value = 0.0;
    } else {
      nameTxt.text = model1.name!;
      decTxt.text = model1.dec!;
      imageTxt.text = model1.image!;
      fireBaseController.sliderP.value = model1.price!;
      dId = model1.id!;
    }

    Get.defaultDialog(
      title: "Add Products",
      content: Form(
        key: key,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: nameTxt,
              decoration: const InputDecoration(
                label: Text("Name :"),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return "Product Name is Required";
                }
                return null;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: decTxt,
              decoration: const InputDecoration(
                label: Text("Description :"),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return "Product Description is Required";
                }
                return null;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: imageTxt,
              decoration: const InputDecoration(
                label: Text("Image Link :"),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return "Product Image Link is Required";
                }
                return null;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            const Center(child: Text("Select Price:")),
            const SizedBox(
              height: 4,
            ),
            Obx(
              () => Slider(
                value: fireBaseController.sliderP.value,
                onChanged: (value) {
                  fireBaseController.sliderP.value = value;
                },
                max: 1000,
                min: 0,
                divisions: 10,
              ),
            ),
            const SizedBox(
              height: 2,
            ),
            Obx(
              () => Center(
                  child: Text(fireBaseController.sliderP.value.toString())),
            )
          ],
        ),
      ),
      actions: [
        ElevatedButton(
            onPressed: () {
              Get.back();
            },
            child: const Text("Cancel")),
        ElevatedButton(
            onPressed: () async {
              if (key.currentState!.validate()) {
                if (model1 == null) {
                  FireStoreModel model = FireStoreModel(
                      price: fireBaseController.sliderP.value,
                      name: nameTxt.text,
                      dec: decTxt.text,
                      image: imageTxt.text);
                  await CloudFirestoreHelper.fireDBHelper.addData(model);
                  Get.back();
                  await fireBaseController.getData();
                  nameTxt.clear();
                  decTxt.clear();
                  imageTxt.clear();
                  fireBaseController.sliderP.value = 0.0;
                  Get.snackbar("SuccessFully Added", "😊");
                } else {
                  FireStoreModel model = FireStoreModel(
                      price: fireBaseController.sliderP.value,
                      name: nameTxt.text,
                      dec: decTxt.text,
                      image: imageTxt.text,
                      id: dId);
                  await CloudFirestoreHelper.fireDBHelper.updateData(model);
                  Get.back();
                  await fireBaseController.getData();
                  nameTxt.clear();
                  decTxt.clear();
                  imageTxt.clear();
                  fireBaseController.sliderP.value = 0.0;
                  Get.snackbar("SuccessFully updated", "😊");
                }
              }
            },
            child: const Text("Add")),
      ],
    );
  }
}
