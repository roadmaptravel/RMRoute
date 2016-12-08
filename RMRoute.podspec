Pod::Spec.new do |spec|
  spec.name             = 'RMRoute'
  spec.version          = '0.2'
  spec.license          = { :type => 'BSD' }
  spec.homepage         = 'https://github.com/roadmap-travel/RMRoute'
  spec.authors          = { 'Niels Koole' => 'niels@getroadmap.com' }
  spec.summary          = 'A lightweight implementation to use routes in your application.'
  spec.source           = { :git => 'https://github.com/roadmap-travel/RMRoute.git', :tag => spec.version.to_s }
  spec.ios.source_files = 'RMRoute/Source/*.*'
  spec.ios.requires_arc = true
  spec.ios.deployment_target = '8.0'
end