class Core

  def self.implements(object, interface)
    new(object, interface).send(:validate_ducktype)
  end

  private

  def initialize(duck, interface)
    self.duck = duck
    self.interface = interface
  end

  def validate_ducktype
    check_method_implementation(get_methods interface.methods )
    check_method_implementation(get_methods(interface.instance_methods, true), true)
  end

  def check_method_implementation(methods, instance = false)
    methods.each do |method|
      raise "object does not respond to '#{method.name}'" unless instance ? duck.method_defined?(method.name) : duck.respond_to?(method.name)
    end
  end

  attr_accessor :duck, :interface

  def get_methods(methods, instance = false)
    (methods - Object.methods).map do |method_name|
      instance ? interface.public_instance_method(method_name) : interface.public_method(method_name)
    end
  end
end