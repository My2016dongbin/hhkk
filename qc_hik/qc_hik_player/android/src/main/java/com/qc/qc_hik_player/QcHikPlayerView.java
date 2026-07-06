package com.qc.qc_hik_player;

import android.app.Application;
import android.content.Context;
import android.graphics.Bitmap;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;
import android.text.TextUtils;
import android.util.Log;
import android.view.Gravity;
import android.view.SurfaceHolder;
import android.view.SurfaceView;
import android.view.View;
import android.widget.FrameLayout;
import android.widget.TextView;

import androidx.annotation.NonNull;

import com.hikiot.hikiotsdk.HikIotOpenSDK;
import com.hikiot.hikiotsdk.core.HikIotPlayer;
import com.videogo.errorlayer.ErrorInfo;
import com.videogo.openapi.EZConstants;

import java.io.ByteArrayOutputStream;
import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;

public class QcHikPlayerView implements PlatformView, MethodChannel.MethodCallHandler, EventChannel.StreamHandler {
    private static final String TAG = "QcHikPlayerView";
    private static final int ERROR_VERIFY_CODE_NEED = 400035;
    private static final int ERROR_VERIFY_CODE_ERROR = 400036;

    private final Context context;
    private final FrameLayout rootView;
    private final SurfaceView surfaceView;
    private final TextView tipView;
    private final MethodChannel methodChannel;
    private final EventChannel eventChannel;
    private HikIotPlayer player;
    private BusinessPlayParams playParams;
    private boolean surfaceReady;
    private boolean pendingStart;
    private boolean isRealPlaying;
    private boolean isStopping;
    private boolean soundEnabled = true;
    private EventChannel.EventSink eventSink;

    private final Handler playerHandler = new Handler(Looper.getMainLooper()) {
        @Override
        public void handleMessage(@NonNull Message msg) {
            handlePlayerMessage(msg);
        }
    };

    private final SurfaceHolder.Callback surfaceCallback = new SurfaceHolder.Callback() {
        @Override
        public void surfaceCreated(@NonNull SurfaceHolder holder) {
            surfaceReady = true;
            if (player != null) {
                player.setSurfaceHold(holder);
            }
            if (pendingStart) {
                pendingStart = false;
                startRealPlay();
            }
        }

        @Override
        public void surfaceChanged(@NonNull SurfaceHolder holder, int format, int width, int height) {
            if (player != null) {
                player.setSurfaceHold(holder);
            }
        }

        @Override
        public void surfaceDestroyed(@NonNull SurfaceHolder holder) {
            surfaceReady = false;
            pendingStart = isRealPlaying;
            isRealPlaying = false;
        }
    };

    public QcHikPlayerView(Context context, BinaryMessenger messenger, int viewId, Object args) {
        this.context = context;
        methodChannel = new MethodChannel(messenger, "qc_hik_player_view_" + viewId + "/method");
        eventChannel = new EventChannel(messenger, "qc_hik_player_view_" + viewId + "/event");
        methodChannel.setMethodCallHandler(this);
        eventChannel.setStreamHandler(this);
        rootView = new FrameLayout(context);
        surfaceView = new SurfaceView(context);
        tipView = new TextView(context);
        tipView.setGravity(Gravity.CENTER);
        tipView.setText("");
        tipView.setTextSize(16);
        tipView.setVisibility(View.GONE);
        FrameLayout.LayoutParams matchParent = new FrameLayout.LayoutParams(
                FrameLayout.LayoutParams.MATCH_PARENT,
                FrameLayout.LayoutParams.MATCH_PARENT
        );
        rootView.addView(surfaceView, matchParent);
        rootView.addView(tipView, matchParent);
        surfaceView.getHolder().addCallback(surfaceCallback);
        surfaceReady = surfaceView.getHolder().getSurface() != null
                && surfaceView.getHolder().getSurface().isValid();
        bindParams(args);
    }

    private void bindParams(Object args) {
        if (!(args instanceof Map)) {
            sendState("error", "播放参数无效", 0);
            return;
        }
        BusinessPlayParams params = BusinessPlayParams.fromMap((Map<?, ?>) args);
        Object soundValue = ((Map<?, ?>) args).get("soundEnabled");
        soundEnabled = !(soundValue instanceof Boolean) || (Boolean) soundValue;
        if (!params.isValid()) {
            sendState("error", "播放参数缺失", 0);
            return;
        }
        startPlayByBusinessParams(params);
    }

    private void startPlayByBusinessParams(BusinessPlayParams params) {
        playParams = params;
        isStopping = false;
        releasePlayer();
        HikIotOpenSDK.Companion.getInstance().init(
                (Application) context.getApplicationContext(),
                params.tokenAppKey,
                params.httpUrlToken
        );
        HikIotOpenSDK.Companion.getInstance().setDeviceToken(
                params.deviceSerial,
                params.deviceToken
        );
        HikIotOpenSDK.Companion.getInstance().setDeviceToken(
                params.deviceSerial,
                params.channelNo,
                params.deviceGlobalToken,
                params.deviceVideoToken
        );
        ensurePlayer();
        startRealPlay();
    }

    private void ensurePlayer() {
        if (player != null || playParams == null) {
            return;
        }
        player = HikIotOpenSDK.Companion.getInstance()
                .createPlayer(playParams.deviceSerial, playParams.channelNo);
        player.setHandler(playerHandler);
        player.setStreamToken(playParams.streamLiveToken);
        if (surfaceReady) {
            player.setSurfaceHold(surfaceView.getHolder());
        }
    }

    private void startRealPlay() {
        if (player == null || playParams == null || isRealPlaying || isStopping) {
            return;
        }
        player.setStreamToken(playParams.streamLiveToken);
        if (!surfaceReady) {
            pendingStart = true;
            Log.d(TAG, "surface not ready, pending start");
            sendState("connecting", "视频流连接中...", 0);
            return;
        }
        player.setSurfaceHold(surfaceView.getHolder());
        sendState("connecting", "视频流连接中...", 0);
        isRealPlaying = player.startRealPlay();
        if (!isRealPlaying) {
            sendState("error", "startRealPlay 调用失败", 0);
        }
    }

    private void stopRealPlay() {
        if (player == null || isStopping || !isRealPlaying) {
            return;
        }
        isStopping = true;
        try {
            player.stopRealPlay();
        } finally {
            isRealPlaying = false;
            isStopping = false;
            sendState("stopped", "", 0);
        }
    }

    private void releasePlayer() {
        if (player == null) {
            return;
        }
        if (isRealPlaying && !isStopping) {
            isStopping = true;
            try {
                player.stopRealPlay();
            } catch (Exception e) {
                Log.e(TAG, "stopRealPlay on release failed", e);
            } finally {
                isRealPlaying = false;
                isStopping = false;
            }
        }
        player.release();
        player = null;
        isRealPlaying = false;
        pendingStart = false;
        isStopping = false;
    }

    private void handlePlayerMessage(Message msg) {
        switch (msg.what) {
            case EZConstants.EZRealPlayConstants.MSG_REALPLAY_PLAY_SUCCESS:
                setSoundEnabled(soundEnabled);
                sendState("playing", "直播播放成功", 0);
                break;
            case EZConstants.EZRealPlayConstants.MSG_REALPLAY_PLAY_FAIL:
                isRealPlaying = false;
                sendState("error", buildPlayFailText(msg.obj), extractErrorCode(msg.obj));
                break;
            case EZConstants.EZRealPlayConstants.MSG_REALPLAY_PLAY_START:
            case EZConstants.EZRealPlayConstants.MSG_REALPLAY_CONNECTION_START:
            case EZConstants.EZRealPlayConstants.MSG_REALPLAY_CONNECTION_SUCCESS:
                sendState("connecting", "视频流连接中...", 0);
                break;
            default:
                break;
        }
    }

    private int extractErrorCode(Object errorObj) {
        ErrorInfo errorInfo = errorObj instanceof ErrorInfo ? (ErrorInfo) errorObj : null;
        return errorInfo == null ? 0 : errorInfo.errorCode;
    }

    private String buildPlayFailText(Object errorObj) {
        ErrorInfo errorInfo = errorObj instanceof ErrorInfo ? (ErrorInfo) errorObj : null;
        int errorCode = errorInfo == null ? 0 : errorInfo.errorCode;
        if (errorCode == ERROR_VERIFY_CODE_NEED || errorCode == ERROR_VERIFY_CODE_ERROR) {
            return "取流密码错误或缺失";
        }
        return "直播失败: " + errorCode;
    }

    private void sendState(String state, String message, int errorCode) {
        if (eventSink == null) {
            return;
        }
        Map<String, Object> data = new HashMap<>();
        data.put("state", state);
        data.put("message", message);
        data.put("errorCode", errorCode);
        eventSink.success(data);
    }

    @NonNull
    @Override
    public View getView() {
        return rootView;
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        switch (call.method) {
            case "startRealPlay":
                startRealPlay();
                result.success(isRealPlaying);
                break;
            case "stopRealPlay":
                stopRealPlay();
                result.success(true);
                break;
            case "restartPlay":
                stopRealPlay();
                if (player != null) {
                    player.refreshPlay();
                }
                startRealPlay();
                result.success(true);
                break;
            case "capturePicture":
                result.success(capturePictureBytes());
                break;
            case "startLocalRecord":
                String filePath = call.argument("filePath");
                result.success(startLocalRecord(filePath));
                break;
            case "stopLocalRecord":
                result.success(stopLocalRecordInternal());
                break;
            case "setSoundEnabled":
                Boolean enabled = call.argument("enabled");
                boolean setSuccess = setSoundEnabled(enabled != null && enabled);
                result.success(setSuccess);
                break;
            case "disposePlayer":
                releasePlayer();
                result.success(true);
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    private byte[] capturePictureBytes() {
        if (player == null) {
            return null;
        }
        Bitmap bitmap = null;
        ByteArrayOutputStream outputStream = null;
        try {
            bitmap = player.capturePicture();
            if (bitmap == null) {
                return null;
            }
            outputStream = new ByteArrayOutputStream();
            bitmap.compress(Bitmap.CompressFormat.PNG, 100, outputStream);
            return outputStream.toByteArray();
        } catch (Exception e) {
            Log.e(TAG, "capturePicture failed", e);
            return null;
        } finally {
            if (bitmap != null && !bitmap.isRecycled()) {
                bitmap.recycle();
            }
            if (outputStream != null) {
                try {
                    outputStream.close();
                } catch (Exception ignored) {
                }
            }
        }
    }

    private boolean startLocalRecord(String filePath) {
        if (player == null || TextUtils.isEmpty(filePath)) {
            return false;
        }
        try {
            return player.startLocalRecordWithFile(filePath);
        } catch (Exception e) {
            Log.e(TAG, "startLocalRecord failed", e);
            return false;
        }
    }

    private boolean stopLocalRecordInternal() {
        if (player == null) {
            return false;
        }
        try {
            return player.stopLocalRecord();
        } catch (Exception e) {
            Log.e(TAG, "stopLocalRecord failed", e);
            return false;
        }
    }

    private boolean setSoundEnabled(boolean enabled) {
        if (player == null) {
            soundEnabled = enabled;
            return false;
        }
        boolean success = enabled ? player.openSound() : player.closeSound();
        if (success) {
            soundEnabled = enabled;
        }
        return success;
    }

    @Override
    public void onListen(Object arguments, EventChannel.EventSink events) {
        eventSink = events;
    }

    @Override
    public void onCancel(Object arguments) {
        eventSink = null;
    }

    @Override
    public void dispose() {
        surfaceView.getHolder().removeCallback(surfaceCallback);
        methodChannel.setMethodCallHandler(null);
        eventChannel.setStreamHandler(null);
        releasePlayer();
    }

    private static class BusinessPlayParams {
        String tokenAppKey;
        String httpUrlToken;
        String deviceSerial;
        int channelNo;
        String deviceToken;
        String deviceGlobalToken;
        String deviceVideoToken;
        String streamLiveToken;

        static BusinessPlayParams fromMap(Map<?, ?> map) {
            BusinessPlayParams params = new BusinessPlayParams();
            params.tokenAppKey = asString(map.get("tokenAppKey"));
            params.httpUrlToken = asString(map.get("httpUrlToken"));
            params.deviceSerial = asString(map.get("deviceSerial"));
            params.channelNo = asInt(map.get("channelNo"), 1);
            params.deviceToken = asString(map.get("deviceToken"));
            params.deviceGlobalToken = asString(map.get("deviceGlobalToken"));
            params.deviceVideoToken = asString(map.get("deviceVideoToken"));
            params.streamLiveToken = asString(map.get("streamLiveToken"));
            return params;
        }

        boolean isValid() {
            return !TextUtils.isEmpty(tokenAppKey)
                    && !TextUtils.isEmpty(httpUrlToken)
                    && !TextUtils.isEmpty(deviceSerial)
                    && !TextUtils.isEmpty(deviceToken)
                    && !TextUtils.isEmpty(deviceGlobalToken)
                    && !TextUtils.isEmpty(deviceVideoToken)
                    && !TextUtils.isEmpty(streamLiveToken);
        }

        private static String asString(Object value) {
            return value == null ? "" : String.valueOf(value);
        }

        private static int asInt(Object value, int fallback) {
            if (value instanceof Number) {
                return ((Number) value).intValue();
            }
            try {
                return Integer.parseInt(asString(value));
            } catch (Exception ignored) {
                return fallback;
            }
        }
    }
}
