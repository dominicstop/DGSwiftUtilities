Pod::Spec.new do |s|

  s.name             = 'DGSwiftUtilities'
  s.version          = '0.44.0'
  s.summary          = 'Swift helpers and utilities'

  s.homepage         = 'https://github.com/dominicstop/DGSwiftUtilities'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Dominic Go' => 'dominic@dominicgo.dev' }
  s.source           = { :git => 'https://github.com/dominicstop/DGSwiftUtilities.git', :tag => s.version.to_s }

  s.ios.deployment_target = '12.0'
  s.swift_version = '5.0'
  s.frameworks = 'UIKit'

  s.source_files = 'Sources/**/*'

end
