import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_exam/screen/cart/controller/db_controller.dart';
import 'package:shopping_exam/screen/cart/model/db_model.dart';
import 'package:shopping_exam/utils/helpers/db_helper.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  DBController dbController = Get.put(DBController());
  TextEditingController nameTxt = TextEditingController();
  TextEditingController decTxt = TextEditingController();
  TextEditingController imageTxt = TextEditingController();
  GlobalKey<FormState> key = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbController.getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Cart"),
      ),
      body: Obx(
        () => ListView.builder(
          padding: const EdgeInsets.all(12),
          itemBuilder: (context, index) {
            return ListTile(
              leading: CachedNetworkImage(
                imageUrl: dbController.dBList.value[index].image!,
                height: 50,
                width: 50,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Icon(Icons.shopping_cart),
                errorWidget: (context, url, error) =>
                    const Icon(Icons.shopping_cart),
              ),
              subtitle: Text(
                  "\$ ${dbController.dBList.value[index].price!}\n${dbController.dBList.value[index].dec!}"),
              title: Text(dbController.dBList.value[index].name!),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                      onPressed: () {
                        addOrEdit(dbController.dBList[index]);
                      },
                      icon: const Icon(Icons.edit)),
                  IconButton(
                      onPressed: () {
                        Get.defaultDialog(
                            title: "Are You Sure ?",
                            content: Text(
                                "Are You Sure To Delete ${dbController.dBList[index].name} ?"),
                            actions: [
                              ElevatedButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: const Text("No!")),
                              const SizedBox(
                                width: 2,
                              ),
                              ElevatedButton(
                                  onPressed: () async {
                                    await DBHelper.helper
                                        .delete(dbController.dBList[index].id!);
                                    Get.snackbar("SuccessFully deleted", "😊");
                                    await dbController.getData();
                                    Get.back();
                                  },
                                  child: const Text("Yes")),
                            ]);
                      },
                      icon: const Icon(Icons.delete)),
                  const SizedBox(
                    width: 2,
                  ),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.favorite))
                ],
              ),
            );
          },
          itemCount: dbController.dBList.length,
        ),
      ),
    );
  }

  void addOrEdit(DBModel? model1) {
    int dId = 0;
    if (model1 == null) {
      nameTxt.clear();
      decTxt.clear();
      imageTxt.clear();
      dbController.sliderP.value = 0.0;
    } else {
      nameTxt.text = model1.name!;
      decTxt.text = model1.dec!;
      imageTxt.text = model1.image!;
      dbController.sliderP.value = double.parse(model1.price!);
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
                value: dbController.sliderP.value,
                onChanged: (value) {
                  dbController.sliderP.value = value;
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
              () => Center(child: Text(dbController.sliderP.value.toString())),
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
                  DBModel model = DBModel(
                      price: dbController.sliderP.value.toString(),
                      name: nameTxt.text,
                      dec: decTxt.text,
                      image: imageTxt.text);
                  await DBHelper.helper.update(model);
                  await dbController.getData();
                  Get.back();
                  nameTxt.clear();
                  decTxt.clear();
                  imageTxt.clear();
                  dbController.sliderP.value = 0.0;
                  Get.snackbar("SuccessFully Added", "😊");
                } else {
                  DBModel model = DBModel(
                      price: dbController.sliderP.value.toString(),
                      name: nameTxt.text,
                      dec: decTxt.text,
                      image: imageTxt.text,
                      id: dId);
                  await DBHelper.helper.update(model);
                  await dbController.getData();
                  Get.back();
                  nameTxt.clear();
                  decTxt.clear();
                  imageTxt.clear();
                  dbController.sliderP.value = 0.0;
                  Get.snackbar("SuccessFully updated", "😊");
                }
              }
            },
            child: const Text("Add")),
      ],
    );
  }
}
