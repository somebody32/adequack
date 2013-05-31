module Adequack
  class RspecProxy < Proxy

    def stub(message_or_hash, opts = {}, &block)
      methods =
        Hash === message_or_hash ? message_or_hash.keys : [message_or_hash]

      methods.each { |m| check_method_existence m }

      target.stub(message_or_hash, opts, &block)
    end

    alias_method :stub!, :stub

    def stub_chain(*chain, &blk)
      method =
        String === chain.first ? chain.first.split(".").first : chain.first

      check_method_existence method

      target.stub_chain(*chain, &blk)
    end

    def should_receive(message, opts = {}, &block)
      check_method_existence message

      target.should_receive(message, opts, &block)
    end

    def receive(method_name, &block)
      binding.pry
      check_method_existence method_name

      target.receive method_name, &block
    end
  end
end
