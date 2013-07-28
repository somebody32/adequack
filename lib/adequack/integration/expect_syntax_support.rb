module RSpec
  module Expectations
    class ExpectationTarget

      def to(matcher = nil, message = nil, &block)
        matcher_message = get_affected_message(matcher)

        if matcher.kind_of?(RSpec::Mocks::Matchers::HaveReceived) && @target.kind_of?(Adequack::RspecProxy)
          @target = @target.instance_variable_get(:"@target")
        end

        if @target.kind_of?(Adequack::RspecProxy) && matcher_message
          @target.send(
            :check_method_existence,
            matcher.instance_variable_get(:"@#{matcher_message}"))

        end

        prevent_operator_matchers(:to, matcher)
        RSpec::Expectations::PositiveExpectationHandler
          .handle_matcher(
            @target,
            matcher,
            message,
            &block
          )
      end

      private

      def get_affected_message(matcher)
        if matcher.kind_of? RSpec::Mocks::Matchers::Receive
          "message"
        end
      end
    end
  end
end
