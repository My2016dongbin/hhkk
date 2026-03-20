Pod::Spec.new do |s|
  s.name             = 'amap_flutter_map'
  s.version          = '0.0.1'
  s.summary          = 'A new Flutter plugin.'
  s.description      = <<-DESC
A new Flutter plugin.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }

  s.platform         = :ios, '12.0'
  s.static_framework = true

  s.source_files        = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'

  s.dependency 'Flutter'
  s.dependency 'AMapNavi', '8.1.0'

  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386'
  }
end
