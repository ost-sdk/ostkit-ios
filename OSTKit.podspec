Pod::Spec.new do |s|
  s.name         = "OSTKit"
  s.version      = "0.0.2"
  s.summary      = "Simple Token API wrapper for iOS"
  s.homepage     = "https://github.com/vanductai/ostkit-ios"
  s.license      = "MIT"
  s.authors             = { "Duong Khong" => "duong1521991@gmail.com" }
  s.social_media_url   = "https://twitter.com/duong1521991"

  s.swift_version = '4.0'
  s.ios.deployment_target = "9.0"
  s.source = { :git => 'https://github.com/vanductai/ostkit-ios.git', :tag => s.version }
  s.source_files  = 'ostkit/Sources/*.swift'
  s.public_header_files = 'ostkit/Sources/*.h'
  s.frameworks = "Alamofire", "CryptoSwift"
end
