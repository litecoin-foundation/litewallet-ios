source 'https://github.com/CocoaPods/Specs.git'
workspace 'loafwallet.xcworkspace'
project 'loafwallet.xcodeproj', 'Debug' => :debug,'Release' => :release
use_frameworks!
platform :ios, '13.0'

#Shared Cocoapods
def shared_pods 
  pod 'UnstoppableDomainsResolution', '~> 0.3.0'
  pod 'KeychainAccess', '~> 4.2'
  pod 'Firebase/Analytics', '~> 6.0'
  pod 'Firebase/Crashlytics', '~> 6.0'
  # add pod 'SwiftLint'
end

target 'loafwallet' do
    shared_pods
    target 'loafwalletTests' do
      inherit! :search_paths
    end
end

#Setting the Cocoapods config
post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
    config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '10.0'
  end
end
