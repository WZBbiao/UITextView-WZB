Pod::Spec.new do |s|
  s.name = "UITextView-WZB"
  s.version = "2.0.0"
  s.summary = "Swift UITextView with placeholder, auto height, and inline image attachments."
  s.homepage = "https://github.com/WZBbiao/UITextView-WZB"
  s.license = "MIT"
  s.author = { "WZBbiao" => "544856638@qq.com" }
  s.platform = :ios, "11.0"
  s.module_name = "WZBTextView"
  s.swift_version = "5.0"
  s.source = { :git => "https://github.com/WZBbiao/UITextView-WZB.git", :tag => s.version }
  s.source_files = "Sources/WZBTextView/**/*.swift"
  s.frameworks = "UIKit"
end
