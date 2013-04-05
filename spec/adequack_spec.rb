require "spec_helper"

describe Adequack do

  context "when checking implementing interface" do


    let!(:interface) do
      Class.new do
        def self.evolutionize; end
        def bark(what); end
        def eat(tasty = true); end
        def drink(what, many = true); end
        def sleep(how_long, *places); end
      end
    end

    before { Object.send(:remove_const, :Animal) if Object.const_defined?(:Animal)}

    it "passes when test class is ok" do
      class Animal
        def self.evolutionize; end
        def bark(what); end
        def eat(tasty = true); end
        def drink(what, many = true); end
        def sleep(how_long, *places); end
      end

      expect { described_class.check_implementation(Animal, interface) }.not_to raise_error(Adequack::InterfaceImplementationError)
    end

    it "fails when no class method" do
      class Animal
        def bark(what); end
        def eat(tasty = true); end
        def drink(what, many = true); end
        def sleep(how_long, *places); end
      end

      expect { described_class.check_implementation(Animal, interface) }.to raise_error(Adequack::InterfaceImplementationError, "object does not respond to self.evolutionize method")
    end


  end
end
