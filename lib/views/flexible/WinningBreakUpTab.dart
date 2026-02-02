import 'package:myrex11/appUtilities/app_images.dart';
import 'package:flutter/material.dart';
import 'package:myrex11/appUtilities/app_colors.dart';
import 'package:myrex11/appUtilities/app_constants.dart';
import 'package:myrex11/util/customWidgets/customText.dart';
import 'package:myrex11/views/flexible/flexibleControler.dart';
import 'package:myrex11/views/flexible/winningTabUi/currentFill.dart';
import 'package:get/get.dart';

class Winning extends StatelessWidget {
  FlexibleController newController;
  Winning(this.newController, {Key? key}) : super(key: key);
  FlexibleController _flexibleController = Get.find<FlexibleController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8, left: 15, right: 15),
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 10,
          ),
          winningTab(),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  border: Border.all(color: borderColor, width: 0.7),
                  // image: DecorationImage(
                  //     image: AssetImage(AppImages.commanBackground),
                  //     fit: BoxFit.cover),
                  color: Colors.transparent),
              child: Column(
                children: [
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                      color: borderColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                              title: "RANK",

                              //fontFamily: "Roboto",
                              color: Color(0xff717072),
                              fontWeight: FontWeight.w600,
                              fontSize: 12),
                          CustomText(
                              title: "PRIZE",
                              color: Color(0xff717072),
                              fontWeight: FontWeight.w600,
                              fontSize: 12),
                        ],
                      ),
                    ),
                  ),
                  Divider(height: 1),
                  SizedBox(height: 5),
                  // This will take remaining space
                  Expanded(
                    child: _flexibleController.clickIndex.value == 0
                        ? CurrentFillTab(
                            _flexibleController.dataModel.value.MaxFill,
                            type: "",
                          )
                        : CurrentFillTab(
                            _flexibleController.dataModel.value.CurrentFill,
                            type: "CurrentFill",
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  winningTab() {
    return GetBuilder<FlexibleController>(
        builder: (newController) => Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  border: Border.all(color: Color(0xffE1E1E1), width: 1)),
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () {
                        newController.clickIndex.value = 0;
                        newController.getFlexibleData(AppConstants.context);
                        newController.update();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: _flexibleController.clickIndex.value == 0
                                ? primaryColor
                                : Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        alignment: Alignment.center,
                        width: 120,
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: CustomText(
                          title: "Max Fill",
                          color: _flexibleController.clickIndex.value == 0
                              ? Colors.white
                              : Color(0xff8E9193),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        newController.clickIndex.value = 1;
                        newController.getFlexibleData(AppConstants.context);
                        newController.update();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: _flexibleController.clickIndex.value == 1
                                ? primaryColor
                                : Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        alignment: Alignment.center,
                        width: 120,
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: CustomText(
                          title: "Current Fill",
                          color: _flexibleController.clickIndex.value == 1
                              ? Colors.white
                              : Color(0xff8E9193),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }
}
