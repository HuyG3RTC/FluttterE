import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_store_v2/consts/lists.dart';
import 'package:flutter_store_v2/controllers/home_controller.dart';
import 'package:flutter_store_v2/services/firestore_services.dart';
import 'package:flutter_store_v2/views/category_screen/item_details.dart';
import 'package:flutter_store_v2/views/home_screen/components/featured_button.dart';
import 'package:flutter_store_v2/views/home_screen/search_screen.dart';
import 'package:flutter_store_v2/widgets_common/home_buttons.dart';
import 'package:flutter_store_v2/consts/consts.dart';
import 'package:flutter_store_v2/widgets_common/loading_indicator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

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
    var controller = Get.find<HomeController>();
    return Container(
      padding: const EdgeInsets.all(12),
      color: lightGrey,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              height: 60,
              color: lightGrey,
              child: TextFormField(
                controller: controller.searchController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  suffixIcon: const Icon(Icons.search).onTap(() {
                    if (controller.searchController.text.isNotEmptyAndNotNull) {
                      Get.to(() => SearchScreen(
                            title: controller.searchController.text,
                          ));
                    }
                  }),
                  filled: true,
                  fillColor: whiteColor,
                  hintText: searchanything,
                  hintStyle: const TextStyle(color: textfieldGrey),
                ),
              ).box.outerShadow.make(),
            ),
            10.heightBox,
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    // swiper thương hiệu
                    VxSwiper.builder(
                      aspectRatio: 16 / 9,
                      autoPlay: true,
                      height: 150,
                      enlargeCenterPage: true,
                      itemCount: sliersList.length,
                      itemBuilder: (context, index) {
                        return Image.asset(sliersList[index], fit: BoxFit.fill)
                            .box
                            .rounded
                            .clip(Clip.antiAlias)
                            .margin(const EdgeInsets.symmetric(horizontal: 8))
                            .make();
                      },
                    ),
                    20.heightBox,
                    // nút giao dịch
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                        2,
                        (index) => homeButtons(
                          MainAxisAlignment.center,
                          height: context.screenHeight * 0.15,
                          width: context.screenWidth / 2.5,
                          icon: index == 0 ? icTodaysDeal : icFlashDeal,
                          title: index == 0 ? todayDeal : flashsale,
                        ),
                      ),
                    ),
                    20.heightBox,
                    // swiper thứ 2
                    VxSwiper.builder(
                      aspectRatio: 16 / 9,
                      autoPlay: false,
                      height: 150,
                      enlargeCenterPage: true,
                      itemCount: secondSlidersList.length,
                      itemBuilder: (context, index) {
                        return Image.asset(secondSlidersList[index],
                                fit: BoxFit.fill)
                            .box
                            .rounded
                            .clip(Clip.antiAlias)
                            .margin(const EdgeInsets.symmetric(horizontal: 8))
                            .make();
                      },
                    ),
                    20.heightBox,
                    // nút danh mục
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                        3,
                        (index) => homeButtons(
                          MainAxisAlignment.center,
                          height: context.screenHeight * 0.15,
                          width: context.screenWidth / 3.5,
                          icon: index == 0
                              ? icTopCategories
                              : index == 1
                                  ? icBrands
                                  : icTopSeller,
                          title: index == 0
                              ? topCategories
                              : index == 1
                                  ? brand
                                  : topSellers,
                        ),
                      ),
                    ),

                    // danh mục nổi bật
                    20.heightBox,
                    Align(
                        alignment: Alignment.centerLeft,
                        child: featuredCategories.text
                            .color(darkFontGrey)
                            .size(18)
                            .fontFamily(semibold)
                            .make()),
                    20.heightBox,
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(
                          3,
                          (index) => Column(
                            children: [
                              featuredButton(
                                  icon: featuredImages1[index],
                                  title: freaturedTitles1[index]),
                              10.heightBox,
                              featuredButton(
                                  icon: featuredImages2[index],
                                  title: freaturedTitles2[index]),
                            ],
                          ),
                        ).toList(),
                      ),
                    ),

                    // sản phẩm nổi bật
                    20.heightBox,

                    Container(
                      padding: const EdgeInsets.all(12),
                      width: double.infinity,
                      decoration: const BoxDecoration(color: pinkColor),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          featuredProduct.text.white
                              .fontFamily(bold)
                              .size(18)
                              .make(),
                          10.heightBox,
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: FutureBuilder(
                                future: FirestoreServices.getFeaturedProducts(),
                                builder: (context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (!snapshot.hasData) {
                                    return Center(
                                      child: loadingIndicator(),
                                    );
                                  } else if (snapshot.data!.docs.isEmpty) {
                                    return "Không có sản phẩm nổi bật"
                                        .text
                                        .white
                                        .makeCentered();
                                  } else {
                                    var featuredData = snapshot.data!.docs;
                                    return FutureBuilder(
                                      future: Future.wait(
                                          featuredData.map((doc) async {
                                        List<String> imgUrls =
                                            await Future.wait(
                                                (doc['p_imgs'] as List)
                                                    .map((gsUrl) async {
                                          return await _getDownloadUrl(gsUrl);
                                        }));
                                        return imgUrls;
                                      })),
                                      builder: (context,
                                          AsyncSnapshot<List<List<String>>>
                                              featuredSnapshot) {
                                        if (!featuredSnapshot.hasData) {
                                          return loadingIndicator();
                                        } else {
                                          var featuredImages =
                                              featuredSnapshot.data!;
                                          return Row(
                                            children: List.generate(
                                              featuredData.length,
                                              (index) => Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Image.network(
                                                    featuredImages[index][0],
                                                    width: 150,
                                                    height: 150,
                                                    fit: BoxFit.cover,
                                                  ),
                                                  10.heightBox,
                                                  "${featuredData[index]['p_name']}"
                                                      .text
                                                      .fontFamily(semibold)
                                                      .color(darkFontGrey)
                                                      .make(),
                                                  10.heightBox,
                                                  "${formatPrice(int.parse(featuredData[index]['p_price']))} đ"
                                                      .text
                                                      .color(pinkColor)
                                                      .fontFamily(bold)
                                                      .size(16)
                                                      .make(),
                                                ],
                                              )
                                                  .box
                                                  .white
                                                  .margin(const EdgeInsets
                                                      .symmetric(horizontal: 4))
                                                  .roundedSM
                                                  .padding(
                                                      const EdgeInsets.all(8))
                                                  .make()
                                                  .onTap(() {
                                                Get.to(() => ItemDetails(
                                                      title:
                                                          "${featuredData[index]['p_name']}",
                                                      data: featuredData[index],
                                                    ));
                                              }),
                                            ),
                                          );
                                        }
                                      },
                                    );
                                  }
                                }),
                          ),
                        ],
                      ),
                    ),

                    // swiper thứ 3
                    20.heightBox,
                    VxSwiper.builder(
                      aspectRatio: 16 / 9,
                      autoPlay: false,
                      height: 150,
                      enlargeCenterPage: true,
                      itemCount: secondSlidersList.length,
                      itemBuilder: (context, index) {
                        return Image.asset(secondSlidersList[index],
                                fit: BoxFit.fill)
                            .box
                            .rounded
                            .clip(Clip.antiAlias)
                            .margin(const EdgeInsets.symmetric(horizontal: 8))
                            .make();
                      },
                    ),
                    20.heightBox,
                    StreamBuilder(
                      stream: FirestoreServices.allproducts(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return loadingIndicator();
                        } else {
                          var allproductsdata = snapshot.data!.docs;
                          return FutureBuilder(
                            // Create a list of Future<String> for each image URL
                            future:
                                Future.wait(allproductsdata.map((doc) async {
                              return Future.wait(
                                  (doc['p_imgs'] as List).map((gsUrl) async {
                                return await _getDownloadUrl(gsUrl);
                              }));
                            })),
                            builder: (BuildContext context,
                                AsyncSnapshot<List<List<String>>>
                                    futureSnapshot) {
                              if (!futureSnapshot.hasData) {
                                return loadingIndicator();
                              } else {
                                var allProductsImagesUrls =
                                    futureSnapshot.data!;
                                return GridView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: allproductsdata.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 8,
                                    crossAxisSpacing: 8,
                                    mainAxisExtent: 300,
                                  ),
                                  itemBuilder: (context, index) {
                                    var imageUrls =
                                        allProductsImagesUrls[index];
                                    var priceString =
                                        allproductsdata[index]['p_price'];
                                    int price;

                                    // Chuyển đổi giá từ String sang int
                                    try {
                                      price = int.parse(priceString);
                                    } catch (e) {
                                      // Nếu giá không hợp lệ, sử dụng giá mặc định hoặc xử lý lỗi
                                      price = 0;
                                    }

                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Image.network(
                                          imageUrls[
                                              0], // Đảm bảo URL ở đây là HTTP/HTTPS
                                          height: 150,
                                          width: 150,
                                          fit: BoxFit.cover,
                                        ),
                                        const Spacer(),
                                        10.heightBox,
                                        "${allproductsdata[index]['p_name']}"
                                            .text
                                            .fontFamily(semibold)
                                            .color(darkFontGrey)
                                            .make(),
                                        10.heightBox,
                                        "${formatPrice(price)} đ"
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
                                        .padding(const EdgeInsets.all(12))
                                        .make()
                                        .onTap(() {
                                      Get.to(() => ItemDetails(
                                            title:
                                                "${allproductsdata[index]['p_name']}",
                                            data: allproductsdata[index],
                                          ));
                                    });
                                  },
                                );
                              }
                            },
                          );
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
