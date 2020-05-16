Pod::Spec.new do |s|
  s.name = "SwimplyLabel"
  s.version = "2.1"
  s.summary = "UILabel replacement for iOS and macOS"
  s.homepage = "https://github.com/docterd/SwimplyCache"
  s.license = { :type => "MIT" }
  s.author = { "Dennis Oberhoff" => "dennis@obrhoff.de" }
  s.source = { :git => "https://github.com/docterd/SwimplyLabel.git", :tag => "2.1"}
  s.source_files = "Sources/SwimplyCache/SwimplyCache.swift"
  s.osx.deployment_target  = '10.12'
  s.osx.framework  = 'AppKit'
  s.ios.deployment_target = "10.0"
  s.ios.framework = 'UIKit'
  s.tvos.deployment_target = "10.0"
  s.tvos.framework = 'UIKit'
  s.swift_version = '5.0'
  s.source = { :git => "https://github.com/docterd/swimplycache.git", :tag => "1.0.0"}
  s.dependency 'SwimplyCache', "= 1.0.0"
end
