---
layout: post
title: "Minimalistic State Machine: Less is MORE!"
published: false
tags: 
- rails
- validation
- statemachine
- criticism
---

I have tried a bunch of ActiveRecord's state machine gems.
Their functionality is very close to each other. It allows to validate a state transition
and reinvent ruby programming language to define transition methods.
The fact that all of them produces custom API to define a ruby method doesn't look right...

{% highlight ruby %}
# State Machine gem example
state_machine :state, :initial => :parked do
  event :approve! do
    transition :pending => :approved
  end
  after_transition :pending => :approved, :do => :send_approval_email
end

# Workflow gem example
workflow do
  state :pending do
    event :approve!, :transitions_to => :approved, :after_transition => :send_approval_email
  end
end

# And finally plain ruby/rails example
def approve!
  update_attributes!(:state => "approved")
  send_approval_email
end
{% endhighlight %}

Maybe I don't know all modern trends but ruby version looks more human readable to me.

### So why do we still tend to use state machine gems

The main reason is state change validation. It won't be easy to always check if it is possible to transition object from state A to state B in plain Ruby.
This part of state machine is something that really matter.

In my head it appears as some kind of allowed changes map:

{% highlight ruby %}
order_state_changes_map = { 
  nil => [:pending], # Initial state is always pending
  :pending => [:approved, :rejected], # Pending can be changed to to paid and delivered
  :approved => :paid # Delivered can only be changed to paid
}
{% endhighlight %}


If the state machine's main goal is to validate changes than let's implement it as a validation:

{% highlight ruby %}
class Order < AR::Base
  validates :state, :changes => order_state_changes_map
end
{% endhighlight %}


With this pattern you can define state change methods in ruby:


{% highlight ruby %}
validates :state, :changes => { 
  nil => [:pending], # Initial state is always pending
  :pending => [:approved, :rejected], # Pending can be changed to to paid and delivered
  :approved => :paid # Delivered can only be changed to paid
}

def upproved!
  # ....
end

def upproved?
  # ....
end

{% endhighlight %}

Now it looks really readable and a person who never saw this kind of API before can figure out what is happening.

Give it a try to: [ChangesValidator](https://github.com/bogdan/changes_validator)

