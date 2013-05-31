class Animal
  def initialize(name)
    @name = name
  end

  def identify
    self.class.name
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
