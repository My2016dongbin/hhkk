package com.qc.qc_hik_player;

import android.content.Context;

import androidx.annotation.NonNull;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

public class QcHikPlayerFactory extends PlatformViewFactory {
    private final Context context;
    private final BinaryMessenger messenger;

    public QcHikPlayerFactory(Context context, BinaryMessenger messenger) {
        super(StandardMessageCodec.INSTANCE);
        this.context = context;
        this.messenger = messenger;
    }

    @Override
    public PlatformView create(Context ignoredContext, int viewId, Object args) {
        return new QcHikPlayerView(context, messenger, viewId, args);
    }
}
