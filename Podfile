source 'https://github.com/CocoaPods/Specs.git'
workspace 'loafwallet.xcworkspace'
project 'loafwallet.xcodeproj', 'Debug' => :debug,'Release' => :release
use_frameworks!
platform :ios, '13.0'

#Shared Cocopods
def shared_pods 
  pod 'UnstoppableDomainsResolution', '~> 0.3.0'
  pod 'KeychainAccess', '~> 4.2'
  pod 'Firebase/Analytics'
  pod 'Firebase/Crashlytics' 
  # add pod 'SwiftLint' 
end

target 'loafwallet' do
  shared_pods
  
    target 'loafwalletTests' do
      inherit! :search_paths
    end
  
end
