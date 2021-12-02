
Pod::Spec.new do |spec|
  spec.name = "YDMOfflineAccount"
  spec.version = "1.6.10"
  spec.summary = "A short description of YDMOfflineAccount."
  spec.homepage = "http://yourdev/YDMOfflineAccount"

  spec.license = "MIT"
  spec.author = { "Douglas Hennrich" => "douglashennrich@yourdev.com.br" }

  spec.swift_version = "5.0"
  spec.platform = :ios, "11.0"
  spec.source = {
    :git => "https://github.com/Hennrich-Your-Dev/YDMOfflineAccount.git",
    :tag => "#{spec.version}"
  }

  spec.source_files = [
    "YDMOfflineAccount/**/*.{h,m,swift}",
    "YDMOfflineAccount/**/**/*.{h,m,swift}"
  ]
  spec.resources = [
    "YDMOfflineAccount/**/**/*.{xib,storyboard,json,xcassets,html}",
    "YDMOfflineAccount/**/*.{xib,storyboard,json,xcassets,html}",
    "YDMOfflineAccount/*.{xib,storyboard,json,xcassets,html}"
  ]

  spec.dependency "YDB2WIntegration", "~> 1.6.0"
  spec.dependency "YDUtilities", "~> 1.6.0"
  spec.dependency "YDExtensions", "~> 1.6.0"
  spec.dependency "YDB2WAssets", "~> 1.6.0"
  spec.dependency "YDB2WComponents", "~> 1.6.0"
  spec.dependency "YDMOfflineOrders", "~> 1.6.0"
  spec.dependency "YDB2WServices", "~> 1.6.0"
  spec.dependency "YDQuiz", "~> 1.6.0"
  spec.dependency "YDB2WColors", "~> 1.6.0"
  spec.dependency "YDB2WCustomerIdentifier", "~> 1.6.0"

  spec.dependency "Hero"
end
