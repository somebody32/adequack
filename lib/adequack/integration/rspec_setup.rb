module Adequack
  module Integration
    module RSpecHelpers
      def behavioral_double(object, interface)
        Adequack.double object, interface
      end

      def adequack_double(object, interface)
        Adequack::Integration::RSpecHelpers.
          deprecation_warning("adequack_double", "behavioral_double")
        Adequack.double object, interface
      end

      class << self
        def deprecation_warning(old_method, new_method)
          warning = "DEPRECATION: '#{old_method}' is deprecated."\
                    " Please use `#{new_method}` instead."

          warn warning
        end
      end
    end
  end
end

RSpec::Matchers.define :behave_like do |*expected_duck_types|
  expected_duck_types.each do |expected_duck_type|
    match do |actual|
      Adequack.check_implementation(actual, expected_duck_type)
    end
  end
end

RSpec::Matchers.define :be_adequack_to do |*expected_duck_types|
  Adequack::Integration::RSpecHelpers.
    deprecation_warning("be_adequack_to", "behave_like")

  expected_duck_types.each do |expected_duck_type|
    match do |actual|
      Adequack.check_implementation(actual, expected_duck_type)
    end
  end
end

RSpec.configure do |config|
  config.include Adequack::Integration::RSpecHelpers
end
