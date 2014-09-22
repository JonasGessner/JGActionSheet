Pod::Spec.new do |s|

  s.name         	= "JGActionSheet"
  s.version      	= "1.0.5"
  s.summary      	= "A feature-rich and modern action sheet for iOS."
  s.homepage     	= "https://github.com/JonasGessner/JGActionSheet"
  s.license      	= { :type => "MIT", :file => "LICENSE.txt" }
  s.author            	= "Jonas Gessner"
  s.social_media_url  	= "http://twitter.com/JonasGessner"
  s.platform     	= :ios, "5.0"
  s.source       	= { :git => "https://github.com/JonasGessner/JGActionSheet.git", :tag => "v1.0.5" }
  s.source_files  	= "JGActionSheet/*.{h,m}"
  s.frameworks 		= "Foundation", "UIKit", "QuartzCore"
  s.requires_arc 	= true

end