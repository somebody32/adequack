require "adequack/version"
require "adequack/core"
require "adequack/proxy"
require "adequack/integration/rspec_proxy"
require "adequack/integration/rspec_setup"

module Adequack
  InterfaceImplementationError = Class.new(::StandardError)

  def self.check_implementation(duck, interface)
    Core.implements duck, interface
  end

  def self.double(core, interfaces)
    RspecProxy.new core, interfaces
  end
end
