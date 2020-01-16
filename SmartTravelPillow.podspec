Pod::Spec.new do |s|
  s.name             = 'SmartTravelPillow'
  s.version          = '1.1.2'
  s.summary          = '浩雨护颈托枕 iOS SDK'

  s.homepage         = 'http://hykj-global.com'
  s.license          = {
    :type => 'private',
    :text => <<-LICENSE
      Copyright © 北京浩雨科技有限公司 2019-2020 All Right Reserved.
      LICENSE
  }
  s.author           = '浩雨科技'
  s.source           = {
    :http => 'https://github.com/SmartTravelPillow/iOS-SDK/releases/download/1.1.2/Carthage.zip'
  }

  s.requires_arc = true
  s.ios.deployment_target = '9.0'

  s.dependency 'AFNetworking/NSURLSession', '~> 3'
  s.vendored_frameworks = "**/SmartTravelPillow.framework"
end
