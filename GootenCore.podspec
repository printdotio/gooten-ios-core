
Pod::Spec.new do |s|
  s.name         = "GootenCore"
  s.version      = "0.0.15"
  s.summary      = "SDK that enables the printing of any photo, from any source, onto any product!"
  s.homepage     = "http://www.gooten.com"
  s.license      = { :type => 'Commercial', :file => 'LICENSE.md' }
  s.author       = { "Gooten" => "boro@gooten.com" }
  s.social_media_url = "https://twitter.com/gooteninc"

  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/printdotio/gooten-ios-core.git", :tag => s.version }
  
  s.module_name = 'GootenCore'
  s.module_map = 'GootenCore.framework/Modules/module.modulemap'
  
  s.vendored_frameworks = 'GootenCore.framework'
  s.preserve_paths = 'GootenCore.framework'
  
  s.source_files = 'GootenCore.framework/Headers/GootenCore-Swift.h', 'GootenCore.framework/Headers/GootenCore.h'
  
  s.xcconfig = {
    'FRAMEWORK_SEARCH_PATHS' => '"${PODS_ROOT}/**"',
  }

end
