Pod::Spec.new do |s|
  s.name         = 'LYNibBridge'
  s.version      = '1.0.0'
  s.summary      = 'Nib Bridge for iOS and MacOS'
  s.homepage     = 'https://github.com/LustySwimmer/LYNibBridge'
  s.author       = { 'LustySwimmer' => 'lustyswimmer@gmail.com' }
  s.source       = { :git => 'https://github.com/LustySwimmer/LYNibBridge.git', :tag => s.version.to_s }
  s.frameworks   = 'Foundation'
  s.license      = "MIT"
  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.10'
  s.source_files = 'LYNibBridge/*.{h,m}'

end
