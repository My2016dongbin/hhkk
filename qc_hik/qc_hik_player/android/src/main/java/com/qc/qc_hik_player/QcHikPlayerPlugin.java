package com.qc.qc_hik_player;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;

public class QcHikPlayerPlugin implements FlutterPlugin {
    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        binding.getPlatformViewRegistry().registerViewFactory(
                "qc_hik_player_view",
                new QcHikPlayerFactory(
                        binding.getApplicationContext(),
                        binding.getBinaryMessenger()
                )
        );
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    }
}
