Pod::Spec.new do |spec|
  spec.name             = 'RMRoute'
  spec.version          = '0.9'
  spec.license          = { :type => 'Apache License, Version 2.0', :file => 'LICENSE' }
  spec.homepage         = 'https://github.com/roadmaptravel/RMRoute'
  spec.authors          = { 'Roadmap' => 'appledevelopment@getroadmap.com' }
  spec.summary          = 'A lightweight implementation to use routes in your application.'
  spec.source           = { :git => 'https://github.com/roadmaptravel/RMRoute.git', :tag => spec.version.to_s }
  spec.ios.source_files = 'RMRoute/Source/*.*'
  spec.ios.requires_arc = true
  spec.ios.deployment_target = '8.0'
end