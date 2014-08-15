---
layout: post
title: 'Web Forms 2.0: Submit with Ajax and Client Side Validation'
#published: false
tags: 
- javascript
- ajax
- forms
- validation
- html
- jquery
---

Web 2.0 world force us to build Forms in a new level of quality. AJAX and dynamic HTML changes a way how forms should work internally. Let's call it Forms 2.0. And of course this facts bring a lot of complexity every time we deal with forms. Sometimes such form makes a real problem comparing to regular Web 1.0 form. Here will be a talk how to make Forms 2.0 as simple as Forms 1.0.

<!--more-->

## Sumbit with Ajax

Submit a form with AJAX have never been a problem:

{% highlight js %}
$.ajax({
  url: $(form).attr('action'),
  data: $(form).serialize(),
  type: $(form).attr('method'),
  success: function () {
    //do
  }
});
{% endhighlight %}

More over submit with AJAX doesn't require to rerender a page if it was not successfull: less server load and no need to support 'new' and 'edit' mode in HTML template. 
Problem that comes up with ajax submit is  Validation.
If you ever find yourself stuck with syncing client and server side validation or bug that form doesn't have some data that was there before submit then you know what I am talking about too.

## Solving validation problem

There are number of visions in the Ruby community on how to solve the problem: some people prefer stay with Forms 1.0. Some people generate JavaScript validators based on ActiveModel validators. Other guys write their own validation in JavaScript and perform it on both client and server side.
The complexity of all these solution goes beyond believe. And here I am going to describe much simpler way of doing it.

What if we pass the validation result as JSON from backend in a simple key:value format like:

{% highlight js %}
{email: "is not valid", password: "is too short"}
{% endhighlight %}

It's fast as wind and easy to implement:

* No SQL queries during validation request
  * Except uniqueness, that is more likely a feature than a problem
* No Rendering just small JSON object as response
* No additional controller action - just modify existing one


## From Assumptions to Coding

As we agreed - controller should return JSON instead of HTML:

{% highlight diff %}
 class UsersController < ApplicationController
   def create
     @user = User.new(params[:user])
     if @user.save
-      redirect_to root_path
+      render :json => {:redirect => root_path}
     else
-      render :action => :new
+      render :json => {:errors => user.errors}
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


All the dirty work can be done by [AjaxSubmit](https://github.com/bogdan/ajaxsubmit) library 
that implements all the ideas described above:

{% highlight js %}
$('#new_user').ajaxForm();
{% endhighlight %}

The main goal reached: Make super modern AJAX form is as easy as regular form.
If you still can't believe that it is so easy - check out [LIVE demo](http://ajaxsubmit.herokuapp.com).


## AjaxSubmit: Is it flexible?

AjaxSubmit is a library that has 2 years of experience behind. About 7 different engineers made their contribution during this time.
Take a look at the [Read Me](https://github.com/bogdan/ajaxsubmit#readme) for more information about API, callbacks and configuration options.

You can also checkout [Mailtrap](http://mailtrap.io) that is a perfect example of how your site could look like with this library 
in every web form.
