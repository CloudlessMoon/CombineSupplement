Pod::Spec.new do |s|
    s.name                  = "CombineSupplement"
    s.version               = "0.2.3"
    s.summary               = "Combine Supplement"
    s.homepage              = "https://github.com/jiasongs/CombineSupplement"
    s.license               = "MIT"
    s.author                = { "ruanmei" => "jiasong@ruanmei.com" }
    s.source                = { :git => "https://github.com/jiasongs/CombineSupplement.git", :tag => "#{s.version}" }
    s.platform              = :ios, "13.0"
    s.cocoapods_version     = ">= 1.11.0"
    s.swift_versions        = ["5.1"]
    s.static_framework      = true
    s.requires_arc          = true
    s.framework             = "Combine"
    s.pod_target_xcconfig   = { 
        'SWIFT_INSTALL_OBJC_HEADER' => 'NO'
    }

    s.subspec "Core" do |ss|
        ss.source_files = "Sources/Core/**/*.{swift}"
        ss.dependency "ThreadSafe", "~> 1.0"
    end

    s.subspec "Replay" do |ss|
        ss.source_files = "Sources/Replay/**/*.{swift}"
        ss.dependency "CombineSupplement/Core"
    end

    s.subspec "PropertyWrapper" do |ss|
        ss.source_files = "Sources/PropertyWrapper/**/*.{swift}"
        ss.dependency "CombineSupplement/Replay"
    end

    s.subspec "Cancellable" do |ss|
        ss.source_files = "Sources/Cancellable/**/*.{swift}"
        ss.dependency "CombineSupplement/Core"
    end

    s.subspec "Scheduler" do |ss|
        ss.source_files = "Sources/Scheduler/**/*.{swift}"
        ss.dependency "CombineSupplement/Core"
    end
end
