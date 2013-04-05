require "adequack/version"
require "adequack/core"


module Adequack
  def self.check_implementation(duck, interface)
    Core.implements duck, interface
  end
end
