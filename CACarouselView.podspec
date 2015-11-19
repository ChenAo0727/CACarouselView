
Pod::Spec.new do |s|
  s.name         = "CACarouselView"
  s.version      = "0.0.1"
  s.summary      = "A carousel view automatically show ad in infinite loop"
  s.description  = <<-DESC
                   A longer description of CACarouselView in Markdown format.

                   * Think: Why did you write this? What is the focus? What does it do?
                   * CocoaPods will be using this to generate tags, and improve search results.
                   * Try to keep it short, snappy and to the point.
                   * Finally, don't worry about the indent, CocoaPods strips it!
                   DESC

  s.homepage     = "https://github.com/ChenAo0727/CACarouselView"
  s.license      = "MIT (example)"
  s.author             = { "" => "jim735410965@126.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "http://ChenAo0727/CACarouselView.git", :tag => "0.0.1" }
  s.source_files  = "CACarouselViewDemo/CACarouselView/**/*"
  s.frameworks = 'UIKit'
  s.dependency 'SDWebImage', '~> 3.7.2'
  s.requires_arc = true
end
