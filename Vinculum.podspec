Pod::Spec.new do |s|
  s.name             = 'Vinculum'
  s.version          = '0.1.0'
  s.summary          = 'A simple iOS Keychain manager'

  s.description      = <<-DESC
A simple iOS Keychain manager for secure storage.
                       DESC

  s.homepage         = 'https://github.com/jmelberg/vinculum'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'jmelberg' => 'jordan.melberg@gmail.com' }
  s.source           = { :git => 'https://github.com/jmelberg/vinculum.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'Vinculum/**/*.{h,m,swift}'
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '3.2' }
end
