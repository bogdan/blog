---
layout: post
title: 'Web Forms 2.0: Submit with Ajax and Client Side Validation'
#published: false
tags: 
- javascript
- ajax
- forms
- validation
---

Web 2.0 world require us build Web Forms with new level of quality. We've got fields that appear dynamically, submit forms via ajax, client side validation and many many other tiny troubles. Sometimes such form makes a real problem comparing to regular Web 1.0 form. Let's call it Forms 2.0. 

<!--more-->
If you ever find yourself stuck with syncing client and server side validation or bug that form doesn't have some data that was there before submit then you know what I am talking about too.

There are number of visions in the Ruby community on how to solve the problem: some people prefer stay with Forms 1.0. Some people generate JavaScript validators based on ActiveModel validators. Other guys write their own validation in JavaScript and perform it on both client and server side.

The complexity of all these solution goes beyond believe. And here I am going to describe much simpler way of doing it

What if we pass the validation result as JSON from backend in a simple key:value format like:

{% highlight js %}
{email: "Email is not valid", password: "Password is too short"}
{% endhighlight %}

It's fast as wind and easy to implement:

* No SQL queries during validation request
  * Except uniqueness, that is more likely a feature than a bug
* No Rendering just small JSON as the response
* No additional controller action - just modify existing one


## Let's do it

Change the controller to return json instead of HTML:

{% highlight diff %}
 class UsersController < ApplicationController
   def create
     @user = User.new(params[:user])
     if @user.save
-      render :action => :new
+      render :json => {:errors => user.errors}
     else
-      redirect_to root_path
+      render :json => {:redirect => root_path}
     end
   end
 end
{% endhighlight %}


All we need to do after that is just assign errors to the form to the prepared spots identified with HTML5 custom attribute:

{% highlight diff %}
 <form id="new_user" action="/users" method="post">
-  <div class="field">
+  <div class="field" validate="email">
     <label for="user_email">Email</label><br />
     <input id="user_email" name="user[email]" type="text" />
   </div>
-  <div class="field">
+  <div class="field" validate="password">
     <label for="user_password">Password</label><br />
     <input id="user_password" name="user[password]" type="password" />
   </div>
   <div class="actions">
     <input name="commit" type="submit" value="Create User" />
   </div>
 </form>
{% endhighlight %}


And this job will be done by [AjaxSubmit](https://github.com/bogdan/ajaxsubmit) library:

{% highlight js %}
$('#new_user').ajaxForm();
{% endhighlight %}

The main goal reached: Make super modern ajax form is as easy as regular form.
If you still can't believe that it is so easy - check out [LIVE demo](http://ajaxsubmit.heroku.com).



## AjaxSubmit history: Is it flexible?

AjaxSubmit is a library that has 2 years of experience behind. About 7 different engineers made their contribution during this time.
Take a look at the [Read Me](https://github.com/bogdan/ajaxsubmit#readme) for more information how to customize it for your needs

You can also checkout [Mailtrap](http://mailtrap.io) service where all forms are made with AjaxSubmit. This a perfect example of how your site could look like with this library.
