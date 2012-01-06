---
layout: post
title: 'New Rails Release with a few tiny features from me'
tags: 
- rails
- changelog
- contribution
---

Upcoming Rails 3.2 release has many tiny but very useful features.

Some of them I did myself:


* ActiveRecord #pluck method
* Strict validation concept
* Customizable mass assignment sanitizer behavior
* Power hacking `<select multiple>` tag

### [#pluck method](https://github.com/rails/rails/commit/a382d60f6abc94b6a965525872f858e48abc00de)

People around made a lot of PR for it. So, You probably already heard about it.

`pluck` can be used to query a single column from the underlying table of a model. It accepts a column name as argument and returns an array of values of the specified column with the corresponding data type.

{% highlight ruby %}
Client.where(:active => true).pluck(:id)
# SELECT id FROM clients WHERE active = 1

Client.uniq.pluck(:role)
# SELECT DISTINCT role FROM clients
{% endhighlight %}

[Pluck in Rails guides](http://edgeguides.rubyonrails.org/active_record_querying.html#pluck)

### [String validation concept](https://github.com/rails/rails/commit/8620bf90c5e486e1ec44b9aabb63f8c848668ed2)

Some validation are not connected with end user and breaking it is more likely a bug than problem with user input. A few constraints can be embed to DB(like foreign keys), but most of them can not. And I think it's a good idea to use AM validators to do such checks as well.

#### Use case

{% highlight ruby %}
class User < ARB
  validates_presence_of :author
end
{% endhighlight %}

`#author` is usually set in controller from `current_user`. If somebody forgets to do it - user see error: 
`Author cann't be blank` That he can not correct. More over DEV team is not notified about the problem.

In order to fix that You can use `validate!` method that generates validator that always raises exception when fails:

{% highlight ruby %}
  validates! :author, :presence => true
{% endhighlight %}


