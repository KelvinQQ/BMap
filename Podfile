platform :ios, '10.0'
use_frameworks!

workspace 'BMap.xcworkspace'


abstract_target 'BMap' do
  
  target 'BMap' do
    platform :ios, '10.0'
    
    project 'App/BMap.xcodeproj'

    pod 'AMap3DMap'
    pod 'AMapSearch'
    pod 'AMapLocation'
    pod 'AMapNavi'
    pod 'SnapKit'
    # pod 'BaiduMapKit'
    # pod 'BMKLocationKit'
    pod 'SlideMenuControllerSwift'
    pod 'BetterSegmentedControl', '~> 1.2'
    pod 'FloatingPanel', '~> 1.6.6'
  end
  
  
  # target 'AIFUser' do
    
  #   project 'AIFUser/AIFUser.xcodeproj'
    
  # end
  
  
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['ENABLE_BITCODE'] = 'NO'
      end
      if target.name == 'SlideMenuControllerSwift'
        target.build_configurations.each do |config|
          config.build_settings['SWIFT_VERSION'] = '4'
        end
      end
      if target.name == 'SnapKit'
        target.build_configurations.each do |config|
          config.build_settings['SWIFT_VERSION'] = '4.2'
        end
      end
    end
  end
end
