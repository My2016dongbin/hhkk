import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/pages/common/amap_location/location_binding.dart';
import 'package:iot/pages/common/amap_location/location_view.dart';
import 'package:iot/pages/home/device/add/device_add_controller.dart';
import 'package:iot/pages/home/my/scan/scan_binding.dart';
import 'package:iot/pages/home/my/scan/scan_view.dart';
import 'package:iot/pages/home/space/space_binding.dart';
import 'package:iot/pages/home/space/space_view.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhColors.dart';
import 'package:iot/utils/HhLog.dart';

class DeviceAddPage extends StatelessWidget {
  final logic = Get.find<DeviceAddController>();

  DeviceAddPage({super.key,required String snCode}){
    logic.snCode = snCode;
    logic.snController!.text = logic.snCode;
  }

  //复写返回监听
  Future<bool> onBackPressed() {
    bool exit = true;
    return Future.value(exit);
  }

  @override
  Widget build(BuildContext context) {
    // 在这里设置状态栏字体为深色
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // 状态栏背景色
      statusBarBrightness: Brightness.dark, // 状态栏字体亮度
      statusBarIconBrightness: Brightness.dark, // 状态栏图标亮度
    ));
    return WillPopScope(
      onWillPop: onBackPressed,
      child: Scaffold(
        backgroundColor: HhColors.backColor,
        body: Obx(
          () => SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              height: 1.sh,
              width: 1.sw,
              color: HhColors.backColorF5,
              padding: EdgeInsets.zero,
              child: Stack(
                children: [
                  ///title
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      margin: EdgeInsets.only(top: 54.w*3),
                      color: HhColors.trans,
                      child: Text(
                        logic.isEdit.value?"修改设备":"添加设备",
                        style: TextStyle(
                            color: HhColors.blackTextColor,
                            fontSize: 18.sp*3,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      margin: EdgeInsets.fromLTRB(23.w*3, 59.h*3, 0, 0),
                      padding: EdgeInsets.fromLTRB(0, 10.w, 20.w, 10.w),
                      color: HhColors.trans,
                      child: Image.asset(
                        "assets/images/common/back.png",
                        height: 17.w*3,
                        width: 10.w*3,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  logic.isEdit.value?const SizedBox():Align(
                    alignment: Alignment.topRight,
                    child:
                    BouncingWidget(
                      duration: const Duration(milliseconds: 100),
                      scaleFactor: 1.2,
                      onPressed: () async {
                        /*String? barcodeScanRes = await scanner.scan();
                        if(barcodeScanRes!.isNotEmpty){
                          logic.testStatus.value = false;
                          logic.testStatus.value = true;
                          logic.snController!.text = barcodeScanRes;
                        }*/
                        Get.to(() => ScanPage(), binding: ScanBinding());
                      },
                      child: Container(
                        margin: EdgeInsets.fromLTRB(0, 59.h*3, 23.w*3, 0),
                        color: HhColors.trans,
                        child: Image.asset(
                          "assets/images/common/icon_scanner.png",
                          width: 24.w*3,
                          height: 24.w*3,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  ///SN码
                  Container(
                    margin: EdgeInsets.fromLTRB(20.w*3, 114.w*3, 0, 0),
                    child: Row(
                      children: [
                        /*Container(
                          margin: EdgeInsets.only(top: 4.w),
                          child: Text(
                            "*",
                            style: TextStyle(
                              color: HhColors.titleColorRed,
                              fontSize: 28.sp,),
                          ),
                        ),*/
                        Text(
                          "设备SN码",
                          style: TextStyle(
                            color: HhColors.blackTextColor,
                            fontSize: 15.sp*3,),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 50.w*3,
                    margin: EdgeInsets.fromLTRB(14.w*3, 147.w*3, 14.w*3, 0),
                    padding: EdgeInsets.fromLTRB(15.w, 0, 15.w, 0),
                    decoration: BoxDecoration(
                        color: HhColors.grayEEBackColor,
                        borderRadius: BorderRadius.all(Radius.circular(14.w))),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: TextField(
                            textAlign: TextAlign.left,
                            maxLines: 1,
                            cursorColor: HhColors.titleColor_99,
                            controller: logic.snController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left:20.w),
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide.none
                              ),
                              hintText: '请输入SN码',
                              hintStyle: TextStyle(
                                  color: HhColors.gray9TextColor, fontSize: 15.sp*3,fontWeight: FontWeight.w400),
                            ),
                            enabled: !logic.isEdit.value,
                            style:
                            TextStyle(color: logic.isEdit.value?HhColors.gray9TextColor:HhColors.blackTextColor, fontSize: 15.sp*3,fontWeight: FontWeight.bold),
                          ),
                        ),
                        logic.isEdit.value?const SizedBox():BouncingWidget(
                          duration: const Duration(milliseconds: 100),
                          scaleFactor: 1.2,
                          onPressed: (){
                            logic.snController!.text = '';
                          },
                          child: Image.asset(
                            "assets/images/common/ic_close.png",
                            width: 16.w*3,
                            height: 16.w*3,
                            fit: BoxFit.fill,
                          ),
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                      ],
                    ),
                  ),
                  ///名称
                  Container(
                    margin: EdgeInsets.fromLTRB(20.w*3, 214.w*3, 0, 0),
                    child: Row(
                      children: [
                        Text(
                          "",
                          style: TextStyle(
                            color: HhColors.titleColorRed,
                            fontSize: 14.sp*3,),
                        ),
                        Text(
                          "输入设备名称",
                          style: TextStyle(
                            color: HhColors.blackTextColor,
                            fontSize: 14.sp*3,),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 50.w*3,
                    margin: EdgeInsets.fromLTRB(14.w*3, 247.w*3, 14.w*3, 0),
                    padding: EdgeInsets.fromLTRB(15.w, 0, 15.w, 0),
                    decoration: BoxDecoration(
                        color: HhColors.grayEEBackColor,
                        borderRadius: BorderRadius.all(Radius.circular(20.w))),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: TextField(
                            textAlign: TextAlign.left,
                            maxLines: 1,
                            maxLength: 10,
                            cursorColor: HhColors.titleColor_99,
                            controller: logic.nameController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 20.w),
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide.none
                              ),
                              counterText: '',
                              hintText: '请输入设备名称',
                              hintStyle: TextStyle(
                                  color: HhColors.gray9TextColor, fontSize: 15.sp*3,fontWeight: FontWeight.w400),
                            ),
                            style:
                            TextStyle(color: HhColors.blackTextColor, fontSize: 15.sp*3,fontWeight: FontWeight.bold),
                          ),
                        ),
                        BouncingWidget(
                          duration: const Duration(milliseconds: 100),
                          scaleFactor: 1.2,
                          onPressed: (){
                            logic.nameController!.text = '';
                          },
                          child: Image.asset(
                            "assets/images/common/ic_close.png",
                            width: 16.w*3,
                            height: 16.w*3,
                            fit: BoxFit.fill,
                          ),
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                      ],
                    ),
                  ),

                  ///列表
                  Container(
                    margin: EdgeInsets.fromLTRB(20.w*3, 312.w*3, 0, 0),
                    child: Text(
                      "请选择设备分组",
                      style: TextStyle(
                          color: HhColors.blackTextColor,
                          fontSize: 15.sp*3,),
                    ),
                  ),
                  logic.testStatus.value ? deviceList() : const SizedBox(),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: 1.sw,
                      height: 1.w,
                      margin: EdgeInsets.only(bottom: 97.w*3),
                      color: HhColors.grayDDTextColor,
                    ),
                  ),
                  ///确定添加按钮
                  Align(
                    alignment: Alignment.bottomCenter,
                    child:
                    BouncingWidget(
                      duration: const Duration(milliseconds: 100),
                      scaleFactor: 1.2,
                      onPressed: (){
                        // Get.to(()=>DeviceStatusPage(),binding: DeviceStatusBinding());
                        if(logic.snController!.text == ''){
                          EventBusUtil.getInstance().fire(HhToast(title: '请输入设备SN码'));
                          return;
                        }
                        if(logic.nameController!.text == ''){
                          EventBusUtil.getInstance().fire(HhToast(title: '请输入设备名称'));
                          return;
                        }
                        if(!CommonUtils().validateSpaceName(logic.nameController!.text)){
                          EventBusUtil.getInstance().fire(HhToast(title: '设备名称不能包含特殊字符'));
                          return;
                        }
                        if(logic.spaceId == '' || logic.spaceId == 'null'){
                          EventBusUtil.getInstance().fire(HhToast(title: '请选择设备分组'));
                          return;
                        }

                        HhLog.d('add');
                        if(logic.isEdit.value){
                          logic.model["name"] = logic.nameController!.text;
                          logic.model["spaceId"] = logic.spaceId;
                          if(logic.location.value.contains("点击选择设备定位")){
                            logic.updateDevice(false);
                          }else{
                            logic.updateDevice(true);
                          }
                        }else{
                          if(logic.location.value.contains("点击选择设备定位")){
                            EventBusUtil.getInstance().fire(HhToast(title: '点击选择设备定位'));
                            return;
                          }
                          logic.createDevice();
                        }
                      },
                      child: Container(
                        height: 44.w*3,
                        width: 1.sw,
                        margin: EdgeInsets.fromLTRB(14.w*3, 0, 14.w*3, 35.w*3),
                        decoration: BoxDecoration(
                            color: HhColors.mainBlueColor,
                            borderRadius: BorderRadius.all(Radius.circular(8.w*3))),
                        child: Center(
                          child: Text(
                            logic.isEdit.value?"保存":"确定添加",
                            style: TextStyle(
                                color: HhColors.whiteColor,
                                fontSize: 16.sp*3,),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  deviceList() {
    return logic.index.value == -1?const SizedBox():Container(
      margin: EdgeInsets.fromLTRB(14.w*3, 345.w*3, 14.w*3, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(maxHeight: 50.w*3),
            child: Column(
              children: [
                Expanded(
                  child: PagedGridView<int, dynamic>(
                    padding: const EdgeInsets.all(0),
                    pagingController: logic.deviceController,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, //横轴三个子widget
                        childAspectRatio: 2.5 //宽高比为1时，子widget
                        ),
                    builderDelegate: PagedChildBuilderDelegate<dynamic>(
                      itemBuilder: (context, item, index) =>
                          InkWell(
                            onTap: (){
                              logic.index.value = -1;
                              logic.index.value = index;
                              logic.spaceId = '${item['id']}';
                            },
                            child: Container(
                              height: 45.w*3,
                              margin: EdgeInsets.fromLTRB(20.w, 20.w, 20.w, 0),
                              padding: EdgeInsets.fromLTRB(10.w, 0, 10.w, 0),
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                  color: logic.index.value==index?HhColors.backBlueInColor:HhColors.whiteColor,
                                  border:logic.index.value==index?Border.all(color: HhColors.backBlueOutColor):null,
                                  borderRadius: BorderRadius.all(Radius.circular(8.w*3))),
                              child: Center(
                                child: Text(
                                  "${item['name']}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: logic.index.value==index?HhColors.mainBlueColor:HhColors.gray9TextColor,
                                      fontSize: 15.sp*3),
                                ),
                              ),
                            ),
                          ),
                      firstPageProgressIndicatorBuilder: (context) => Container(),
                      newPageProgressIndicatorBuilder: (context) => Container(),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ///新增分组
                BouncingWidget(
                  duration: const Duration(milliseconds: 100),
                  scaleFactor: 1.2,
                  onPressed: (){
                    Get.to(()=>SpacePage(),binding: SpaceBinding());
                  },
                  child: Container(
                    height: 45.w*3,
                    width: 103.w*3,
                    margin: EdgeInsets.fromLTRB(20.w, 20.w, 0, 0),
                    padding: EdgeInsets.all(20.w),
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                        color: HhColors.whiteColor,
                        borderRadius: BorderRadius.all(Radius.circular(8.w*3))),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          "assets/images/common/ic_add.png",
                          width: 18.w*3,
                          height: 18.w*3,
                          fit: BoxFit.fill,
                        ),
                        SizedBox(
                          width: 6.w,
                        ),
                        Text(
                          "新增分组",
                          style: TextStyle(
                              color: HhColors.gray4TextColor,
                              fontSize: 15.sp*3,fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                ),

                ///选择设备定位
                Container(
                  margin: EdgeInsets.fromLTRB(5.w*3, 30.w, 0, 0),
                  child: Text(
                    "选择设备定位",
                    style: TextStyle(
                      color: HhColors.blackTextColor,
                      fontSize: 15.sp*3,),
                  ),
                ),
                InkWell(
                  onTap: (){
                    Get.to(() => LocationPage(), binding: LocationBinding());
                  },
                  child: Container(
                    width: 1.sw,
                    height: 45.w*3,
                    margin: EdgeInsets.fromLTRB(5.w*3, 30.w, 5.w*3, 0),
                    padding: EdgeInsets.fromLTRB(14.w*3, 26.w, 14.w*3, 26.w),
                    decoration: BoxDecoration(
                      color: HhColors.grayEDBackColor,
                      borderRadius: BorderRadius.circular(8.w*3)
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            (logic.location.value),
                            maxLines: 1,
                            style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              color: logic.isEdit.value?HhColors.gray9TextColor:HhColors.blackTextColor,
                              fontSize: 15.sp*3,fontWeight: FontWeight.bold),
                          ),
                        ),
                        Image.asset(
                          "assets/images/common/icon_blue_loc.png",
                          width: 20.w*3,
                          height: 20.w*3,
                          fit: BoxFit.fill,
                        )
                      ],
                    ),
                  ),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
