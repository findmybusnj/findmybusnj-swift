# Uncomment this line to define a global platform for your project
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
use_frameworks!

target 'findmybusnj' do

pod 'SwiftyJSON'
pod 'Alamofire', '~> 4.0'
pod 'PKHUD', :git => 'https://github.com/toyship/PKHUD'
pod 'Fabric'
pod 'Crashlytics'

end

target 'findmybusnj-common' do

pod 'SwiftyJSON'
pod 'Alamofire', '~> 4.0'

end

target 'findmybusnj-widget' do

pod 'SwiftyJSON'

end

target 'findmybusnjTests' do

pod 'SwiftyJSON'

end

target 'findmybusnjUITests' do

end

target 'findmybusnj-commonTests' do

pod 'SwiftyJSON'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
    end
  end
end
