import 'dart:math';

class ParseLocation {
  static const double pi = 3.1415926535897932384626;
  static const double x_pi = 3.14159265358979324 * 3000.0 / 180.0;
  static const double a = 6378245.0;
  static const double ee = 0.00669342162296594323;

  static double transformLat(double x, double y) {
    double ret = -100.0 +
        2.0 * x +
        3.0 * y +
        0.2 * y * y +
        0.1 * x * y +
        0.2 * sqrt(x.abs());
    ret += (20.0 * sin(6.0 * x * pi) + 20.0 * sin(2.0 * x * pi)) * 2.0 / 3.0;
    ret += (20.0 * sin(y * pi) + 40.0 * sin(y / 3.0 * pi)) * 2.0 / 3.0;
    ret += (160.0 * sin(y / 12.0 * pi) + 320 * sin(y * pi / 30.0)) * 2.0 / 3.0;
    return ret;
  }

  static double transformLon(double x, double y) {
    double ret =
        300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(x.abs());
    ret += (20.0 * sin(6.0 * x * pi) + 20.0 * sin(2.0 * x * pi)) * 2.0 / 3.0;
    ret += (20.0 * sin(x * pi) + 40.0 * sin(x / 3.0 * pi)) * 2.0 / 3.0;
    ret +=
        (150.0 * sin(x / 12.0 * pi) + 300.0 * sin(x / 30.0 * pi)) * 2.0 / 3.0;
    return ret;
  }

  static List<double> transform(double lat, double lon) {
    if (outOfChina(lat, lon)) {
      return [lat, lon];
    }
    double dLat = transformLat(lon - 105.0, lat - 35.0);
    double dLon = transformLon(lon - 105.0, lat - 35.0);
    double radLat = lat / 180.0 * pi;
    double magic = sin(radLat);
    magic = 1 - ee * magic * magic;
    double sqrtMagic = sqrt(magic);
    dLat = (dLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * pi);
    dLon = (dLon * 180.0) / (a / sqrtMagic * cos(radLat) * pi);
    double mgLat = lat + dLat;
    double mgLon = lon + dLon;
    return [mgLat, mgLon];
  }

  static bool outOfChina(double lat, double lon) {
    if (lon < 72.004 || lon > 137.8347) return true;
    if (lat < 0.8293 || lat > 55.8271) return true;
    return false;
  }

  /// 84 to 火星坐标系 (GCJ-02) World Geodetic System ==> Mars Geodetic System
  ///
  /// @param lat
  /// @param lon
  /// @return

  static List<double> gps84_To_Gcj02(double lat, double lon) {
    if (outOfChina(lat, lon)) {
      return [lat, lon];
    }
    double dLat = transformLat(lon - 105.0, lat - 35.0);
    double dLon = transformLon(lon - 105.0, lat - 35.0);
    double radLat = lat / 180.0 * pi;
    double magic = sin(radLat);
    magic = 1 - ee * magic * magic;
    double sqrtMagic = sqrt(magic);
    dLat = (dLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * pi);
    dLon = (dLon * 180.0) / (a / sqrtMagic * cos(radLat) * pi);
    double mgLat = lat + dLat;
    double mgLon = lon + dLon;
    return [mgLat, mgLon];
  }

  /// * 火星坐标系 (GCJ-02) to 84 * *  @param lon * @param lat * @return
  static List<double> gcj02_To_Gps84(double lat, double lon) {
    List<double> gps = transform(lat, lon);
    double lontitude = lon * 2 - gps[1];
    double latitude = lat * 2 - gps[0];
    return [latitude, lontitude];
  }

  /// 火星坐标系 (GCJ-02) 与百度坐标系 (BD-09) 的转换算法 将 GCJ-02 坐标转换成 BD-09 坐标
  ///
  /// @param lat
  /// @param lon
  static List<double> gcj02_To_Bd09(double lat, double lon) {
    double x = lon, y = lat;
    double z = sqrt(x * x + y * y) + 0.00002 * sin(y * x_pi);
    double theta = atan2(y, x) + 0.000003 * cos(x * x_pi);
    double tempLon = z * cos(theta) + 0.0065;
    double tempLat = z * sin(theta) + 0.006;
    List<double> gps = [tempLat, tempLon];
    return gps;
  }

  /// * 火星坐标系 (GCJ-02) 与百度坐标系 (BD-09) 的转换算法 * * 将 BD-09 坐标转换成GCJ-02 坐标
  /// @param lat
  /// @param lon
  /// @return
  static List<double> bd09_To_Gcj02(double lat, double lon) {
    double x = lon - 0.0065, y = lat - 0.006;
    double z = sqrt(x * x + y * y) - 0.00002 * sin(y * x_pi);
    double theta = atan2(y, x) - 0.000003 * cos(x * x_pi);
    double tempLon = z * cos(theta);
    double tempLat = z * sin(theta);
    List<double> gps = [tempLat, tempLon];
    return gps;
  }

  /// 将gps84转为bd09
  ///
  /// @param lat
  /// @param lon
  /// @return
  static List<double> gps84_To_bd09(double lat, double lon) {
    List<double> gcj02 = gps84_To_Gcj02(lat, lon);
    List<double> bd09 = gcj02_To_Bd09(gcj02[0], gcj02[1]);
    return bd09;
  }

  ///type 0-WGS84  1-GCJ02  2-BD09
  static List<double> parseTypeToBd09(double lat, double lon,String type) {
    List<double> bd09 = [];
    if(type == "0"){
      bd09 = gps84_To_bd09(lat,lon);
    }
    if(type == "1"){
      bd09 = gcj02_To_Bd09(lat,lon);
    }
    if(type == "2"){
      bd09.add(lat);
      bd09.add(lon);
    }

    return bd09;
  }
  ///type 0-WGS84  1-GCJ02  2-BD09
  static List<double> parseTypeToGcj02(double lat, double lon,String type) {
    List<double> gcj02 = [];
    if(type == "0"){
      gcj02 = gps84_To_Gcj02(lat,lon);
    }
    if(type == "1"){
      gcj02.add(lat);
      gcj02.add(lon);
    }
    if(type == "2"){
      gcj02 = bd09_To_Gcj02(lat,lon);
    }

    return gcj02;
  }


  static List<double> bd09_To_gps84(double lat, double lon) {
    List<double> gcj02 = bd09_To_Gcj02(lat, lon);
    List<double> gps84 = gcj02_To_Gps84(gcj02[0], gcj02[1]);
    //保留小数点后六位
    gps84[0] = retain6(gps84[0]);
    gps84[1] = retain6(gps84[1]);
    return gps84;
  }

  /// 保留小数点后六位
  ///
  /// @param double
  /// @return
  static double retain6(double n) {
    return double.parse(n.toStringAsFixed(6));
  }
}