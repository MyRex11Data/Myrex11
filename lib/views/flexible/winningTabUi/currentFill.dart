import 'package:flutter/material.dart';
import 'package:myrex11/util/customWidgets/customText.dart';

import '../../../appUtilities/app_images.dart';

class CurrentFillTab extends StatelessWidget {
  List<dynamic>? listData;
  String? type;
  CurrentFillTab(this.listData, {Key? key, this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return listData == null || listData!.isEmpty
        ? CustomText(
            title: 'No data Found',
          )
        : ListView.builder(
            itemCount: listData!.length,
            shrinkWrap: true,
            // physics: NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                            title: type == "CurrentFill"
                                ? "${listData![index].start_position}"
                                : "${listData![index].start_position}"),
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 6),
                              child: Container(
                                height: 14,
                                width: 14,
                                child: Image.asset(AppImages.goldcoin),
                              ),
                            ),
                            CustomText(
                              title: "${listData![index].price}",
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Divider()
                ],
              );
            });
  }
}
