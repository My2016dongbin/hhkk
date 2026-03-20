package com.qc.qc_amap_navi;

import android.app.Activity;
import android.content.Context;

import androidx.annotation.NonNull;

import com.amap.api.location.AMapLocationClient;
import com.amap.api.location.AMapLocationClientOption;
import com.amap.api.location.AMapLocationListener;
import com.amap.api.location.AMapLocation;

import com.amap.api.maps.model.LatLng;
import com.amap.api.maps.model.Poi;
import com.amap.api.navi.AmapNaviPage;
import com.amap.api.navi.AmapNaviParams;
import com.amap.api.navi.AmapNaviType;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import android.content.Intent;
import com.amap.api.maps.offlinemap.OfflineMapActivity;

public class QcAmapNaviPlugin implements FlutterPlugin, MethodChannel.MethodCallHandler, ActivityAware {
    private MethodChannel channel;
    private Context context;
    private Activity activity;
    private AMapLocationClient locationClient;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        context = flutterPluginBinding.getApplicationContext();
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "flutter_amap_navi");
        channel.setMethodCallHandler(this);

        AMapLocationClient.updatePrivacyShow(context, true, true);
        AMapLocationClient.updatePrivacyAgree(context, true);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        if ("startNavi".equals(call.method)) {
            String fromName = call.argument("fromName");
            String toName = call.argument("toName");
            double fromLat = call.argument("fromLat");
            double fromLng = call.argument("fromLng");
            double toLat = call.argument("toLat");
            double toLng = call.argument("toLng");

            Poi start = new Poi(fromName, new LatLng(fromLat, fromLng), "");
            Poi end = new Poi(toName, new LatLng(toLat, toLng), "");
            AmapNaviParams params = new AmapNaviParams(start, null, end, AmapNaviType.DRIVER, null);

            // 启动导航界面，SDK 自动处理 GPS 定位
            AmapNaviPage.getInstance().showRouteActivity(activity, params, null);

            // 可选：初始化定位（只是为了保证首次定位快）
            startLocationUpdates();

            result.success(null);
        } else if ("openOfflineMap".equals(call.method)) {
            openOfflineMap(result);

        } else {
            result.notImplemented();
        }
    }

    private void startLocationUpdates() {
        try {
            if (locationClient == null) {
                locationClient = new AMapLocationClient(context);
                AMapLocationClientOption option = new AMapLocationClientOption();
                option.setLocationMode(AMapLocationClientOption.AMapLocationMode.Hight_Accuracy);
                option.setInterval(2000);
                option.setNeedAddress(false);
                locationClient.setLocationOption(option);
                locationClient.setLocationListener(new AMapLocationListener() {
                    @Override
                    public void onLocationChanged(AMapLocation location) {
                        if (location != null && location.getErrorCode() == 0) {
                            // 定位成功，可用于调试
                            // Log.d("AMapNavi", "定位成功: " + location.getLatitude() + "," + location.getLongitude());
                        }
                    }
                });
            }
            locationClient.startLocation();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void stopLocationUpdates() {
        if (locationClient != null) {
            locationClient.stopLocation();
            locationClient.onDestroy();
            locationClient = null;
        }
    }

    private void openOfflineMap(@NonNull MethodChannel.Result result) {
        try {
            if (activity == null) {
                result.error("NO_ACTIVITY", "Activity is null", null);
                return;
            }

            Intent intent = new Intent(activity, OfflineMapActivity.class);
            activity.startActivity(intent);
            result.success(null);
        } catch (Exception e) {
            result.error("OPEN_OFFLINE_MAP_FAILED", e.getMessage(), null);
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        activity = binding.getActivity();
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {}

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
        activity = binding.getActivity();
    }

    @Override
    public void onDetachedFromActivity() {
        stopLocationUpdates();
        activity = null;
    }
}
