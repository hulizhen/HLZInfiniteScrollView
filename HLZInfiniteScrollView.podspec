#
#  Be sure to run `pod spec lint HLZInfiniteScrollView.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "HLZInfiniteScrollView"
  s.version      = "1.0.0"
  s.summary      = "An Objective-C class providing a scroll view which can be scrolled infinitely and automatically."

  s.description  = <<-DESC
                      Infinite scroll view.
                   DESC

  s.homepage     = "https://github.com/hulizhen/HLZInfiniteScrollView"
  s.screenshots  = "https://cloud.githubusercontent.com/assets/2831422/16691969/7bef5aec-4561-11e6-9163-2dae603c0635.gif"

  s.license      = "MIT"
  s.author       = { "Hu Lizhen" => "hulizhen.public@gmail.com" }

  s.platform     = :ios, "7.0"

  s.source       = { :git => "https://github.com/hulizhen/HLZInfiniteScrollView", :tag => "#{s.version}" }
  s.source_files = "HLZInfiniteScrollView", "HLZInfiniteScrollView/HLZInfiniteScrollView.{h,m}"
  s.requires_arc = true

end
