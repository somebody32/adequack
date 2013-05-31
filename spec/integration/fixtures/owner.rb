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
