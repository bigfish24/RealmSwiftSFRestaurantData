Pod::Spec.new do |s|
  s.name         = "RealmSwiftSFRestaurantData"
  s.version      = "0.2"
  s.summary      = "San Francisco Restaurant Score Data In Realm"
  s.description  = <<-DESC
Prebuilt Realm dataset composed of San Francisco restaurant scores for Realm Swift
                   DESC
  s.homepage     = "https://github.com/bigfish24/RealmSwiftSFRestaurantData"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Adam Fish" => "af@realm.io" }
  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.9"
  s.source       = { :git => "https://github.com/bigfish24/RealmSwiftSFRestaurantData.git", :tag => "v#{s.version}" }
  s.source_files  = "SFRestaurantScores.swift"
  s.requires_arc = true
  s.dependency "RealmSwift"
  s.resource = "SFRestaurantScores.realm"

end