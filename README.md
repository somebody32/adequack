# Adequack

[![Gem Version](https://badge.fury.io/rb/adequack.png)](http://badge.fury.io/rb/adequack)
[![Build Status](https://travis-ci.org/Somebody32/adequack.png?branch=master)](https://travis-ci.org/Somebody32/adequack)
[![Dependency Status](https://gemnasium.com/Somebody32/adequack.png)](https://gemnasium.com/Somebody32/adequack)

Everyone likes isolation testing. And when you do it, you are stubbing and mocking a lot.  
But the main concern when you use this approach is that your stubs will be out of sync with the
real objects.
Adequack addresses this issue.

## Problem 1. Missing methods

Let's dive into this toy code:
```ruby
class Dog
  def eat_food
    puts "delicious!"
  end
end

class Owner
  def initialize(dog)
    @dog = dog
  end
  
  def feed_animal
    @dog.eat_food
  end
end
```

and we are going to spec things out:

```ruby
describe Owner do
  let(:dog) { double }
  subject { described_class.new dog }
  
  it "feeds animal" do
    dog.should_receive(:eat_food)
    subject.feed_animal
  end
end
```

And everything will pass.

But let's imagine that a big dog food brand will come to us and pay a lot for branding:

```ruby
class Dog
  def eat_chappi
    puts "delicious chappi dog food! I will recommend it to all my buddies!"
  end
end
```

So we've changed our code and we should run the tests:

```
.

Finished in 0.00051 seconds
1 example, 0 failures
```

You are very confident about your test suite and you decide to deploy the changes to production.  
After that big dog food brand will take that payment away because of:

```ruby
undefined method `eat_food' for #<Dog:0x99250dc>
```

### Solving this with adequack

Let's replay the story again but with a happy end:

```ruby
require 'adequack'

module DogInterface
  def eat_food; end 
end

describe Dog do
  subject { described_class }
  it { should be_adequack_to DogInterface }
end

describe Owner do
  let(:dog) { adequack_double double, DogInterface }
  subject { described_class.new dog }
  
  it "feeds animal" do
    dog.should_receive(:eat_food)
    subject.feed_animal
  end
end
```

and we will have 2 passing dots:

```
.

Finished in 0.00128 seconds
2 examples, 0 failures
```

We should validate not only our mocks, but also that our core object really responds to the interface.  
Use `be_adequack_to` matcher with a core class as an argument.

And to create doubles and stubs use `adequack_double` helper. This will return a proxy object that  
will translate all calls to the object that you'll pass first (plain `double` at the example).  

Let's replay our changes again:
```ruby
class Dog
  def eat_chappi
    puts "delicious chappi dog food! I will recommend it to all my buddies!"
  end
end
```

and run our specs:
```
F.

Failures:

  1) Dog 
     Failure/Error: it { should be_adequack_to DogInterface }
     Adequack::InterfaceImplementationError:
       object does not respond to 'eat_food' method

```

Here we gon an error at the dog spec, because our core object falls out of sync with our interface.  
But big sponsor is paying, so we will change the interface too:

```ruby
module DogInterface
  def eat_chappi; end 
end
```

and rerun our tests:
```
.F

Failures:

  1) Owner feeds animal
     Failure/Error: dog.should_receive(:eat_food)
     Adequack::InterfaceImplementationError:
       trying to stub nonexistent method

```

Another failure, we should change our stubs too! 

And at this time we will ger our payment fully. 

## Problem 2. Method signatures

But what if method is there, but signature is changed?

```ruby
class Dog
  def eat_food(brand)
    puts "delicious #{brand} dog food! I will recommend it to all my buddies!"
  end
end
```

and our specs will tell you about that:

```
.F

Failures:

  1) Owner feeds animal
     Failure/Error: @dog.eat_food
     Adequack::InterfaceImplementationError:
       definition of method 'eat_food' differs in parameters accepted.
```

## Requirements

This gem tested against Ruby 1.9.3, 2.0.0.

Current version supports RSpec and Rspec Mocks only.  
If you want minitest or any other mocking library support, please drop a line at [this issue](https://github.com/Somebody32/adequack/issues/2).

## Installation

Just install the gem
```
gem install adequack
```

and require it when you need it: `require 'adequack'`

After that your rspec tests will have `be_adequack_to` matcher and `adequack_double` helper.

## Usage

TODO: Write full API definition here

## Alternatives

There are some alternative solutions:

* [Quacky](https://github.com/benmoss/quacky)
* [Bogus](https://github.com/psyho/bogus)
* [Rspec Fire Roles](https://github.com/cvincent/rspec-fire-roles)

The main goal of Adequack is to provide as transparent solution as possible and be suitable for isolation testing.  
Developer can pass a core object to the helper and get it back unchanged, just with a small interface checks added.

This will help minimize any possible integration errors or any unsuspected behaviour.
You should just be sure that your mocks are adequate and not get tricked by any internal magick.

## Contributing

This library is considered "experimental" quality.  
Your feedback would be very welcome! Pull requests are great, but issues are good too.

## Licence 

Copyright (c) 2013 Ilya Zayats

MIT License

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
