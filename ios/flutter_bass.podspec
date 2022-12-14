#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_bass.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_bass'
  s.version          = '0.0.1'
  s.summary          = 'A Flutter plugin to use the un4seen BASS audio library'
  s.description      = <<-DESC
A new Flutter plugin to allow the use of the un4seen Developments BASS audio library
in Flutter projects.
                       DESC
  s.homepage         = 'https://github.com/JimTompkins/flutter_bass'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Jim Tompkins' => 'jim.tompkins@gmail.com' }

  # This will ensure the source files in Classes/ are included in the native
  # builds of apps using this FFI plugin. Podspec does not support relative
  # paths, so Classes contains a forwarder C file that relatively imports
  # `../src/*` so that the C sources can be shared among all target platforms.
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '12.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  # These next two lines work for the flutter_bass example app, but not for the happy_feet_app because the
  # relative path does not find the libbass.a file
  #s.pod_target_xcconfig = {'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386', "OTHER_LDFLAGS" => '-force_load $SRCROOT/../../../ios/bass24-ios/bass.xcframework/ios-arm64_armv7_armv7s/libbass.a -framework AudioToolbox -framework CFNetwork -framework AVFoundation -framework JavaScriptCore -framework Accelerate' }
  #s.vendored_libraries = '$SRCROOT/../../../ios/bass24-ios/bass.xcframework/ios-arm64_armv7_armv7s/libbass.a'
  
  # These next two lines do not work since the podspec cannot have absolute path names.
  #s.pod_target_xcconfig = {'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386', "OTHER_LDFLAGS" => '-force_load /Users/jimtompkins/git/flutter_bass/ios/bass24-ios/bass.xcframework/ios-arm64_armv7_armv7s/libbass.a -framework AudioToolbox -framework CFNetwork -framework AVFoundation -framework JavaScriptCore -framework Accelerate' }
  #s.vendored_libraries = '/Users/jimtompkins/git/flutter_bass/ios/bass24-ios/bass.xcframework/ios-arm64_armv7_armv7s/libbass.a'
  
  # These next two lines try a relative path but one that will work for happy_feet_app in a parallel 
  # folder to flutter_bass
  s.pod_target_xcconfig = {'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386', "OTHER_LDFLAGS" => '-force_load $SRCROOT/../../../flutter_bass/ios/bass24-ios/bass.xcframework/ios-arm64_armv7_armv7s/libbass.a -framework AudioToolbox -framework CFNetwork -framework AVFoundation -framework JavaScriptCore -framework Accelerate' }
  s.vendored_libraries = '$SRCROOT/../../../flutter_bass/ios/bass24-ios/bass.xcframework/ios-arm64_armv7_armv7s/libbass.a'
  
  s.swift_version = '5.0'

  s.preserve_paths = 'bass.xcframework/**/*'
  s.xcconfig = { 'OTHER_LD_FLAGS' => '-framework bass'}
  s.vendored_frameworks = 'bass.xcframework'
end
