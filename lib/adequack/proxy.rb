module Adequack
  class Proxy

    def initialize(target, interface)
      self.target = target
      self.interface = interface
    end

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

    private

    attr_accessor :target, :interface

    def method_missing(name, *args, &block)
      check_interface_implementation name, args
      target.send name, *args, &block
    end

    def check_interface_implementation(name, args)
      check_interface_signature(name, args) if method_in_interface?(name)
    end

    def check_interface_signature(name, args)
      target_method = duck_type_methods.select { |m| m.name == name }.first
      req_m = target_method.parameters.select { |m| m.first == :req }

      if args.size < req_m.size
        raise InterfaceImplementationError,
          "definition of method '#{name}' differs in parameters accepted."
      end

      unless target_method.parameters.any? { |m| m.first == :rest }
        opt_m = target_method.parameters.select { |m| m.first == :opt }

        if args.size > (req_m.size + opt_m.size)
          raise InterfaceImplementationError,
            "definition of method '#{name}' differs in parameters accepted."
        end
      end
    end

    def check_method_existence(method)
      #binding.pry
      unless method_in_interface? method
        raise InterfaceImplementationError,
          "trying to stub nonexistent method"
      end
    end

    def method_in_interface?(method)
      duck_type_methods.map(&:name).include? method.to_sym
    end

    def duck_type_methods
      @duck_type_methods ||= get_methods
    end

    def get_methods
      cm = interface.methods.map do |m|
        interface.public_method(m)
      end

      im = interface.instance_methods.map do |m|
        interface.public_instance_method(m)
      end

      cm + im
    end
  end
end

