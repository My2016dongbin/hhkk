
import 'package:iot/utils/SPKeys.dart';
import 'package:shared_preferences/shared_preferences.dart';

///菜单按钮权限
class Permissions{
  static SharedPreferences? sharedPreferences;

  static Future<void> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  ///菜单权限
  static const main = 'app:menu:main';
  static const video = 'app:menu:video';
  static const message = 'app:menu:message';
  static const map = 'app:menu:map';
  static const mine = 'app:menu:mine';///不受权限控制-'我的页面'必须存在


  ///首页
  //轮播图
  static const mainBanner = 'app:main:banner';
  //菜单
  static const mainMenu = 'app:main:menu';
  //报警管理
  static const mainWarnManage = 'app:main:warnManage';
  //卫星监测
  static const mainSatellite = 'app:main:satellite';
  //无人机监测
  static const mainDrone = 'app:main:drone';
  //视频监控
  static const mainVideo = 'app:main:video';
  //塔台瞭望
  static const mainTower = 'app:main:tower';
  //地面巡护
  static const mainLand = 'app:main:land';
  //舆情监测
  static const mainPublicOpinion = 'app:main:publicOpinion';
  //火险预警
  static const mainFireWarning = 'app:main:fireWarning';
  //火情上报
  static const mainFireUpload = 'app:main:fireUpload';
  //隐患排查
  static const mainHiddenDanger = 'app:main:hiddenDanger';
  //任务单
  static const mainTask = 'app:main:task';
  //资源点维护
  static const mainResource = 'app:main:resource';
  //护林员
  static const mainUser = 'app:main:user';
  //要闻
  static const mainNews = 'app:main:news';
  //考勤管理
  static const mainSignManage = 'app:main:signManage';
  //天气
  static const mainWeather = 'app:main:weather';
  //设备监测
  static const mainDeviceMonitor = 'app:main:deviceMonitor';
  //火险等级
  static const mainFireLevel = 'app:main:fireLevel';
  //消息提醒-右上角
  static const mainMessage = 'app:main:message';

  ///视频
  //控制
  static const videoControl = 'app:video:control';

  ///消息
  //一键已读
  static const messageAllRead = 'app:message:allRead';

  ///地图
  //预警
  static const mapWarn = 'app:map:warning';
  //预警-地面火险预警监测站
  static const mapWarnStation = 'app:map:warningStation';
  //预警-森林资源
  static const mapWarnForest = 'app:map:warningForest';
  //预警-行政区风险
  static const mapWarnArea = 'app:map:warningArea';
  //预警-网格化风险
  static const mapWarnGrid = 'app:map:warningGrid';
  //监测
  static const mapMonitor = 'app:map:monitor';
  //监测-火情
  static const mapMonitorFire = 'app:map:monitorFire';
  //监测-无人机
  static const mapMonitorDrone = 'app:map:monitorDrone';
  //监测-监控
  static const mapMonitorVideo = 'app:map:monitorVideo';
  //监测-瞭望塔
  static const mapMonitorTower = 'app:map:monitorTower';
  //监测-护林队
  static const mapMonitorTeam = 'app:map:monitorTeam';
  //监测-火险等级
  static const mapMonitorLevel = 'app:map:monitorLevel';
  //资源列表
  static const mapResourceList = 'app:map:resourceList';
  //资源添加
  static const mapResourceAdd = 'app:map:resourceAdd';
  //资源搜索
  static const mapResourceSearch = 'app:map:resourceSearch';
  //任务
  static const mapTask = 'app:map:task';

  ///我的
  //版本信息
  static const mineVersion = 'app:mine:version';
  //修改密码
  static const minePassword = 'app:mine:password';
  //权限开启
  static const minePermission = 'app:mine:permission';
  //投诉建议
  static const mineSuggestion = 'app:mine:suggestion';
  //实时位置上传
  static const mineLocation = 'app:mine:location';
  //语音播报
  static const mineAudio = 'app:mine:audio';
  //修改头像
  static const mineHeader = 'app:mine:header';


  ///公共权限
  //MQTT权限
  static const mqtt = 'app:common:mqtt';


  static bool hasPermission(String  permission) {
    List<String> permissions = sharedPreferences!.getStringList(SPKeys().permissions)??[];
    // if(permissions.contains("*:*:*") ||permissions.contains(permission)){
    //   return true;
    // }
    // return false;
    return true;
  }

}