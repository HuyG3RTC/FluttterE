import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_store_v2/consts/consts.dart';
import 'package:flutter_store_v2/services/firestore_services.dart';
import 'package:flutter_store_v2/widgets_common/loading_indicator.dart';
import 'package:intl/intl.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({Key? key}) : super(key: key);

  Future<String> getImageUrl(String imagePath) async {
    final ref = FirebaseStorage.instance.refFromURL(imagePath);
    String url = await ref.getDownloadURL();
    return url;
  }

  String formatPrice(int price) {
    final formatter = NumberFormat('#,##0', 'vi_VN');
    return formatter.format(price) + ' đ';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: const Text("Danh sách yêu thích"),
      ),
      body: StreamBuilder(
        stream: FirestoreServices.getWishlists(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: loadingIndicator(),
            );
          } else if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("Danh sách yêu thích trống",
                  style: TextStyle(color: darkFontGrey)),
            );
          } else {
            var data = snapshot.data!.docs;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                var item = data[index];
                int price = item['p_price'] is int
                    ? item['p_price']
                    : int.tryParse(item['p_price']) ?? 0;
                return FutureBuilder(
                  future: getImageUrl(item['p_imgs'][0]),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: loadingIndicator());
                    } else {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ListTile(
                          leading: SizedBox(
                            width: 60,
                            height: 60,
                            child: Image.network(
                              snapshot.data!,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(
                            "${item['p_name']}",
                            style: const TextStyle(
                                fontFamily: semibold, fontSize: 16),
                          ),
                          subtitle: Text(
                            formatPrice(price),
                            style: const TextStyle(
                                color: pinkColor, fontFamily: semibold),
                          ),
                          trailing: const Icon(Icons.favorite, color: pinkColor)
                              .onTap(() async {
                            await firestore
                                .collection(productCollection)
                                .doc(data[index].id)
                                .set({
                              'p_wishlist':
                                  FieldValue.arrayRemove([currentUser!.uid])
                            }, SetOptions(merge: true));
                          }),
                        ),
                      );
                    }
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
