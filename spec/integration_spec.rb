require "spec_helper"

module AnimalInterface
  def self.evolutionize(from_what); end
  def bark(what); end
  def feed(what, many = false); end
end

class Animal
  def initialize(name)
    @name = name
  end

  def self.evolutionize(from_what)
    new("next step from #{from_what}")
  end

  def bark(what)
    puts what
  end

  def feed(what, many = false)
    emotion = "So yammy #{what}"
    emotion = [emotion, "I'm full up"].join(", ") if many

    bark emotion
  end
end

describe Animal do
  subject { described_class }
  it { should be_adequack_to AnimalInterface }
end

class Owner

  def initialize(animal)
    @animal = animal
  end

  def trick_animal
    @animal.bark("woof")
  end

  def enormously_feed_animal
    @animal.feed("chappy", true)
  end

end

describe Owner do
  let(:animal) { adequack_double double, AnimalInterface }
  subject { described_class.new animal }

  it "tricks animal" do
    animal.should_receive(:bark).and_return("barked")
    expect(subject.trick_animal).to eql "barked"
  end

  it "feeds animal" do
    animal.should_receive(:feed).and_return("barked")
    expect(subject.enormously_feed_animal).to eql "barked"
  end
end
