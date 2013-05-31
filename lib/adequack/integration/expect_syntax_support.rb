module RSpec
  module Expectations
    class ExpectationTarget
      def to(matcher = nil, message = nil, &block)
        if @target.kind_of?(Adequack::RspecProxy) && matcher.kind_of?(RSpec::Mocks::Matchers::Receive)
          @target.send(:check_method_existence, matcher.instance_variable_get(:"@message"))
        end

        prevent_operator_matchers(:to, matcher)
        RSpec::Expectations::PositiveExpectationHandler.handle_matcher(@target, matcher, message, &block)
      end
    end
  end
end
