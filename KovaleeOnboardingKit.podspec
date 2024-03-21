Pod::Spec.new do |s|
  s.name             = 'KovaleeOnboardingKit'
  s.version          = '0.10.4'
  s.summary          = 'KovaleeOnboardingKit is an iOS framework that helps you quicly create an onboarding for your app.'
  s.description  = <<-DESC
                     KovaleeOnboardingKit is an iOS framework that helps you quicly create an onboarding for your app. Just create a configuration.json file and feed it into the view and you are good to go.
                   DESC

  s.license          = 'Code is MIT, then custom font licenses.'
  s.homepage         = 'https://github.com/cotyapps/Kovalee-OnboardingKit'
  s.author           = { 'FT' => 'fto@kovalee.app' }

  s.source           = { :git => 'https://github.com/cotyapps/Kovalee-OnboardingKit.git', :tag => "#{s.version}" }

  s.ios.deployment_target = '14.3'
  s.swift_version    = '5.7'
  
  s.source_files     =  "Sources/**/*.swift"
  s.vendored_frameworks = ['Frameworks/OnboardingKit.xcframework', 'Frameworks/Lottie.xcframework']
end
