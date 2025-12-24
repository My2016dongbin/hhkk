import 'package:dio/dio.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/pages/common/common_data.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhLog.dart';

/// 请求方法:枚举类型
enum DioMethod {
  get,
  post,
  put,
  delete,
  patch,
  head,
}

// 创建请求类：封装dio
// var result = await HhHttp().request("",method: DioMethod.get,data: {},);
class HhHttp {
  /// 单例模式
  static HhHttp? _instance;

  // 工厂函数：执行初始化
  factory HhHttp() => _instance ?? HhHttp._internal();

  // 获取实例对象时，如果有实例对象就返回，没有就初始化
  static HhHttp? get instance => _instance ?? HhHttp._internal();

  /// Dio实例
  static Dio _dio = Dio();

  /// 初始化
  HhHttp._internal() {
    // 初始化基本选项
    BaseOptions options = BaseOptions(
        baseUrl: 'http://你的服务器地址',
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15));
    _instance = this;
    // 初始化dio
    _dio = Dio(options);
    // 添加拦截器
    _dio.interceptors.add(InterceptorsWrapper(
        onRequest: _onRequest, onResponse: _onResponse, onError: _onError));
  }

  /// 请求拦截器
  void _onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // 对非open的接口的请求参数全部增加userId
    // if (!options.path.contains("open")) {
    //   options.queryParameters["userId"] = "xxx";
    // }
    // 头部添加token
    // options.headers["token"] = "xxx";
    options.headers["Tenant-Id"] = "${CommonData.tenant}";
    options.headers["tenant-user-type"] = "${CommonData.tenantUserType}";
    options.headers["Authorization"] = "Bearer ${CommonData.token}";
    options.headers["RequestResource"] = "kakouApp";
    // HhLog.d("-----------${options.headers}");
    // 更多业务需求
    handler.next(options);
    // super.onRequest(options, handler);
  }

  /// 相应拦截器
  void _onResponse(
      Response response, ResponseInterceptorHandler handler) async {
    // 请求成功是对数据做基本处理
    if (response.statusCode == 200) {
      // 处理成功的响应
      // print("响应结果: $response");
    } else {
      // 处理异常结果
      HhLog.e("响应异常");
      EventBusUtil.getInstance().fire(HhToast(title: '服务器状态异常请稍后重试'));
      EventBusUtil.getInstance().fire(HhLoading(show: false));
    }
    handler.next(response);
  }

  /// 错误处理: 网络错误等
  void _onError(DioException error, ErrorInterceptorHandler handler) {
    handler.next(error);
  }

  /// 请求类：支持异步请求操作
  Future<T> request<T>(
      String path, {
        DioMethod method = DioMethod.get,
        Map<String, dynamic>? params,
        dynamic data,
        CancelToken? cancelToken,
        Options? options,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress,
      }) async {
    const methodValues = {
      DioMethod.get: 'get',
      DioMethod.post: 'post',
      DioMethod.put: 'put',
      DioMethod.delete: 'delete',
      DioMethod.patch: 'patch',
      DioMethod.head: 'head'
    };
    // 默认配置选项
    options ??= Options(method: methodValues[method]);
    try {
      Response response;
      // 开始发送请求
      response = await _dio.request(path,
          data: data,
          queryParameters: params,
          cancelToken: cancelToken,
          options: options,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress);
      if(parse401('${response.data}')){
        CommonUtils().tokenDown();
      }
      return response.data;
    } on DioException catch (e) {
      HhLog.e("发送请求异常: $e");
      EventBusUtil.getInstance().fire(HhLoading(show: false));
      EventBusUtil.getInstance().fire(HhToast(title: '服务器异常请稍后重试'));
      return {"msg": "服务器异常请稍后重试"} as T;
    }
  }

  /// 开启日志打印
  /// 需要打印日志的接口在接口请求前 Request.instance?.openLog();
  void openLog() {
    _dio.interceptors
        .add(LogInterceptor(responseHeader: false, responseBody: true));
  }

  bool parse401(String data) {
    String str = "";
    try{
      str = data.substring(0,10);
    }catch(e){
      HhLog.e(e.toString());
    }
    return str.contains("401");
  }
}