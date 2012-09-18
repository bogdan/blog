---
layout: post
title: 'New Rails Release with a few features from me'
tags: 
- rails
- changelog
- contribution
---

Upcoming Rails 3.2 release has many useful features.

Some of them are coming from me:

* ActiveRecord #pluck method
* Strict validation concept
* Customizable mass assignment sanitizer behavior
* Gotcha for `select[multiple]` tag

Here is a more detailed description than in the [Changelog](https://gist.github.com/1472145).

<!--more-->

## Pluck method

People around made a [lot of PR on it](https://github.com/rails/rails/commit/a382d60f6abc94b6a965525872f858e48abc00de). So, You probably already heard about it.

`pluck` can be used to query a single column from the underlying table of a model. It accepts a column name as argument and returns an array of values of the specified column with the corresponding data type.

{% highlight ruby %}
Client.where(:active => true).pluck(:id)
# SELECT id FROM clients WHERE active = 1

Client.uniq.pluck(:role)
# SELECT DISTINCT role FROM clients
{% endhighlight %}

[Pluck in Rails guides](http://edgeguides.rubyonrails.org/active_record_querying.html#pluck)

## Strict validation concept

Some validation are not connected with end user and breaking it is more likely a bug than problem with user input. A few constraints can be embed to DB(like foreign keys), but most of them can not. And it's a good idea to use AM validators to do such checks as well.

Use case:

{% highlight ruby %}
class Article < AR::Base
  validates :author, :presence => true
end

u = Article.new
u.save # => false
{% endhighlight %}

`#author` is usually set in controller from `current_user`. If somebody forgets to do it - user see error: 
`Author cann't be blank`. 
And it is not right to show error message to user that he is not able to fix.
More over DEV team is not notified about the problem.

In order to fix that You can use [validate! method](https://github.com/rails/rails/commit/8620bf90c5e486e1ec44b9aabb63f8c848668ed2) that generates validator that always raises exception when fails:

{% highlight ruby %}
class Article < AR::Base
  validates! :author, :presence => true
end

u = User.new
u.save # raises ActiveModel::StrictValidationFailed
{% endhighlight %}


## Customizing Mass Assignment Sanitizer

Added an ability to specify [your own behavior on mass assignment protection](https://github.com/rails/rails/commit/aa2639e746d8af5d7673bbbbbccbe868edeb0161), controlled by option: 

{% highlight ruby %}
ActiveModel::MassAssignmentSecurity.mass_assignment_sanitizer
{% endhighlight %}

The main idea behind this change is to make Mass Assignment Sanitizer to raise exceptions in development and test environments while leaving logging behavior in production. This will be the [default Rails application template](https://github.com/rails/rails/commit/0fab8c388ea9cfcace0907102697c78a68762be3) in version 3.2. It will allow to detect mass assignment protection issues caused by bug in code more effectively before they will be deployed to production.


## Power hacking select\[multiple\]


Quote from Rails documentation that comes along with [the patch](https://github.com/rails/rails/commit/faba406fa15251cdc9588364d23c687a14ed6885):

The HTML specification says: 

When `multiple` parameter passed to select and all options got deselected 
web browsers do not send any value to server. Unfortunately this introduces a gotcha:
if an `User` model has many `roles` and have `role_ids` accessor, and in the form that edits roles of the user
the user deselects all roles from `role_ids` multiple select box, no `role_ids` parameter is sent. So,
any mass-assignment idiom like

{% highlight ruby %}
  @user.update_attributes(params[:user])
{% endhighlight %}

wouldn't update roles.

To prevent this the helper generates an auxiliary hidden field before
every multiple select. The hidden field has the same name as multiple select and blank value.

{% highlight html %}
<input type="hidden" name="user[role_ids]" value=""/>
<select id="user_role_ids" name="user[role_ids]" multiple="multiple">
  ....
</select>
{% endhighlight %}

This way, the client either sends only the hidden field (representing
the deselected multiple select box), or both fields. Since the HTML specification
says key/value pairs have to be sent in the same order they appear in the
form, and parameters extraction gets the last occurrence of any repeated
key in the query string, that works for ordinary forms.

Unfortunately this trick can introduce a side effects described well in this [stackoverflow question](http://stackoverflow.com/questions/8929230/why-is-the-first-element-always-blank-in-my-rails-multi-select-using-an-embedde).
If you know an effective way to fix that - let me know.


#### Have fun with upgrading
