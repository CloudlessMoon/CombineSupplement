Pod::Spec.new do |s|
    s.name                  = "CombineSupplement"
    s.version               = "2.0.0"
    s.summary               = "Combine Supplement"
    s.homepage              = "https://github.com/CloudlessMoon/CombineSupplement"
    s.license               = "MIT"
    s.author                = "CloudlessMoon"
    s.source                = { :git => "https://github.com/CloudlessMoon/CombineSupplement.git", :tag => "#{s.version}" }
    s.platform              = :ios, "13.0"
    s.swift_versions        = ["5.1"]
    s.requires_arc          = true
    s.framework             = "Combine"

    # Core dependency
    s.dependency "ThreadSafe", "~> 1.0"

    s.subspec "Core" do |ss|
        ss.source_files = "Sources/Core/**/*.{swift}"
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

    s.subspec "Extension" do |ss|
        ss.source_files = "Sources/Extension/**/*.{swift}"
        ss.dependency "CombineSupplement/Core"
    end
end
