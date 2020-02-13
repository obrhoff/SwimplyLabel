Pod::Spec.new do |s|
  s.name = "DOLabel"
  s.version = "2.0"
  s.summary = "UILabel replacement for iOS and macOS"
  s.homepage = "https://github.com/docterd/dolabel"
  s.license = { :type => "MIT" }
  s.author = { "Dennis Oberhoff" => "dennis@obrhoff.de" }
  s.source = { :git => "https://github.com/docterd/dolabel.git", :branch => "feature/performance_improvements"}
  s.source_files = "Sources/DOLabel/DOLabel.swift"
  s.osx.deployment_target  = '10.12'
  s.osx.framework  = 'AppKit'
  s.ios.deployment_target = "10.0"
  s.ios.framework = 'UIKit'
  s.tvos.deployment_target = "10.0"
  s.tvos.framework = 'UIKit'
  s.swift_version = '5.0'
end
