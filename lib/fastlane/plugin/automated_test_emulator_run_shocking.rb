require 'fastlane/plugin/automated_test_emulator_run_shocking/version'

module Fastlane
  module AutomatedTestEmulatorRunShocking
    def self.all_classes
      Dir[File.expand_path('**/{actions,factory,provider}/*.rb', File.dirname(__FILE__))]
    end
  end
end

Fastlane::AutomatedTestEmulatorRunShocking.all_classes.each do |current|
  require current
end


