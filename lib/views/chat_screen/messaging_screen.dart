import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_store_v2/consts/consts.dart';
import 'package:flutter_store_v2/services/firestore_services.dart';
import 'package:flutter_store_v2/widgets_common/loading_indicator.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: "Tin nhắn".text.make(),
      ),
      body: StreamBuilder(
        stream: FirestoreServices.getAllMessages(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: loadingIndicator(),
            );
          } else if (snapshot.data!.docs.isEmpty) {
            return "Hổng có tin nhắn nào hết lun!!"
                .text
                .color(darkFontGrey)
                .makeCentered();
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
