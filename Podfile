# Uncomment this line to define a global platform for your project
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
use_frameworks!

target 'findmybusnj' do

pod 'SwiftyJSON', :git => 'https://github.com/acegreen/SwiftyJSON.git', :branch => 'swift3'
pod 'Alamofire', '~> 4.0'
pod 'PKHUD', '~> 3.0.0'
pod 'Fabric'
pod 'Crashlytics'

end

target 'findmybusnjTests' do

end

target 'findmybusnjUITests' do

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
    end
  end
end