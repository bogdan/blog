---
layout: post
title: 'Assumption Driven Development'
published: false
tags: 
- rails
- contribution
- performance
- success
---

### Evil of assumptions

There is very popular newbie ruby questions on what is difference between `private` and `public` keywords.
Question seems good and reasonable. But most people don't know the right answer even after years with ruby.
Most people assume that `private` methods can not be called from inherited classes, but `protected` can be.

But that's only an assumption. Have you ever tried to ensure that it's right?
The answer is: it's not right:

{% highlight ruby %}
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
{% endhighlight %}

[More about private and public methods here](http://gusiev.com/2010/04/ruby18-private-protected-incapsulatio/).
From this point I can assume that a lot of ruby interviews goes in a wrong direction. Providing an assumption as a fact.


### Another assumption example

Most popular assumptions field is performance.
Ruby 2.0 offers lazy enumeration feature

{% highlight ruby %}
(1...100000).to_a.lazy.select{|a| a.odd? }.map{|a| a**2}.to_a
{% endhighlight %}

In this example there will be only one iteration over an array with no intermidiate array between select and map.
If you are an assumption-driven person, you already assumed that `#lazy` could be a nice performance improvement sometimes.
[And problem is that it is not true](https://bugs.ruby-lang.org/issues/6183).


### How to use assumption in a right way?




