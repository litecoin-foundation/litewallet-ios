# Uncomment the next line to define a global platform for your project
source 'https://github.com/CocoaPods/Specs.git'
workspace 'Litewallet.xcworkspace'
project 'Litewallet.xcodeproj', 'Development' => :debug,'Release' => :release
use_frameworks!


#Shared Cocopods
def shared_pods
  #Add when they debug for iOS v12: pod 'Mixpanel-swift' | KCW Oct 4,2018
 pod 'Alamofire', '~> 4.7'
end

def shared_watchOS_pods
end

target 'Litewallet' do
  platform :ios, '10.0'
  shared_pods  
end

target 'Litewallet-dev' do
  platform :ios, '10.0'
  shared_pods
  
  target 'LitewalletTests' do
    inherit! :search_paths
  end
  
  target 'LitewalletUITests' do
    inherit! :search_paths
  end
  
end

