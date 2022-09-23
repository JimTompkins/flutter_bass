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
  s.platform = :ios, '9.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
