#
# Be sure to run `pod lib lint TYNetworking.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TYNetworking'
  s.version          = '0.1.2'
  s.summary          = '基于 AFNetworking 二次封装。请求上下文释放时，自动取消上下文上的所有请求。'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/againxu/TYNetworking.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '756165690@qq.com' => '756165690@qq.com' }
  s.source           = { :git => 'https://github.com/againxu/TYNetworking.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'TYNetworking/Classes/**/*'
  
  # s.resource_bundles = {
  #   'TYNetworking' => ['TYNetworking/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'AFNetworking','~>3.0'
  s.dependency 'MJExtension'
end
