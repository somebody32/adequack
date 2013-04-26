module Adequack
  module Integration
    module RSpecHelpers
      def adequack_double(object, interface)
        Adequack.double object, interface
      end
    end
  end
end

RSpec::Matchers.define :adequack_to do |*expected_duck_types|
  expected_duck_types.each do |expected_duck_type|
    match do |actual|
      Adequack.check_implementation(actual, expected_duck_type)
    end
  end
end

RSpec.configure do |config|
  config.include Adequack::Integration::RSpecHelpers
end
