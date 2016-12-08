Pod::Spec.new do |spec|
  spec.name             = 'RMRoute'
  spec.version          = '0.1'
  spec.license          = { :type => 'BSD' }
  spec.homepage         = 'https://github.com/roadmap-travel/RMRoute'
  spec.authors          = { 'Niels Koole' => 'niels@getroadmap.com' }
  spec.summary          = 'A lightweight implementation to use routes in your application.'
  spec.source           = { :git => 'https://github.com/roadmap-travel/RMRoute.git', :tag => '0.1' }
  spec.source_files     = 'Roadmap/Source/*.*'
  spec.requires_arc     = true
end