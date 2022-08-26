Pod::Spec.new do |s|
  s.name             = 'HalfModal'
  s.version          = '1.7.0'
  s.summary          = 'A reusable modal UISheetPresentationController component for SwiftUI'
  s.homepage         = 'https://github.com/Vong3432/HalfModal'
  s.license          = { :type => 'MIT', :file => 'LICENSE.md' }
  s.author           = { 'Vong Nyuk Soon' => 'https://github.com/Vong3432' }
  s.source           = { :git => 'https://github.com/Vong3432/HalfModal.git', :tag => s.version.to_s }
  s.ios.deployment_target = '14.0'
  s.swift_version = '5.0'
  s.source_files = 'Sources/HalfModal/**/*'
end
