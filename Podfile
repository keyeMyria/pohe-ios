platform :ios, '11.0'
use_frameworks!

def common_pods
  pod 'RxSwift',    '~> 4.0'
  pod 'RxCocoa'
  pod 'LicensePlist'
  pod 'SwiftLint'
  pod 'SnapKit', '~> 4.0.0'
  pod 'Nuke', '~> 5.0'
  pod 'SwiftGen'
  pod 'Reusable'
  pod 'APIKit', :git => 'https://github.com/ishkawa/APIKit', :branch => 'master'
  pod 'XLPagerTabStrip', '~> 8.0.1'
  pod 'RealmSwift', '~> 3.1.1'
  pod 'Firebase/Core'
  pod 'Firebase/Messaging'
  pod 'Firebase/Performance'
  pod 'Firebase/Crash'
  pod 'Fabric', '~> 1.7.2'
  pod 'Crashlytics', '~> 3.9.3'
end

target 'pohe-ios' do
  common_pods
end

target 'pohe-iosUITests' do
  common_pods
end

post_install do | installer |
    require 'fileutils'
    FileUtils.cp_r('Pods/Target Support Files/Pods-pohe-ios/Pods-pohe-ios-acknowledgements.plist', 'pohe-ios/Settings.bundle/Acknowledgements.plist', :remove_destination => true)
    
end
