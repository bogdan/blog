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
Their functionality is pretty close to each other. It allows to validate a state transition
and reinvent ruby programming language to define transition methods.
The fact that all of them prodes custom API to define a ruby method doesn't look right:

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

# And Finally ruby example
def approve!
  update_attributes!(:state => "approved")
  send_approval_email
end
{% endhighlight %}

Maybe I am ancient developer that lives in 90's but ruby version looks more human readable to me.

### So why do we still tend to use state machine gems

The main reason is state transition validation. It won't be easy to always check if it is possible to transition object from state A to state B in plain Ruby.
This part of state machine is something that really matter.

In my head it appears as some kind of allowed transitions map:

{% highlight ruby %}
order_transition_map = { 
  nil => [:pending], # Initial state is always pending
  :pending => [:approved, :rejected], # Pending can be transitioned to to paid and delivered
  :approved => :paid # Delivered can only be transitioned to paid
}
{% endhighlight %}


If the state machine's main goal is to validate transitions than let's implement it as a validation:

{% highlight ruby %}
class Order < AR::Base
  validates :state, :transition => order_transition_map
end
{% endhighlight %}


With This pattern you can define state transition methods in ruby:


{% highlight ruby %}
def upproved!
  # ....
end

def upproved?
  # ....
end

{% endhighlight %}



