Pod::Spec.new do |s|
  s.name = "DOLabel"
  s.version = "1.1"
  s.summary = "UILabel replacement for macOS"
  s.homepage = "https://github.com/docterd/dolabel"
  s.license = { :type => "MIT" }
  s.author = { "Dennis Oberhoff" => "dennis@obrhoff.de" }
  s.source = { :git => "https://github.com/docterd/dolabel.git", :tag => "1.1"}
  s.source_files = "Classes/DOLabel.swift", "Classes/DOLayer.swift"
  s.ios.source_files = "Classes/DOLabel-iOS.swift"
  s.osx.source_files = "Classes/DOLabel-OSX.swift"
  s.osx.deployment_target  = '10.11'
  s.osx.framework  = 'AppKit'
  s.ios.deployment_target = "8.0"
  s.ios.framework  = 'UIKit'
  s.swift_version = '4.0'
end
