class HhToast{
  String title;
  int ?type;//1 success 2 error 3 warn
  int ?color;//0 white

  HhToast({required this.title,this.type,this.color});
}
class HhLoading{
  bool show;
  String ?title;

  HhLoading({required this.show,this.title});
}
class TreeChannelRefresh{
  TreeChannelRefresh();
}
class LocResult{
  String title;
  String detail;
  double lat;
  double lng;
  String ?province;
  String ?city;
  String ?district;
  String ?township;

  LocResult(this.title,this.detail,this.lat,this.lng,{this.province,this.city,this.district,this.township});
}
class LocResultForDynamicParams{
  String code;
  String title;
  String detail;
  double lat;
  double lng;
  String ?province;
  String ?city;
  String ?district;
  String ?township;

  LocResultForDynamicParams(this.code,this.title,this.detail,this.lat,this.lng,{this.province,this.city,this.district,this.township});
}
class LocText{
  String ?text;

  LocText({required this.text});
}
class CatchRefresh{
  CatchRefresh();
}
class Version{
  Version();
}
class DownProgress{
  int progress;
  DownProgress({required this.progress});
}
class SpaceList{
  String ?mode;
  SpaceList({this.mode});
}
class WarnList{
  WarnList();
}
class DeviceList{
  DeviceList();
}
class UserInfo{
  UserInfo();
}
class Message{
  Message();
}
class Move{
  int action;
  String code;
  Move({required this.action,required this.code,});
}
class Scale{
  double scale;
  double dx;
  double dy;
  Scale({required this.scale,required this.dx,required this.dy});
}
class DeviceInfo{
  DeviceInfo();
}
class Record{
  Record();
}
class Share{
  dynamic model;
  Share({required this.model});
}