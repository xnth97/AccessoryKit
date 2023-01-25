Pod::Spec.new do |s|
  s.name             = 'AccessoryKit'
  s.version          = '1.0.1'
  s.summary          = 'A customizable, expandable, and easy-to-use input accessory view component for iOS.'

  s.description      = <<-DESC
A customizable, expandable, and easy-to-use input accessory view component for iOS.
                       DESC

  s.homepage         = 'https://github.com/xnth97/AccessoryKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Yubo Qin' => 'xnth97@live.com' }
  s.source           = { :git => 'https://github.com/xnth97/AccessoryKit.git', :tag => s.version.to_s }

  s.ios.deployment_target = '14.0'
  s.swift_version = '5.5'

  s.source_files = 'Sources/AccessoryKit/**/*'
  
  s.frameworks = 'UIKit'

end
