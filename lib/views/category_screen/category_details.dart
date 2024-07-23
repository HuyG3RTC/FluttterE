import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_store_v2/controllers/product_controller.dart';
import 'package:flutter_store_v2/services/firestore_services.dart';
import 'package:flutter_store_v2/views/category_screen/item_details.dart';
import 'package:flutter_store_v2/widgets_common/bg_widget.dart';
import 'package:flutter_store_v2/consts/consts.dart';
import 'package:flutter_store_v2/widgets_common/loading_indicator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Import NumberFormat
// Đảm bảo đã nhập thư viện này cho phương thức heightBox và box

class CategoryDetails extends StatefulWidget {
  final String? title;
  const CategoryDetails({Key? key, required this.title}) : super(key: key);

  @override
  State<CategoryDetails> createState() => _CategoryDetailsState();
}

class _CategoryDetailsState extends State<CategoryDetails> {
  Future<String> _getDownloadUrl(String gsUrl) async {
    final ref = FirebaseStorage.instance.refFromURL(gsUrl);
    return await ref.getDownloadURL();
  }

  int parsePrice(dynamic value) {
    if (value is int) {
      return value;
    } else if (value is String) {
      return int.tryParse(value) ?? 0;
    } else {
      return 0; // nếu sử dụng đổi vnd mà có parse thì thêm này vô
    }
  }

  String formatPrice(int price) {
    final formatter = NumberFormat('#,##0', 'vi_VN');
    return formatter.format(price);
  }

  @override
  void initState() {
    super.initState();
    switchCategory(widget.title);
  }

  switchCategory(title) {
    if (controller.subcat.contains(title)) {
      productMethod = FirestoreServices.getSubCategoryProducts(title);
    } else {
      productMethod = FirestoreServices.getProducts(title);
    }
  }

  var controller = Get.find<ProductController>();
  dynamic productMethod;

  @override
  Widget build(BuildContext context) {
    return bgWidget(
      child: Scaffold(
        backgroundColor: lightGrey, // Đặt màu nền thành lightGrey
        appBar: AppBar(
          title: widget.title!.text
              .fontFamily(bold)
              .color(Colors.black)
              .make(), // Đặt màu chữ thành màu đen
          backgroundColor: Colors
              .white, // Đặt màu nền của AppBar thành trắng để màu chữ đen dễ đọc
          iconTheme: const IconThemeData(
            color: Colors.black, // Đặt màu của nút quay lại là màu đen
          ),
        ),
        body: Column(
          children: [
            10.heightBox,
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  controller.subcat.length,
                  (index) => "${controller.subcat[index]}"
                      .text
                      .size(14)
                      .fontFamily(bold)
                      .color(darkFontGrey)
                      .makeCentered()
                      .box
                      .white
                      .rounded
                      .size(150, 60)
                      .margin(const EdgeInsets.symmetric(horizontal: 4))
                      .make()
                      .onTap(() {
                    switchCategory("${controller.subcat[index]}");
                    setState(() {});
                  }),
                ),
              ),
            ),
            20.heightBox,
            StreamBuilder(
              stream: productMethod,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: loadingIndicator(),
                  );
                } else if (snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: "Không tìm thấy sản phẩm"
                        .text
                        .color(darkFontGrey)
                        .make(),
                  );
                } else {
                  var data = snapshot.data!.docs;

                  return Expanded(
                    // Đảm bảo sử dụng Expanded để GridView có kích thước hợp lý
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.builder(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: data.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisExtent: 280,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                        ),
                        itemBuilder: (context, index) {
                          return FutureBuilder(
                            future: _getDownloadUrl(data[index]['p_imgs'][0]),
                            builder: (context, AsyncSnapshot<String> imageUrl) {
                              if (!imageUrl.hasData) {
                                return Center(
                                  child: loadingIndicator(),
                                );
                              } else {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.network(
                                      imageUrl.data!,
                                      height: 160,
                                      width: 200,
                                      fit: BoxFit.cover,
                                    ).box.rounded.clip(Clip.antiAlias).make(),
                                    10.heightBox,
                                    "${data[index]['p_name']}"
                                        .text
                                        .fontFamily(semibold)
                                        .color(darkFontGrey)
                                        .make(),
                                    10.heightBox,
                                    "${formatPrice(parsePrice(data[index]['p_price']))} đ"
                                        .text
                                        .color(pinkColor)
                                        .fontFamily(bold)
                                        .size(16)
                                        .make(),
                                  ],
                                )
                                    .box
                                    .white
                                    .margin(const EdgeInsets.symmetric(
                                        horizontal: 4))
                                    .roundedSM
                                    .outerShadowSm
                                    .padding(const EdgeInsets.all(12))
                                    .make()
                                    .onTap(() {
                                  controller.checkIfFav(data[index]);
                                  Get.to(
                                    () => ItemDetails(
                                      title: "${data[index]['p_name']}",
                                      data: data[index],
                                    ),
                                  );
                                });
                              }
                            },
                          );
                        },
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
