Pod::Spec.new do |s|
  s.name         = "DOLabel"
  s.version      = "1.0"
  s.summary      = "UILabel replacement for macOS"
  s.homepage     = "https://github.com/docterd/dolabel"
  s.license      = { :type => "MIT" }
  s.author       = { "Dennis Oberhoff" => "dennis@@obrhoff.de" }
  s.source       = { :git => "https://github.com/docterd/dolabel.git", :tag => "1.0"}
  s.source_files  = "Classes", "Classes/*.{swift}"
  s.osx.deployment_target  = '10.11'
  s.osx.framework  = 'AppKit'
  s.swift_version = '4.0'
end
