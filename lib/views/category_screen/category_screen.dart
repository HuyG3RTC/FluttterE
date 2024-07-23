import 'package:flutter_store_v2/consts/consts.dart';
import 'package:flutter_store_v2/consts/lists.dart';
import 'package:flutter_store_v2/controllers/product_controller.dart';
import 'package:flutter_store_v2/views/category_screen/category_details.dart';
import 'package:flutter_store_v2/widgets_common/bg_widget.dart';
import 'package:get/get.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProductController());

    return bgWidget(
        child: Scaffold(
      backgroundColor: lightGrey, // Đặt màu nền thành darkFontGrey
      appBar: AppBar(
        title: categories.text.fontFamily(semibold).color(Colors.black).make(),
        iconTheme: const IconThemeData(
          color: Colors.white, // Đặt màu của nút quay lại là màu trắng
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(12),
        child: GridView.builder(
            shrinkWrap: true,
            itemCount: 9,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                mainAxisExtent: 200),
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Image.asset(
                    categoryImages[index],
                    height: 150,
                    width: 250,
                    fit: BoxFit.cover,
                  ),
                  10.heightBox,
                  categoriesList[index]
                      .text
                      .color(darkFontGrey)
                      .fontWeight(FontWeight.bold) // Đặt tên danh mục in đậm
                      .align(TextAlign.center)
                      .make(),
                ],
              )
                  .box
                  .white
                  .rounded
                  .clip(Clip.antiAlias)
                  .outerShadowSm
                  .make()
                  .onTap(() {
                controller.getSubCategories(categoriesList[index]);
                Get.to(() => CategoryDetails(title: categoriesList[index]));
              });
            }),
      ),
    ));
  }
}
