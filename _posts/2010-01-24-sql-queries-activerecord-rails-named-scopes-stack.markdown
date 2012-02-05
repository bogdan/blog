---
layout: post
title: Advanced SQL and scopes stack with ActiveRecord
tags: 
- sql
- query
- ruby
- rails
- activerecord
- scope
---
If you ever work with rails application that is a little bit more complex than a simple CRUD you would know that some of the ActiveRecord magic doesn't work for complex SQL queries. I am primary talking about scopes stack feature.<br/>
<!--more-->
<hr/>
Let's review the following scope that suppose to be usable in different combinations with others:
{% highlight ruby %}
scope :network_of, lambda {|user|
{
:select => "u.*"
:from => "users u, followings f1, followings f2",
:conditions => "f1.follower_id = #{user.id} AND " + 
"f1.followed_id = f2.follower_id AND " +
"f2.followed_id = u.id"
}
{% endhighlight %}
It suppose to returns all people that are followed by people that are followed by the given person(second circle).
From the SQL point of view that is the simpliest and fastest way to do that with a plain SQL.
But this solution will have some issues with Active Record scopes stack magic.
See that `User.network_for(current_user).all(:limit =>5)` will result in SQL exception primary because `:limit => 5` doesn't know about the table alias `users u`.
We can not use it in fact.<br/>
The second problem comes to the foreground when we will try to use ActiveRecord features like
`User.network_for(current_user).all(:include => :orders)`. ActiveRecord handles :include in the very different ways and in some cases you will see the SQL exception here as well.<br/>
The problem is that :include sometimes appends some joins to the query that is concatenated to the last table in the :from parameter. To solve that we should make "users" table to be the last one declared in :from parameter.
{% highlight ruby %}
:select => "users.*"
:from => "followings f1, followings f2, users",
:conditions => "f1.follower_id = #{user.id} AND " + 
"f1.followed_id = f2.follower_id AND " +
"f2.followed_id = users.id"
{% endhighlight %}
Summary I would say that using `:joins` instead of `:from/:conditions` would give more flexibility and stackability to your scopes but sometimes `:from` is more clear and here you got the tip how to use it.
