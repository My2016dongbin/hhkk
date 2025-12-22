import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Styles {
  Styles._();

  static Color c_0089FF = const Color(0xFF58BE6B); // 主题色
  static Color c_509DF7 = const Color(0xFF58BE6B); // UI设计主色
  static Color c_0C1C33 = const Color(0xFF0C1C33); // 黑色字体
  static Color c_333333 = const Color(0xFF333333); // 黑色字体
  static Color c_EDEDED = const Color(0xFFEDEDED); // 朋友圈背景色
  // static Color c_8E9AB0 = const Color(0xFF8E9AB0); // 说明文字
  static Color c_8E9AB0 = const Color(0xFF999999); // 说明文字
  static Color c_D8D8D8 = const Color(0xFFD8D8D8); // 分割线
  static Color c_D4D4D4 = const Color(0xFFD4D4D4); // 分割线
  static Color c_666666 = const Color(0xFF666666); // 朋友圈内容文字
  static Color c_moment_name = const Color(0xFF667FBE); // 朋友圈文字颜色
  static Color c_F4F6F9 = const Color(0xFFF4F6F9); // 输入框背景
  static Color c_F6F6F6 = const Color(0xFFF6F6F6); // 输入框背景
  static Color c_F4F4F4 = const Color(0xFFF4F4F4); //转发背景
  static Color c_E8EAEF = const Color(0xFFE8EAEF); // 分割线
  static Color c_FF381F = const Color(0xFFFF381F); // 警告色
  static Color loginOut = const Color(0xFFBC0505); // 警告色
  static Color c_FF5858 = const Color(0xFFFF5858); // 退款失败
  static Color c_FFFFFF = const Color(0xFFFFFFFF); // 警告色
  static Color c_999999 = const Color(0xFF999999); // 警告色
  static Color c_18E875 = const Color(0xFF18E875); // 在线
  static Color c_F0F2F6 = const Color(0xFFF0F2F6); // 聊天页底部
  static Color c_F0F0F0 = const Color(0xFFF0F0F0); // 聊天页底部
  static Color c_000000 = const Color(0xFF000000); //
  static Color c_92B3E0 = const Color(0xFF92B3E0);
  static Color c_F2F8FF = const Color(0xFFF2F8FF); // 同步成功背景色
  static Color c_F7FAFE = const Color(0xFFF7FAFE); // 播放语音背景色
  static Color c_F8F9FA = const Color(0xFFF8F9FA); // 默认背景
  static Color c_6085B1 = const Color(0xFF6085B1);
  static Color c_FFB300 = const Color(0xFFFFB300); // 会议状态
  static Color c_pay_a = const Color(0xFFFFCC00); // 支付状态A颜色
  static Color c_orange = const Color(0xFFFF921E); // 橙色
  static Color c_FFE1DD = const Color(0xFFFFE1DD); // 同步失败背景色
  static Color c_FFEDEDED = const Color(0xFFEDEDED);

  static Color c_tab = const Color(0xC53477FF); // 生活type背景色
  static Color c_life = const Color(0xC539CD80); // 生活type背景色
  static Color c_ad = const Color(0xC5FFB300); // 广告type背景色
  static Color c_help = const Color(0xC5FF381F); // 求助type背景色
  static Color type_back_color = const Color(0xFFF1F1F1); // type背景色
  static Color c_wxgreen = const Color(0xFF58BE6B); //微信绿
  static Color c_unwxgreen = const Color(0xFF77E3AC); //微信
  static Color c_92B3E0_opacity50 = c_92B3E0.withOpacity(.5); // 气泡背景
  static Color c_E8EAEF_opacity50 = c_E8EAEF.withOpacity(.5);
  static Color c_F4F5F7 = const Color(0xFFFFFFFF);
  static Color c_CCE7FE = const Color(0xFFA8EA7C);
  static Color C_FFF06565 = const Color(0xFFF06565);
  static Color C_FFFF921E = const Color(0xFFFF921E);
  static Color C_FFF9F9F9 = const Color(0xFFF9F9F9);
  static Color C_weizhi = const Color(0xFF667FBE);

  // static Color c_E8EAEF_opacity30 = c_E8EAEF.withOpacity(.3); // 默认背景

  static Color c_FFFFFF_opacity0 = c_FFFFFF.withOpacity(.0);
  static Color c_FFFFFF_opacity70 = c_FFFFFF.withOpacity(.7);
  static Color c_FFFFFF_opacity50 = c_FFFFFF.withOpacity(.5);
  static Color c_0089FF_opacity10 = c_0089FF.withOpacity(.1);
  static Color c_0089FF_opacity20 = c_0089FF.withOpacity(.2);
  static Color c_0089FF_opacity50 = c_0089FF.withOpacity(.5);
  static Color c_FF381F_opacity10 = c_FF381F.withOpacity(.1);
  static Color c_8E9AB0_opacity13 = c_8E9AB0.withOpacity(.13);
  static Color c_8E9AB0_opacity15 = c_8E9AB0.withOpacity(.15);
  static Color c_8E9AB0_opacity16 = c_8E9AB0.withOpacity(.16);
  static Color c_8E9AB0_opacity30 = c_8E9AB0.withOpacity(.3);
  static Color c_8E9AB0_opacity50 = c_8E9AB0.withOpacity(.5);
  static Color c_0C1C33_opacity30 = c_0C1C33.withOpacity(.3);
  static Color c_0C1C33_opacity60 = c_0C1C33.withOpacity(.6);
  static Color c_0C1C33_opacity85 = c_0C1C33.withOpacity(.85);
  static Color c_0C1C33_opacity80 = c_0C1C33.withOpacity(.8);
  static Color c_FF381F_opacity70 = c_FF381F.withOpacity(.7);
  static Color c_000000_opacity70 = c_000000.withOpacity(.7);
  static Color c_000000_opacity15 = c_000000.withOpacity(.15);
  static Color c_000000_opacity12 = c_000000.withOpacity(.12);
  static Color c_000000_opacity4 = c_000000.withOpacity(.04);

  /// FFFFFF
  static TextStyle ts_FFFFFF_21sp = TextStyle(
    color: c_FFFFFF,
    fontSize: 21.sp,
  );
  static TextStyle ts_FFFFFF_20sp_medium = TextStyle(
    color: c_FFFFFF,
    fontSize: 20.sp,
    fontWeight: FontWeight.w500,
  );
  static TextStyle ts_000000_20sp_medium = TextStyle(
    color: c_000000,
    fontSize: 20.sp,
    fontWeight: FontWeight.w500,
  );
  static TextStyle ts_orange_18sp = TextStyle(
    color: c_orange,
    fontSize: 18.sp,
    fontWeight: FontWeight.w500,
  );
  static TextStyle ts_orange_13sp = TextStyle(
    color: c_orange,
    fontSize: 13.sp,
  );
  static TextStyle ts_FFFFFF_18sp_medium = TextStyle(
    color: c_FFFFFF,
    fontSize: 18.sp,
    fontWeight: FontWeight.w500,
  );
  static TextStyle ts_FFFFFF_17sp = TextStyle(
    color: c_FFFFFF,
    fontSize: 17.sp,
  );
  static TextStyle ts_FFFFFF_opacity70_17sp = TextStyle(
    color: c_FFFFFF_opacity70,
    fontSize: 17.sp,
  );
  static TextStyle ts_FFFFFF_17sp_semibold = TextStyle(
    color: c_FFFFFF,
    fontSize: 17.sp,
    fontWeight: FontWeight.w600,
  );
  static TextStyle ts_FFFFFF_17sp_medium = TextStyle(
    color: c_FFFFFF,
    fontSize: 17.sp,
    fontWeight: FontWeight.w500,
  );
  static TextStyle ts_FFFFFF_16sp =
      TextStyle(color: c_FFFFFF, fontSize: 16.sp, height: 1.1.h);
  static TextStyle ts_FFFFFF_13sp = TextStyle(
      color: c_FFFFFF, fontSize: 13.sp, textBaseline: TextBaseline.ideographic);
  static TextStyle ts_FFFFFF_13sp_italic = TextStyle(
      color: c_FFFFFF,
      fontSize: 13.sp,
      textBaseline: TextBaseline.ideographic,
      fontStyle: FontStyle.italic);
  static TextStyle ts_FFFFFF_30sp =
      TextStyle(color: c_FFFFFF, fontSize: 30.sp, height: 1.1.h);
  static TextStyle ts_FFFFFF_30sp_italic = TextStyle(
      color: c_FFFFFF,
      fontSize: 30.sp,
      height: 1.1.h,
      fontStyle: FontStyle.italic);
  static TextStyle ts_FFFFFF_14sp = TextStyle(
    color: c_FFFFFF,
    fontSize: 14.sp,
  );
  static TextStyle ts_FFFFFF_opacity70_14sp = TextStyle(
    color: c_FFFFFF_opacity70,
    fontSize: 14.sp,
  );
  static TextStyle ts_FFFFFF_14sp_medium = TextStyle(
    color: c_FFFFFF,
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
  );
  static TextStyle ts_FFFFFF_12sp = TextStyle(
    color: c_FFFFFF,
    fontSize: 12.sp,
  );
  static TextStyle ts_FFFFFF_10sp = TextStyle(
    color: c_FFFFFF,
    fontSize: 10.sp,
  );
  static TextStyle ts_FFFFFF_10sp_bold =
      TextStyle(color: c_FFFFFF, fontSize: 10.sp, fontWeight: FontWeight.bold);

  static TextStyle ts_c_999999_10sp = TextStyle(
    color: c_999999,
    fontSize: 10.sp,
    // fontWeight: FontWeight.bold
  );
  static TextStyle ts_c_999999_13sp = TextStyle(
    color: c_999999,
    fontSize: 13.sp,
    // fontWeight: FontWeight.bold
  );

  static TextStyle ts_c_999999_16sp = TextStyle(
    color: c_999999,
    fontSize: 16.sp,
    // fontWeight: FontWeight.bold
  );

  /// 8E9AB0
  static TextStyle ts_8E9AB0_10sp_semibold = TextStyle(
    color: c_8E9AB0,
    fontSize: 10.sp,
    fontWeight: FontWeight.w600,
  );
  static TextStyle ts_8E9AB0_10sp = TextStyle(
    color: c_8E9AB0,
    fontSize: 10.sp,
  );
  static TextStyle ts_8E9AB0_12sp = TextStyle(
    color: c_333333,
    fontSize: 12.sp,
  );
  static TextStyle ts_8E9AB0_13sp =
      TextStyle(color: c_8E9AB0, fontSize: 13.sp, height: 1.1.h);
  static TextStyle ts_333333_13sp =
      TextStyle(color: c_333333, fontSize: 13.sp, height: 1.1.h);
  static TextStyle ts_333333_13sp_noheight =
      TextStyle(color: c_333333, fontSize: 13.sp, height: 1.1.h);
  static TextStyle ts_333333_16sp = TextStyle(
    color: c_333333,
    fontSize: 16.sp,
  );
  static TextStyle ts_333333_16sp_bold = TextStyle(
    color: c_333333,
    fontSize: 16.sp,
    fontWeight: FontWeight.bold
  );
  static TextStyle ts_333333_13sp_no_height = TextStyle(
    color: c_333333,
    fontSize: 13.sp,
  );
  static TextStyle ts_333333_10sp = TextStyle(
    color: c_333333,
    fontSize: 10.sp*3,
  );
  static TextStyle ts_39CD80_10sp_bold = TextStyle(
    color: c_tab,
    fontSize: 10.sp*3,
    fontWeight: FontWeight.w600
  );
  static TextStyle ts_FF5858_13sp = TextStyle(
    color: c_FF5858,
    fontSize: 13.sp,
  );
  static TextStyle ts_666666_13sp = TextStyle(
    color: c_666666,
    fontSize: 13.sp,
    height: 1.6.h,
  );
  static TextStyle ts_c_pay_a_13sp = TextStyle(
    color: c_pay_a,
    fontSize: 13.sp,
  );
  static TextStyle ts_c_pay_a_16sp = TextStyle(
    color: c_pay_a,
    fontSize: 16.sp,
  );
  static TextStyle ts_c_pay_b_16sp = TextStyle(
    color: c_999999,
    fontSize: 16.sp,
    decoration: TextDecoration.lineThrough,
    decorationColor: c_999999,
    // 可选，设置横线颜色
    decorationThickness: 2, // 可选，设置横线粗细
  );
  static TextStyle ts_666666_11sp = TextStyle(color: c_666666, fontSize: 11.sp);
  static TextStyle ts_666666_13sp_18height = TextStyle(
    color: c_666666,
    fontSize: 13.sp,
    height: 1.8.h,
  );
  static TextStyle ts_reply_13sp = TextStyle(
    color: c_666666,
    fontSize: 13.sp,
  );
  static TextStyle ts_666666_16sp = TextStyle(
    color: c_666666,
    fontSize: 16.sp,
    height: 1.4.h,
  );
  static TextStyle ts_8E9AB0_14sp = TextStyle(
    color: c_8E9AB0,
    fontSize: 14.sp,
  );
  static TextStyle ts_8E9AB0_15sp = TextStyle(
    color: c_8E9AB0,
    fontSize: 15.sp,
  );
  static TextStyle ts_8E9AB0_16sp = TextStyle(
    color: c_8E9AB0,
    fontSize: 16.sp,
  );
  static TextStyle ts_8E9AB0_17sp = TextStyle(
    color: c_8E9AB0,
    fontSize: 17.sp,
  );
  static TextStyle ts_8E9AB0_opacity50_17sp = TextStyle(
    color: c_8E9AB0_opacity50,
    fontSize: 17.sp,
  );

  /// 0C1C33
  static TextStyle ts_0C1C33_10sp = TextStyle(
    color: c_0C1C33,
    fontSize: 10.sp,
  );
  static TextStyle ts_0C1C33_12sp = TextStyle(
    color: c_0C1C33,
    fontSize: 12.sp,
  );
  static TextStyle ts_0C1C33_12sp_medium = TextStyle(
    color: c_0C1C33,
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
  );
  static TextStyle ts_0C1C33_14sp = TextStyle(
    color: c_0C1C33,
    fontSize: 14.sp,
  );
  static TextStyle ts_0C1C33_14sp_medium = TextStyle(
    color: c_0C1C33,
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
  );
  static TextStyle ts_0C1C33_17sp = TextStyle(
    color: c_0C1C33,
    fontSize: 17.sp,
  );
  static TextStyle ts_0C1C33_13sp = TextStyle(
    color: c_0C1C33,
    fontSize: 13.sp,
  );
  static TextStyle ts_c_8E9AB0_13sp = TextStyle(
    color: c_8E9AB0,
    fontSize: 13.sp,
  );
  static TextStyle ts_c_8E9AB0_16sp = TextStyle(
    color: c_8E9AB0,
    fontSize: 16.sp,
  );
  static TextStyle ts_location = TextStyle(
    color: c_moment_name,
    fontSize: 13.sp,
    overflow: TextOverflow.ellipsis
  );
  static TextStyle ts_c_orange_16sp =
      TextStyle(color: c_orange, fontSize: 16.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_c_509DF7_13sp = TextStyle(
    color: c_509DF7,
    fontSize: 13.sp,
  );
  static TextStyle ts_c_509DF7_13sp_500w =
      TextStyle(color: c_509DF7, fontSize: 13.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_c_moment_name_13sp = TextStyle(
      color: c_moment_name, fontSize: 13.sp, overflow: TextOverflow.visible);
  static TextStyle ts_c_moment_name_16sp = TextStyle(
      color: c_moment_name, fontSize: 16.sp, overflow: TextOverflow.visible);
  static TextStyle ts_c_moment_name_16sp_600w = TextStyle(
      color: c_moment_name, fontSize: 16.sp, overflow: TextOverflow.visible,fontWeight: FontWeight.w600);
  static TextStyle ts_c_moment_name_11sp_400w = TextStyle(
      color: c_moment_name, fontSize: 11.sp, overflow: TextOverflow.visible,fontWeight: FontWeight.w400);
  static TextStyle ts_c_8E9AB0_10sp = TextStyle(
    color: c_8E9AB0,
    fontSize: 10.sp,
  );
  static TextStyle ts_0C1C33_16sp = TextStyle(
    color: c_0C1C33,
    fontSize: 16.sp,
  );

  static TextStyle ts_loginOut_16sp = TextStyle(
    color: loginOut,
    fontSize: 16.sp,
  );

  static TextStyle ts_FFFFFF_18sp = TextStyle(
    color: c_FFFFFF,
    fontSize: 18.sp,
  );

  static TextStyle ts_0C1C33_17sp_medium = TextStyle(
    color: c_0C1C33,
    fontSize: 17.sp,
    fontWeight: FontWeight.w500,
  );
  static TextStyle ts_0C1C33_18sp_medium = TextStyle(
    color: c_0C1C33,
    fontSize: 18.sp,
    fontWeight: FontWeight.w500,
  );
  static TextStyle ts_0C1C33_17sp_semibold = TextStyle(
    color: c_0C1C33,
    fontSize: 17.sp,
    fontWeight: FontWeight.w600,
  );
  static TextStyle ts_0C1C33_20sp = TextStyle(
    color: c_0C1C33,
    fontSize: 20.sp,
  );
  static TextStyle ts_0C1C33_20sp_medium = TextStyle(
    color: c_0C1C33,
    fontSize: 20.sp,
    fontWeight: FontWeight.w500,
  );
  static TextStyle ts_0C1C33_20sp_semibold = TextStyle(
    color: c_0C1C33,
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
  );

  /// 0089FF
  static TextStyle ts_0089FF_10sp_semibold = TextStyle(
    color: c_0089FF,
    fontSize: 10.sp,
    fontWeight: FontWeight.w600,
  );
  static TextStyle ts_0089FF_10sp = TextStyle(
    color: c_0089FF,
    fontSize: 10.sp,
  );
  static TextStyle ts_0089FF_12sp = TextStyle(
    color: c_wxgreen,
    fontSize: 12.sp,
  );
  static TextStyle ts_0089FF_14sp = TextStyle(
    color: c_0089FF,
    fontSize: 14.sp,
  );
  static TextStyle ts_0089FF_13sp = TextStyle(
    color: c_0089FF,
    fontSize: 13.sp,
  );
  static TextStyle ts_0089FF_16sp = TextStyle(
    color: c_0089FF,
    fontSize: 16.sp,
  );
  static TextStyle ts_0089FF_17sp = TextStyle(
    color: c_0089FF,
    fontSize: 17.sp,
  );
  static TextStyle ts_0089FF_17sp_semibold = TextStyle(
    color: c_0089FF,
    fontSize: 17.sp,
    fontWeight: FontWeight.w600,
  );
  static TextStyle ts_0089FF_17sp_medium = TextStyle(
    color: c_0089FF,
    fontSize: 17.sp,
    fontWeight: FontWeight.w500,
  );
  static TextStyle ts_0089FF_14sp_medium = TextStyle(
    color: c_0089FF,
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
  );

  static TextStyle ts_0089FF_22sp_semibold = TextStyle(
    color: c_0089FF,
    fontSize: 22.sp,
    fontWeight: FontWeight.w600,
  );

  /// FF381F
  static TextStyle ts_FF381F_17sp = TextStyle(
    color: c_FF381F,
    fontSize: 17.sp,
  );
  static TextStyle ts_FF381F_14sp = TextStyle(
    color: c_FF381F,
    fontSize: 14.sp,
  );
  static TextStyle ts_FF381F_12sp = TextStyle(
    color: c_FF381F,
    fontSize: 12.sp,
  );
  static TextStyle ts_FF381F_10sp = TextStyle(
    color: c_FF381F,
    fontSize: 10.sp,
  );

  /// 6085B1
  static TextStyle ts_6085B1_17sp_medium = TextStyle(
    color: c_6085B1,
    fontSize: 17.sp,
    fontWeight: FontWeight.w500,
  );
  static TextStyle ts_6085B1_17sp = TextStyle(
    color: c_6085B1,
    fontSize: 17.sp,
  );
  static TextStyle ts_6085B1_12sp = TextStyle(
    color: c_6085B1,
    fontSize: 12.sp,
  );
  static TextStyle ts_6085B1_14sp = TextStyle(
    color: c_6085B1,
    fontSize: 14.sp,
  );

  /// 0C1C33
  static TextStyle ts_D8D8D8_10sp = TextStyle(
    color: c_E8EAEF,
    fontSize: 10.sp,
  );
  static TextStyle ts_F921E_16sp = TextStyle(
    color: C_FFFF921E,
    fontSize: 16.sp,
  );
}
