require "spec_helper"
require_relative "../fixtures/interfaces/animal"
require_relative "../fixtures/interfaces/identificationable"
require_relative "../fixtures/animal"
require_relative "../fixtures/owner"

describe Animal do
  it do
    described_class.should behave_like Interface::AnimalInterface,
      Interface::Identificationable
    expect(described_class).to behave_like Interface::AnimalInterface,
      Interface::Identificationable
  end
end

describe Owner do
  let(:animal) do
    behavioral_double double,
      Interface::AnimalInterface, Interface::Identificationable
  end

  subject { described_class.new animal }

  context "when using should syntax" do
    it "tricks animal" do
      animal.should_receive(:bark).and_return("barked")
      subject.trick_animal.should eql "barked"
    end

    it "feeds animal the right way" do
      -> {
        animal.should_receive(:not_right_feed).and_return("barked")
      }.should raise_error Adequack::InterfaceImplementationError
    end
  end

  context "when using expect syntax" do
    it "tricks animal" do
      expect(animal).to receive(:bark).and_return("barked")
      expect(subject.trick_animal).to eql "barked"
    end

    context "works with spies" do
      it "works when all is ok" do
        animal.stub(:bark)
        subject.trick_animal
        expect(animal).to have_received(:bark)
      end
    end

    it "feeds animal" do
      expect {
        expect(animal).to receive(:not_right_feed).and_return("barked")
      }.to raise_error Adequack::InterfaceImplementationError
    end
  end
end
