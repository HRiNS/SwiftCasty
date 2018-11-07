Pod::Spec.new do |s|
  s.name             = 'Casty'
  s.version          = '0.3.0'
  s.summary          = 'A simple library to facilitate chromecast sdk integration'

  s.description      = <<-DESC
TODO: Casty used to facilited chromecast sdk integration with your application with few lines of code.
                       DESC

  s.homepage         = 'https://github.com/amirriyadh/Casty'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'amirriyadh' => 'amir.whiz@gmail.com' }
  s.source           = { :git => 'https://github.com/amirriyadh/Casty.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'

  s.source_files = 'Casty/Classes/**/*'
  s.swift_version = '4.0'
  s.dependency 'google-cast-sdk'
  s.static_framework = true
  
end
