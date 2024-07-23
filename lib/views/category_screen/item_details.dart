import 'package:flutter_store_v2/consts/consts.dart';
import 'package:flutter_store_v2/consts/lists.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_store_v2/controllers/product_controller.dart';
import 'package:flutter_store_v2/views/chat_screen/chat_screen.dart';
import 'package:flutter_store_v2/widgets_common/our_button.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ItemDetails extends StatelessWidget {
  final String? title;
  final dynamic data;
  const ItemDetails({Key? key, required this.title, this.data})
      : super(key: key);

  Future<String> _getDownloadUrl(String gsUrl) async {
    final ref = FirebaseStorage.instance.refFromURL(gsUrl);
    return await ref.getDownloadURL();
  }

  String formatPrice(int price) {
    final formatter = NumberFormat('#,##0', 'vi_VN');
    return formatter.format(price);
  }

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProductController());

    return WillPopScope(
      onWillPop: () async {
        controller.resetValues();
        return true;
      },
      child: Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              controller.resetValues();
              Get.back();
            },
            icon: const Icon(Icons.arrow_back),
          ),
          title: title!.text.color(darkFontGrey).fontFamily(bold).make(),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.share,
                color: darkFontGrey,
              ),
            ),
            Obx(
              () => IconButton(
                onPressed: () {
                  if (controller.isFav.value) {
                    controller.removeFromWishlist(data.id, context);
                  } else {
                    controller.addToWishlist(data.id, context);
                  }
                },
                icon: Icon(
                  Icons.favorite_outlined,
                  color: controller.isFav.value ? pinkColor : darkFontGrey,
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Phần hình ảnh trượt
                    VxSwiper.builder(
                      autoPlay: false,
                      height: 350,
                      itemCount: data['p_imgs'].length,
                      aspectRatio: 16 / 9,
                      viewportFraction: 1.0,
                      itemBuilder: (context, index) {
                        return FutureBuilder(
                          future: _getDownloadUrl(data['p_imgs'][index]),
                          builder: (context, AsyncSnapshot<String> imageUrl) {
                            if (!imageUrl.hasData) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              return Image.network(
                                imageUrl.data!,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              );
                            }
                          },
                        );
                      },
                    ),

                    10.heightBox,
                    // Phần tiêu đề và chi tiết
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: title!.text
                          .size(16)
                          .color(darkFontGrey)
                          .fontFamily(semibold)
                          .make(),
                    ),
                    10.heightBox,
                    // Đánh giá
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: VxRating(
                        isSelectable: false,
                        value: double.parse(data['p_rating']),
                        onRatingUpdate: (Value) {},
                        normalColor: textfieldGrey,
                        selectionColor: golden,
                        count: 5,
                        size: 25,
                        maxRating: 5,
                      ),
                    ),
                    10.heightBox,
                    // Giá
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: "${formatPrice(int.parse(data['p_price']))} đ"
                          .text
                          .color(pinkColor)
                          .fontFamily(bold)
                          .size(18)
                          .make(),
                    ),
                    10.heightBox,
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              "Người Bán"
                                  .text
                                  .white
                                  .fontFamily(semibold)
                                  .make(),
                              5.heightBox,
                              "${data['p_seller']}"
                                  .text
                                  .fontFamily(semibold)
                                  .color(darkFontGrey)
                                  .size(16)
                                  .make()
                            ],
                          ),
                        ),
                        const CircleAvatar(
                          backgroundColor: Colors.white,
                          child:
                              Icon(Icons.message_rounded, color: darkFontGrey),
                        ).onTap(() {
                          Get.to(
                            () => const ChatScreen(),
                            arguments: [data['p_seller'], data['vendor_id']],
                          );
                        })
                      ],
                    )
                        .box
                        .height(60)
                        .padding(const EdgeInsets.symmetric(horizontal: 10))
                        .color(textfieldGrey)
                        .make(),

                    // Phần màu sắc
                    20.heightBox,
                    Obx(
                      () => Column(
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 100,
                                child: "Màu sắc: "
                                    .text
                                    .color(textfieldGrey)
                                    .make(),
                              ),
                              Row(
                                children: List.generate(
                                  data['p_colors'].length,
                                  (index) => Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      VxBox()
                                          .size(40, 40)
                                          .roundedFull
                                          .color(Color(data['p_colors'][index])
                                              .withOpacity(1.0))
                                          .margin(const EdgeInsets.symmetric(
                                              horizontal: 6))
                                          .make()
                                          .onTap(() {
                                        controller.changeColorIndex(index);
                                      }),
                                      Visibility(
                                        visible: index ==
                                            controller.colorIndex.value,
                                        child: const Icon(Icons.done,
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ).box.padding(const EdgeInsets.all(8)).make(),

                          // Phần số lượng
                          Row(
                            children: [
                              SizedBox(
                                width: 100,
                                child: "Số lượng: "
                                    .text
                                    .color(textfieldGrey)
                                    .make(),
                              ),
                              Obx(
                                () => Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        controller.decreaseQuantity();
                                        controller.calculateTotalPrice(
                                            int.parse(data['p_price']));
                                      },
                                      icon: const Icon(Icons.remove),
                                    ),
                                    controller.quantity.value.text
                                        .size(16)
                                        .color(darkFontGrey)
                                        .fontFamily(bold)
                                        .make(),
                                    IconButton(
                                      onPressed: () {
                                        controller.increaseQuantity(
                                            int.parse(data['p_quantity']));
                                        controller.calculateTotalPrice(
                                            int.parse(data['p_price']));
                                      },
                                      icon: const Icon(Icons.add),
                                    ),
                                    "(${data['p_quantity']} có sẵn)"
                                        .text
                                        .color(textfieldGrey)
                                        .make(),
                                  ],
                                ),
                              ),
                            ],
                          ).box.padding(const EdgeInsets.all(8)).make(),

                          // Phần tổng giá
                          Row(
                            children: [
                              SizedBox(
                                width: 100,
                                child: "Giá: ".text.color(textfieldGrey).make(),
                              ),
                              "${formatPrice(controller.totalPrice.value)} đ"
                                  .text
                                  .color(pinkColor)
                                  .size(16)
                                  .fontFamily(bold)
                                  .make(),
                            ],
                          ).box.padding(const EdgeInsets.all(8)).make(),
                        ],
                      ).box.white.shadowSm.make(),
                    ),

                    // Phần mô tả
                    10.heightBox,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: "Mô tả"
                          .text
                          .color(darkFontGrey)
                          .fontFamily(semibold)
                          .make(),
                    ),
                    10.heightBox,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child:
                          "${data['p_desc']}".text.color(darkFontGrey).make(),
                    ),

                    // Phần các nút bấm
                    10.heightBox,
                    ListView(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children: List.generate(
                        itemDetailButtonsList.length,
                        (index) => ListTile(
                          title: itemDetailButtonsList[index]
                              .text
                              .fontFamily(semibold)
                              .color(darkFontGrey)
                              .make(),
                          trailing: const Icon(Icons.arrow_forward),
                        ),
                      ),
                    ),

                    // Phần sản phẩm có thể thích
                    20.heightBox,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: productsyoumaylike.text
                          .fontFamily(bold)
                          .size(16)
                          .color(darkFontGrey)
                          .make(),
                    ),
                    10.heightBox,
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(
                          6,
                          (index) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(
                                imgP1,
                                width: 150,
                                fit: BoxFit.cover,
                              ),
                              10.heightBox,
                              "Laptop 16GB/1TB"
                                  .text
                                  .fontFamily(semibold)
                                  .color(darkFontGrey)
                                  .make(),
                              10.heightBox,
                              "24.000.000 VND"
                                  .text
                                  .color(pinkColor)
                                  .fontFamily(bold)
                                  .size(16)
                                  .make(),
                            ],
                          )
                              .box
                              .white
                              .margin(const EdgeInsets.symmetric(horizontal: 4))
                              .roundedSM
                              .padding(const EdgeInsets.all(8))
                              .make(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              margin: const EdgeInsets.only(
                  bottom: 10.0), // Điều chỉnh khoảng cách dưới đây
              child: SizedBox(
                width: 410,
                height: 60,
                child: ourButton(
                  color: pinkColor,
                  onPress: () {
                    if (controller.quantity.value > 0) {
                      controller.addToCart(
                          color: data['p_colors'][controller.colorIndex.value],
                          context: context,
                          vendorID: data['vendor_id'],
                          img: data['p_imgs'][0],
                          qty: controller.quantity.value,
                          sellername: data['p_seller'],
                          title: data['p_name'],
                          tprice: controller.totalPrice.value);
                      VxToast.show(context, msg: "Đã thêm vào giỏ hàng");
                    } else {
                      VxToast.show(context, msg: "Số lượng không thể là 0");
                    }
                  },
                  textColor: whiteColor,
                  title: "Thêm vào giỏ hàng",
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
