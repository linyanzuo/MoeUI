#
# Be sure to run `pod lib lint MoeUI.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MoeUI'
  s.version          = '0.0.2'
  s.summary          = 'Moe UI Library'

  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  MoeUI is a framework that make UI controls create and configure easily
  DESC

  s.homepage         = 'https://github.com/linyanzuo/MoeUI'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'linyanzuo' => 'zed@moemone.com' }
  s.source           = {
      :git => 'https://github.com/linyanzuo/MoeUI.git', :tag => s.version.to_s
  }

  s.ios.deployment_target = '11.0'
  s.swift_versions = '5.0'

  #  s.source_files = 'MoeUI/Classes/*'
  s.subspec 'Extension' do |extension|
    extension.source_files = 'MoeUI/Classes/Extension/*'
    extension.frameworks = 'UIKit'
  end
  s.subspec 'Unity' do |unity|
    unity.source_files = 'MoeUI/Classes/Unity/*'
    unity.frameworks = 'UIKit'
    unity.dependency 'MoeUI/Extension'
  end
#  暂时关闭该库，待处理
#  s.subspec 'Designator' do |designator|
#    designator.source_files = 'MoeUI/Classes/Designator/*'
#    designator.frameworks = 'UIKit'
#    designator.dependency 'MoeUI/Extension'
#  end
# Appearance已废弃, 使用Designator替代
#  s.subspec 'Appearance' do |appearance|
#    appearance.source_files = 'MoeUI/Classes/Appearance/*'
#    appearance.frameworks = 'UIKit'
#  end
  s.subspec 'PanDrawer' do |drawer|
    drawer.source_files = 'MoeUI/Classes/PanDrawer/*'
    drawer.frameworks = 'UIKit'
  end
#  s.subspec 'Alert' do |alert|
#    alert.source_files = 'MoeUI/Classes/Alert/*'
#    alert.frameworks = 'UIKit'
#    alert.dependency 'MoeUI/Unity'
#    alert.dependency 'MoeUI/Designator'
#  end

# pod库需要携带资源时配置
#  s.resource_bundles = {
#    'MoeUI' => ['MoeUI.xcassets']
#  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
    s.dependency 'MoeCommon', '~> 0.0.1'
end
