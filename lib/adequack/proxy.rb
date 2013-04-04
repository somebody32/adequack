class Proxy
  instance_methods.each { |m| undef_method m unless m =~ /(^__|^send$|^object_id$)/ }

  def initialize(target, interface)
    self.target = target
    self.interface = interface
  end

  private

  attr_accessor :target, :interface

  def method_missing(name, *args, &block)
    # puts method_in_interface? name
    check_interface_signature(name, args)
    target.send(name, *args, &block)
  end

  def check_interface_signature(name, args)
    if method_in_interface?(name)
      target_method = duck_type_methods.select { |m| m.name == name }.first
      req_m = target_method.parameters.select { |m| m.first == :req }

      raise "definitions of method '#{name}' differ in parameters accepted." if args.size < req_m.size

      unless target_method.parameters.any? { |m| m.first == :rest }
        opt_m = target_method.parameters.select { |m| m.first == :opt }
        raise "definitions of method '#{name}' differ in parameters accepted." if args.size > (req_m.size + opt_m.size)
      end
    end
  end

  def method_in_interface?(method)
    duck_type_methods.map(&:name).include? method.to_sym
  end

  def duck_type_methods
    @duck_type_methods ||= (interface.instance_methods - Object.methods).map do |method_name|
      interface.public_instance_method(method_name)
    end
  end
end