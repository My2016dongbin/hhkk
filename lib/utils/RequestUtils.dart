
class RequestUtils{
  // static const base = 'http://172.16.50.96:48080';//debug
  static const base = 'http://117.132.5.139:18033/iot-api';//debug 外网生产
  // static const base = 'http://192.168.1.192:30019';//debug 网关
  // static const base = 'http://192.168.1.165:10003/iot-api';//debug 内网

  static const login = '$base/admin-api/system/auth/login';//密码登录
  static const logout = '$base/admin-api/system/auth/logout';//登出
  //static const version = '$base/admin-api/system/android-upgrade/page';//查询版本
  static const versionNew = '$base/admin-api/system/android-upgrade/getAndroidUpgradeVersionNew';//查询版本新版
  static const tenantId = '$base/admin-api/system/tenant/get-tenant-by-name';//'$base/admin-api/system/tenant/get-id-by-name';//获取租户id
  static const tenantSearch = '$base/admin-api/system/tenant/get-tenant-by-user';//'$base/admin-api/system/tenant/get-id-by-user';//根据手机号/用户名获取租户id
  static const codeCheckCommon = '$base/admin-api/system/auth/sms-use';//校验验证码-通用
  static const codeSend = '$base/admin-api/system/auth/send-sms-code';//发送验证码（含通用scene=24）
  static const codeLogin = '$base/admin-api/system/auth/sms-login';//验证码登录
  static const putBackPassword = '$base/admin-api/system/user/update-password-mobile-app';//找回用户密码
  static const userInfo = '$base/admin-api/system/user/profile/get';//个人信息查询
  static const codeRegisterSend = '$base/admin-api/system/auth/send-sms-code-register';//发送验证码-注册
  static const codeRegister = '$base/admin-api/system/auth/register';//注册
  static const weatherLocation = '$base/admin-api/mid/weather-now/getWeatherByLocation';//查询定位天气
  static const unReadCount = '$base/admin-api/system/message-log/getUnReadMessageCount';//主页未读消息数量查询
  static const unReadCountWarn = '$base/admin-api/mid/device-alarm-info/getUnReadDeviceAlarmCount';//未读消息数量查询
  static const unReadCountNotice = '$base/admin-api/system/message-log/getUnReadMessageCount';//未读消息数量查询
  static const mainSpaceList = '$base/admin-api/mid/space/page';//主页空间列表
  static const spaceCreate = '$base/admin-api/mid/space/create';//添加空间
  static const spaceUpdate = '$base/admin-api/mid/space/update';//更新空间
  static const message = '$base/admin-api/system/message-log/page';//主页-消息-通知信息查询
  static const messageCall = '$base/admin-api/mid/pole-device-call-log/page';//主页-消息-通话信息查询
  static const messageAlarm = '$base/admin-api/mid/device-alarm-info/page';//主页-消息-报警信息查询
  //static const spaceInfo = '$base/admin-api/mid/space/get';//主页-空间-空间信息
  static const deviceInfo = '$base/admin-api/mid/device-base/get';//设备详情
  static const deviceConfig = '$base/admin-api/mid/device-config/get';//设备配置
  static const deviceConfigScreenTop = '$base/admin-api/mid/device-info/sendDeviceCmd';//设备配置修改
  static const deviceVoiceTop = '$base/admin-api/mid/voice-resource/page';//设备音频列表
  static const deviceVersion = '$base/admin-api/mid/device-ota-file/page';//设备固件版本号
  static const deviceHistory = '$base/admin-api/mid/device-alarm-info/page';//设备详情-历史消息
  static const deviceStream = '$base/admin-api/mid/device-base/findChannelListByDeviceNo';//设备通道查询
  static const devicePlayUrl = '$base/admin-api/mid/videoAggregation/devicePreviewUrlApp';//设备视频流查询
  static const deviceCreate = '$base/admin-api/mid/device-base/create';//设备添加
  static const deviceUpdate = '$base/admin-api/mid/device-base/update';//设备修改
  static const deviceDelete = '$base/admin-api/mid/device-base/delete';//设备删除
  static const deviceList = '$base/admin-api/mid/device-base/page';//设备查询
  static const alarmType = '$base/admin-api/system/dict-data/page';//告警类型查询
  static const userEdit = '$base/admin-api/system/user/profile/update';//修改个人信息
  static const mainSearch = '$base/admin-api/mid/space/getListByKeyWord';//主页查询空间设备及消息
  static const fileUpload = '$base/admin-api/infra/file/upload';//文件上传
  static const headerUpload = '$base/admin-api/system/user/profile/update-avatar';//个人头像上传
  static const password = '$base/admin-api/system/user/profile/update-password';//修改个人密码
  static const codeSendPersonal = '$base/admin-api/system/captcha/get';//发送验证码
  static const codeCheckPersonal = '$base/admin-api/system/captcha/check';//校验验证码
  static const codeCheckChangePhone = '$base/admin-api/system/user/update-mobile';//修改手机号
  static const videoControl = '$base/admin-api/mid/videoAggregation/deviceControl';//视频控制
  static const leftRead = '$base/admin-api/mid/device-alarm-info/batchRead';//报警批量已读
  static const leftDelete = '$base/admin-api/mid/device-alarm-info/batchDelete';//报警批量删除
  static const rightRead = '$base/admin-api/system/message-log/batchRead';//通知批量已读
  static const rightDelete = '$base/admin-api/system/message-log/batchDelete';//通知批量删除
  static const dzControl = '$base/admin-api/mid/device-info/sendGateCmd';//道闸控制
  static const dzLiveUrl = '$base/admin-api/mid/device-base/getBarrierPlayUrl';//道闸获取视频流
  static const dzHistory = '$base/admin-api/mid/barrier-identify-record/page';//道闸出入历史记录
  static const productType = '$base/admin-api/system/dict-data/page';//产品类型字典查询
  static const voiceDelete = '$base/admin-api/mid/voice-resource/delete';//音频删除

  static const getDataInfo = '$base/admin-api/mid/device-base/getDataInfo';//获取当日电量
  static const energyPage = '$base/admin-api/mid/pole-solar-energy/page';//获取智慧立杆设备太阳能信息分页
  static const soilPage = '$base/admin-api/mid/pole-soil-info/page';//获取智慧立杆土壤信息分页
  static const weatherPage = '$base/admin-api/mid/pole-meteorological-info/page';//获取智慧立杆气象信息分页
  static const hxyzPage = '$base/admin-api/mid/device-measurements/page';//获取火险因子信息分页
  static const audioCreate = '$base/admin-api/mid/voice-resource/create';//立杆音频创建

  static const getAlarmConfig = '$base/admin-api/mid/user-config/getAlarmConfig';//获得用户报警配置
  static const saveAlarmConfig = '$base/admin-api/mid/user-config/saveAlarmConfig';//保存用户报警配置
  static const getAppDeviceBlock = '$base/admin-api/mid/user-config/getAppDeviceBlock';//获得用户隐藏设备列表
  static const saveAppDeviceBlock = '$base/admin-api/mid/user-config/saveAppDeviceBlock';//保存app用户隐藏设备

  ///Socket
  static const chatStatus = '$base/admin-api/mid/device-info/chatState';//获取设备通话状态GET
  static const chatCreate = '$base/admin-api/mid/device-info/chatState';//断开POST
  static const chatReceive = '$base/admin-api/mid/device-info/sendChatCmd';//被呼叫后查询语音服务信息POST

  static const shareCreate = '$base/app-api/mid/share-log/create';//分享创建 old
  static const shareReceive = '$base/app-api/mid/receive-log/create';//分享接收 old

  static const shareSend = '$base/app-api/mid/receive-log/create';//发起分享
  static const shareList = '$base/app-api/mid/receive-log/page';//分享管理记录
  static const shareHandle = '$base/app-api/mid/receive-log/handleReceiveLog';//分享处理 POST{id,status}
  static const deleteChangeSpace = '$base/admin-api/mid/space/deleteSpaceAndDevice';//删除空间


  /*
    Map<String, dynamic> map = {};
    map['pageNo'] = '$pageKey';
    Future<void> getUnRead() async {
      var result = await HhHttp().request(RequestUtils.unReadCount,method: DioMethod.get,params:map);
      HhLog.d("getUnRead -- $result");
      if(result["code"]==0 && result["data"]!=null){
        count.value = '${result["data"]}';
      }else{
        EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(result["msg"])));
      }
    }
  */
}