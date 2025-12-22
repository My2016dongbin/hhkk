# iot

flavor:
个人版本 haohaiVersion
企业 businessVersion
个人测试版本 betaVersion
企业测试版本 betaBusinessVersion

export JAVA_HOME=$(/usr/libexec/java_home -v11)


                                  decoration: TextDecoration.none,

decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  border: const OutlineInputBorder(
                      borderSide: BorderSide.none
                  ),
                  counterText: '',
                  hintText: '请输入设备名称',
                  floatingLabelBehavior: FloatingLabelBehavior.never, // 取消文本上移效果
                ),


///title
                        Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            margin: EdgeInsets.only(top: 54.w*3),
                            color: HhColors.trans,
                            child: Text(
                              '设备定位',
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


                        InteractiveViewer(
                                                panEnabled: true, // 是否允许拖动
                                                minScale: 1.0,
                                                maxScale: 10.0,
