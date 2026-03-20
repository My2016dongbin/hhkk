Pod::Spec.new do |s|
  s.name             = 'qc_amap_navi'
  s.version          = '0.0.1'
  s.summary          = 'AMap Navi Flutter Plugin'
  s.description      = 'AMap Navi Flutter Plugin'
  s.homepage         = 'https://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'qc' => 'qc@qq.com' }
  s.source           = { :path => '.' }

  s.platform         = :ios, '12.0'

  s.dependency 'Flutter'
  s.source_files        = 'Classes/**/*.{h,m,mm}'
  s.public_header_files = 'Classes/**/*.h'

  s.dependency 'AMap3DMap', '8.1.0'
  s.dependency 'AMapNavi', '8.1.0'

  s.frameworks = 'UIKit', 'Foundation', 'CoreGraphics', 'CoreLocation', 'SystemConfiguration', 'Security'
  s.libraries  = 'c++', 'z'

  s.pod_target_xcconfig = {
    'OTHER_LDFLAGS' => '-ObjC',
    'ENABLE_BITCODE' => 'NO'
  }

  s.static_framework = true
end