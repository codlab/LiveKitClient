Pod::Spec.new do |spec|
  spec.name = "LiveKitClient"
  spec.version = "2.0.9"
  spec.summary = "LiveKitClient Swift Client SDK. Easily build live audio or video experiences into your mobile app, game or website."
  spec.homepage = "https://github.com/codlab/LiveKitClient"
  spec.license = {:type => "Apache 2.0", :file => "LICENSE"}
  spec.author = "LiveKit"

  base_dir = "LiveKitClient/"

  spec.ios.deployment_target = "13.0"
  spec.osx.deployment_target = "10.15"

  spec.swift_versions = ["5.7"]
  spec.source = {:git => "https://github.com/codlab/LiveKitClient.git", :tag => "2.0.11"}

  spec.source_files = "LiveKitClient/Sources/**/*"

  spec.dependency("LiveKitWebRTC", "~> 114.5735.18")
  spec.dependency("SwiftProtobuf")
  spec.dependency("Logging")
  # spec.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  # spec.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }

  spec.resource_bundles = {"Privacy" => ["Sources/LiveKit/PrivacyInfo.xcprivacy"]}
end
