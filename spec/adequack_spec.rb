require "spec_helper"

describe Adequack do

  let!(:interface) do
    Class.new do
      def self.evolutionize; end
      def bark(what); end
      def eat(tasty = true); end
      def drink(what, many = true); end
      def sleep(how_long, *places); end
    end
  end

  before do
    Object.send(:remove_const, :Animal) if Object.const_defined?(:Animal)
  end

  context "when checking interface implementation" do

    it "passes when test class is ok" do
      class Animal
        def self.evolutionize; end
        def bark(what); end
        def eat(tasty = true); end
        def drink(what, many = true); end
        def sleep(how_long, *places); end
      end

      expect { described_class.check_implementation(Animal, interface) }.
        not_to raise_error
    end

    it "fails when no class method" do
      class Animal
        def bark(what); end
        def eat(tasty = true); end
        def drink(what, many = true); end
        def sleep(how_long, *places); end
      end

      expect { described_class.check_implementation(Animal, interface) }.
        to raise_error Adequack::InterfaceImplementationError,
          "object does not respond to 'self.evolutionize' method"
    end

    it "will not take care about private and protected methods" do
      class Animal
        def bark(what); end
      end

      bad_interface = Class.new do
        def bark(what); end

        class << self
          protected
          def c_a; end
        end

        def self.c_b; end
        private_class_method :c_b

        protected
        def a; end

        private
        def b; end
      end

      expect { described_class.check_implementation(Animal, bad_interface) }.
        not_to raise_error
    end

  end

  context "when stubbing and mocking" do

    let(:core) { double }
    let(:subject) { Adequack.double core, [interface] }

    it "let you stub methods that exists and return actual object" do
      core.should_receive(:stub).with({ bark: "woof" }, {})
      subject.stub(bark: "woof")
    end

    it "raises an error if trying to stub nonexistent method via hash" do
      expect { subject.stub(muuuu: "hey hoo") }.
        to raise_error Adequack::InterfaceImplementationError,
          "trying to stub nonexistent method"
    end

    it "raises an error if trying to stub nonexistent method via message" do
      expect { subject.stub(:muuuu) }.
        to raise_error Adequack::InterfaceImplementationError,
          "trying to stub nonexistent method"
    end

    it "works with chaining" do
      core.should_receive(:stub_chain).with("bark.words")
      subject.stub_chain("bark.words")
    end

    it "raises if chain in symbol form" do
      expect { subject.stub_chain(:tongue, :skin) }.
        to raise_error Adequack::InterfaceImplementationError,
          "trying to stub nonexistent method"
    end

    it "raises if chain in string form" do
      expect { subject.stub_chain("tongue.skin") }.
        to raise_error Adequack::InterfaceImplementationError,
          "trying to stub nonexistent method"
    end

    it "works with should receive too" do
      expect { subject.should_receive(:muuuu) }.
        to raise_error Adequack::InterfaceImplementationError,
          "trying to stub nonexistent method"
    end

    it "tell you if you'r passing invalid arguments" do
      expect {
        core.should_not_receive(:bark)
        subject.bark("woof", "not woof")
      }.to raise_error Adequack::InterfaceImplementationError,
        "definition of method 'bark' differs in parameters accepted."
    end

    it "works with class method defs too" do
      d = Adequack.double Class.new, [interface]
      d.should_receive(:evolutionize)
      d.evolutionize
    end
  end
end
