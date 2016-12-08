Pod::Spec.new do |spec|
  spec.name             = 'RMRoute'
  spec.version          = '0.3'
  spec.license      = { :type => 'Apache License, Version 2.0', :text => <<-LICENSE
    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at
    http://www.apache.org/licenses/LICENSE-2.0
    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
    LICENSE
  }
  spec.homepage         = 'https://github.com/roadmap-travel/RMRoute'
  spec.authors          = { 'Niels Koole' => 'niels@getroadmap.com' }
  spec.summary          = 'A lightweight implementation to use routes in your application.'
  spec.source           = { :git => 'https://github.com/roadmap-travel/RMRoute.git', :tag => spec.version.to_s }
  spec.ios.source_files = 'RMRoute/Source/*.*'
  spec.ios.requires_arc = true
  spec.ios.deployment_target = '8.0'
end