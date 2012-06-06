---
layout: post
title: 'Assumption Driven Approach'
tags: 
- assumption
- ruby
- performance
- fact
---

This post shows some examples of how things can go wrong way because of people actions based on assumptions but not on facts.
It is more conceptual than practical, so be patient and don't blame my grammar mistakes too much.
<!--more-->

### Evil of assumptions

This is my favorite example of how wrong assumption can be:

Very popular ruby questions for newbies: 

    What is the difference between `private` and `protected` methods?

Question seems good and reasonable. But most people don't know the right answer even after years with ruby.
Most people assume that `private` methods can not be called from inherited classes, but `protected` can be.

But that's only an assumption. Have you ever tried to ensure that it's right?
The answer is: **This is not true**. Private method can be called from inherited class in the same way as protected.

    class A
      private
      def a
        puts 'hello'
      end
    end
    
    class B < A
      def b
        a
      end
    end
    
    B.new.b # No Exception here

[More about private and public methods here](http://gusiev.com/2010/04/ruby18-private-protected-incapsulatio/).

This is good example on how myths can spread the world:
Almost every person is surprised by the output of program above.

This makes me feel that many interviewers ask questions while don't know what they are asking about.
From this point I can state that a lot of ruby interviews goes in a wrong direction by providing an assumption as a fact.


### Class variables assumption

Yet another assumption that can be made based on ruby documentation is connected with ruby class variables:

    class A
      @@x = 2
      def self.pr
        @@x
      end
    end

    class B < A
      @@x = 5
    end

    puts B.pr
    puts A.pr

You can assume that last two lines produce 5 and 2, but they both produce 5.
Because class variables are shared across all classes.

### Assumption example in the performance field

Most popular assumptions field is performance. And here we come up with the most recent bad assumption example:

Ruby 2.0 offers lazy enumeration feature.

    (1...100000).to_a.lazy.select{|a| a.odd? }.map{|a| a**2}.to_a

In short: there will be only one iteration over an array with no intermediate array between `select` and `map`.
If you are an assumption-driven person, you already assumed that `#lazy` not only saves your memory, but also improve performance.

And problem is that it is not true. [`#lazy` is very slow](https://bugs.ruby-lang.org/issues/6183). 

{% comment %}TODO: LSI? {% endcomment %}

### How to use assumption in a right way?

Why we are still using assumptions a lot? Because they are cheap: they allow us to move faster without proofing that we are moving the right direction.

Here are some MUSTs that we need to follow:

* Always make sure that you are 100% right when you are interviewing other person.
* Never make assumptions in performance field.

And here are some more conceptual advices:

* Make assumptions depend on facts, but not other assumptions.
* Prove any assumption with fact before going with another assumption
* Do not tell people about assumptions as if they are facts.
* When we can't make a good assumption from the beginning, maybe it's time to gather more facts

