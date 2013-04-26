require "adequack/version"
require "adequack/core"
require "adequack/proxy"
require "adequack/integration/rspec_setup"

module Adequack
  InterfaceImplementationError = Class.new(::StandardError)

  def self.check_implementation(duck, interface)
    Core.implements duck, interface
  end

  def self.double(core, interface)
    Proxy.new core, interface
  end
end
