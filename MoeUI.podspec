#
# Be sure to run `pod lib lint MoeUI.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MoeUI'
  s.version          = '1.1.1'
  s.summary          = 'MoeUI is a framework that make UI controls create and configure easily'

  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  TODO: Add long description of the pod here.
  DESC

  s.homepage         = 'https://github.com/linyanzuo/MoeUI'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'linyanzuo1222@gmail.com' => 'zed@moemoetech.com' }
  s.source           = { :git => 'https://github.com/linyanzuo/MoeUI.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'
  s.swift_versions = '5.0'

  #  s.source_files = 'MoeUI/Classes/*'
  s.subspec 'Common' do |common|
    common.source_files = 'Classes/Common/*/*'
    common.frameworks = 'UIKit'
  end
  s.subspec 'Runtime' do |runtime|
    runtime.source_files = 'Classes/Runtime/*'
    runtime.frameworks = 'UIKit'
    runtime.dependency 'MoeUI/Common'
  end
  s.subspec 'Appearance' do |appearance|
    appearance.source_files = 'Classes/Appearance/*'
    appearance.frameworks = 'UIKit'
    appearance.dependency 'MoeUI/Common'
    appearance.dependency 'MoeUI/Runtime'
  end
  s.subspec 'PanDrawer' do |drawer|
    drawer.source_files = 'Classes/PanDrawer/*'
    drawer.frameworks = 'UIKit'
    drawer.dependency 'MoeUI/Common'
    drawer.dependency 'MoeUI/Runtime'
  end
#  s.subspec 'Alert' do |alert|
#    alert.source_files = 'Classes/Alert/*'
#    alert.frameworks = 'UIKit'
#    alert.dependency 'MoeUI/Common'
#  end

  # s.resource_bundles = {
  #   'MoeUI' => ['MoeUI/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
