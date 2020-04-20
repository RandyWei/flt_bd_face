#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint fltbdface.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'fltbdface'
  s.version          = '1.0.0'
  s.summary          = 'Baidu&#x27;s face recognition SDK encapsulates the flutter version, calls native SDK and interface operations, and returns data to flutter'
  s.description      = <<-DESC
Baidu&#x27;s face recognition SDK encapsulates the flutter version, calls native SDK and interface operations, and returns data to flutter
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '8.0'
  s.vendored_frameworks = 'Libs/FaceSDK/IDLFaceSDK.framework'
  # s.resources = 'Libs/FaceSDK/com.baidu.idl.face.faceSDK.bundle','Libs/FaceSDK/com.baidu.idl.face.model.bundle'

  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
  s.swift_version = '5.0'
end
