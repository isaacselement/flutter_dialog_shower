#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_dialog_shower.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_dialog_shower'
  s.version          = '0.0.1'
  s.summary          = 'flutter_dialog_shower'
  s.description      = <<-DESC
Flutter keyboard visibility
                       DESC
  s.homepage         = 'https://github.com/isaacselement/flutter_dialog_shower'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Jason Rai' => 'suchavision@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Runner/**/*.m'
  s.public_header_files = 'Runner/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '8.0'

  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
end
