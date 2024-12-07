# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Teome (iOS)' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Teome (iOS)
  pod 'FirebaseCore'
  pod 'FirebaseFirestore'
  pod 'Firebase/Analytics'

  # pod 'WiFiQRCodeKit', '~> 1.0'

  
  ENV['COCOAPODS_DISABLE_STATS'] = 'true'

  def fix_config_development_team(config)
    # https://github.com/CocoaPods/CocoaPods/issues/8891
    if config.build_settings['DEVELOPMENT_TEAM'].nil?
      config.build_settings['DEVELOPMENT_TEAM'] = 'T7562M4U35'
    end
  end

  post_install do |installer|
    installer.pods_project.targets.each do |target|
      if target.name == 'BoringSSL-GRPC'
        target.source_build_phase.files.each do |file|
          if file.settings && file.settings['COMPILER_FLAGS']
            flags = file.settings['COMPILER_FLAGS'].split
            flags.reject! { |flag| flag == '-GCC_WARN_INHIBIT_ALL_WARNINGS' }
            file.settings['COMPILER_FLAGS'] = flags.join(' ')
          end
        end
      end
      target.build_configurations.each do |config|
        # Fix FirebaseUI compile error
        # https://github.com/CocoaPods/CocoaPods/issues/12012#issuecomment-1653051943
        xcconfig_path = config.base_configuration_reference.real_path
        xcconfig = File.read(xcconfig_path)
        xcconfig_mod = xcconfig.gsub(/DT_TOOLCHAIN_DIR/, "TOOLCHAIN_DIR")
        File.open(xcconfig_path, "w") { |file| file << xcconfig_mod }

        # Hide pie warnings
        # https://stackoverflow.com/a/54786324/827047
        config.build_settings['LD_NO_PIE'] = 'NO'

        # Silence Xcode deployment target warning
        # https://github.com/CocoaPods/CocoaPods/issues/9884
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '16.0'
      end
    end

    installer.generated_projects.each do |project|
      project.build_configurations.each do |config|
        fix_config_development_team(config)
      end
      project.targets.each do |target|
        target.build_configurations.each do |config|
          fix_config_development_team(config)
        end
      end
    end
  end
end

target 'Teome (macOS)' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Teome (macOS)
  pod 'Firebase/Firestore'

end
