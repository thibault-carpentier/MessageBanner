#
# Be sure to run `pod lib lint MessageBanner.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "MessageBanner"
  s.version          = "0.1.0"
  s.summary          = "A short description of MessageBanner."
  s.description      = <<-DESC
                       An optional longer description of MessageBanner

                       * Markdown format.
                       * Don't worry about the indent, we strip it!
                       DESC
  s.homepage         = "https://github.com/Loadex/MessageBanner"
  s.screenshots      =     "https://raw.githubusercontent.com/Loadex/MessageBanner/master/Screenshots/MessageBannerErrorType.png", "https://raw.githubusercontent.com/Loadex/MessageBanner/master/Screenshots/MessageBannerWarningType.png" , "https://raw.githubusercontent.com/Loadex/MessageBanner/master/Screenshots/MessageBannerMessageType.png" , "https://raw.githubusercontent.com/Loadex/MessageBanner/master/Screenshots/MessageBannerSuccessType.png"

  s.license          = 'MIT'
  s.author           = { "Thibault Carpentier" => "carpen_t@epitech.eu" }
  s.source           = { :git => "https://github.com/Loadex/MessageBanner.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'MessageBanner/Classes/**/*.{h,m}', 'MessageBanner/Views/**/*.{h,m}'
  s.resources = 'MessageBanner/Ressources/**/*.{png,json}'

  s.public_header_files = 'MessageBanner/Classes/**/*.{h}', 'MessageBanner/Views/**/*.{h}'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'HexColors', '~> 2'
  s.dependency 'FXBlurView', '~> 1.6.1'
end
