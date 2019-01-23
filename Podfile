source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target 'omega' do
    pod 'Alamofire', '~> 4.7'
    pod 'AlamofireImage', '~> 3.3'
    pod 'BEMCheckBox'
    pod 'Fabric'
    pod 'Crashlytics'
end

post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        config.build_settings.delete('CODE_SIGNING_ALLOWED')
        config.build_settings.delete('CODE_SIGNING_REQUIRED')
    end
 end