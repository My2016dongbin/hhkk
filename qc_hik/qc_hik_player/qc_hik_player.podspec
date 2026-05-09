Pod::Spec.new do |s|
  s.name             = 'qc_hik_player'
  s.version          = '0.1.0'
  s.summary          = 'Flutter plugin for HikIot live stream player on Android and iOS.'
  s.description      = <<-DESC
Flutter plugin for HikIot live stream player on Android and iOS.
                       DESC
  s.homepage         = 'https://openai.com'
  s.license          = { :type => 'MIT' }
  s.author           = { 'qc' => 'qc@example.com' }
  s.source           = { :path => '.' }
  s.source_files     = 'ios/Classes/**/*.{h,m,mm}', 'ios/ThirdParty/HikiotOpenSDK/Core/Custom/**/*.{h,mm}'
  s.public_header_files = 'ios/Classes/**/*.h'
  s.resources        = [
    'ios/ThirdParty/HikiotOpenSDK/Core/lib/EzvizLib/doc/dependency_EZPlayerSDK.ini',
    'ios/ThirdParty/HikiotOpenSDK/Core/lib/EzvizLib/doc/dependency_EZVideoTalk.ini',
    'ios/ThirdParty/HikiotOpenSDK/Core/lib/EzvizLib/res/iOS/**/*'
  ]
  s.preserve_paths   = 'ios/ThirdParty/HikiotOpenSDK/**/*'
  s.vendored_libraries = 'ios/ThirdParty/HikiotOpenSDK/**/*.a'
  s.static_framework = true
  s.platform         = :ios, '12.0'
  s.dependency 'Flutter'
  s.frameworks = 'CoreAudio', 'AVFoundation', 'VideoToolbox', 'CoreMedia', 'GLKit', 'OpenAL', 'AudioToolbox', 'Photos'
  s.libraries = 'c++', 'z', 'bz2', 'iconv'

  header_root = '${PODS_TARGET_SRCROOT}/ios/ThirdParty/HikiotOpenSDK'
  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    'OTHER_LDFLAGS' => '$(inherited) -ObjC -lz -lbz2 -liconv',
    'CLANG_CXX_LANGUAGE_STANDARD' => 'gnu++20',
    'CLANG_CXX_LIBRARY' => 'libc++',
    'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES',
    'HEADER_SEARCH_PATHS' => [
      '"$(inherited)"',
      "\"#{header_root}/AnalyzeData/include\"",
      "\"#{header_root}/Base\"",
      "\"#{header_root}/Core/Custom\"",
      "\"#{header_root}/Core/Custom/Audio\"",
      "\"#{header_root}/Core/lib/EzvizLib/include\"",
      "\"#{header_root}/Core/lib/EzvizOthers/HikSDKs/HCNetSDK\"",
      "\"#{header_root}/Core/lib/EzvizOthers/HikSDKs/HikStreamSDK\"",
      "\"#{header_root}/Core/lib/EzvizOthers/HikSDKs\"",
      "\"#{header_root}/Core/lib/EzvizOthers/include\"",
      "\"#{header_root}/Core/lib/EzvizOthers/include/modules\"",
      "\"#{header_root}/Core/lib/EzvizOthers/include/modules/EZVideoTalk\"",
      "\"#{header_root}/Dependency/HIKIOT\"",
      "\"#{header_root}/EZSDK\"",
      "\"#{header_root}/LANSDK\""
    ].join(' ')
  }

  s.user_target_xcconfig = {
    'OTHER_LDFLAGS' => '$(inherited) -ObjC -lz -lbz2 -liconv'
  }

  s.swift_version = '5.0'
end
