module Adequack
  class Proxy

    def initialize(target, interfaces)
      self.target = target
      self.interfaces = interfaces
    end

    private

    attr_accessor :target, :interfaces

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
        opt_m =
          target_method.parameters.select { |m| [:opt, :key].include? m.first }

        if args.size > (req_m.size + opt_m.size)
          raise InterfaceImplementationError,
            "definition of method '#{name}' differs in parameters accepted."
        end
      end
    end

    def check_method_existence(method)
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
      cm, im = [], []

      interfaces.each do |interface|
        cm += interface.methods.map { |m| interface.public_method(m) }
        im += interface.instance_methods.map { |m| interface.public_instance_method(m) }
      end

      cm + im
    end
  end
end

