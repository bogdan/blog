---
layout: post
title: Smart Javascript Initialization Strategy
#published: false
tags: 
- javascript
- initialization
- class
---

The JavaScript initialization process is a pain in the ass since dynamic HTML and AJAX became popular. We need to take care all the time about what we need to initialize after every change in DOM. 
Thanks to `jQuery#live` and `jQuery#on`: We have a not-so-right but still very effective solution. It allows us to fix the problem with initialization of typical events.
But initialization is not always about binding DOM events. In more advanced cases, it could be wrapping widget class over an element or a custom jQuery method call like a `date-picker`.

<!--more-->

Here is an example:

{% highlight js %}
// This line will be required not only on `$(docuemnt).ready` 
// but every time an update in DOM occurs that adds some new date input on a page.
$(".date-picker").datePicker();
{% endhighlight %}

Or advanced example:

{% highlight js %}
var ImageGallery = function(){
  /* Class with 100+ lines of code here */
}; 
$(".image-gallery").each(function(element){
  new ImageGallery(element);
});
{% endhighlight %}

In the example above, we see two sections: definition and initialization.
This fact makes code hard to follow as moving from class to DOM element in HTML template requires at least two transitions in your editor.

And when a large page update comes after an AJAX query, this problem is getting even worse. All initializers should called again:

{% highlight js %}
$.get("/profile/edit", data, function(response) {
  showSomeProfileEditingPopup(response);
  $(".profile-birth-date").datePicker();
  new ImageGallery($('.profile-image-gallery'));
  // More initialization here
});
{% endhighlight %}


### Tired of handling things like this? 

## Change the way of thinking about initialization

Initialization code is a bridge between actual JS class and DOM element.
In 99% of cases, it has one-to-one or one-to-many relation.
Then why do we always need that intermediate initialization code?

The DOM element could have the class itself:


{% highlight html %}
<div class="profile-image-gallery" data-class="ImageGallery">
{% endhighlight %}

Now your way from DOM element to JS class requires only one transition.
Moreover, all DOM elements could be initialized with one call. It needs to run over DOM and find all elements with `data-class` attributes 
that are not initialized and wrap them with a specified class:

{% highlight js %}
var Initializer = {
  perform: function() {
    $('[data-class]:not(.initialized)').each(function(i, element) {
      var element = $(element);
      element.addClass('initialized');
      var klass = window[element.data(element)];
      new klass(element);
    });
  }
};
{% endhighlight %}

This code bit will probably require some additional functionality to support options, but the general idea is strong enough to handle all possible complexity in the future.
Now, whenever DOM changes, everything we need to do is call:

{% highlight js %}
Initializer.perform();
{% endhighlight %}

In order to attach third-party libraries to this initialization process, we need to create a simple wrapping class around them:

{% highlight js %}
var DatePicker = function (element) {
  $(element).datePicker()
}
{% endhighlight %}

Now we are able to convert inputs to date pickers with a unified initialization process:

{% highlight html %}
<input type="text" name="profile[birth_date]" data-class="DatePicker">
{% endhighlight %}


## Conclusion

JavaScript coding is annoying for most people who came from other languages because it keeps things fragmented that should be bound together.
In order to avoid this problem, we need to invent conventions to follow, so that every person in a team understands that.
But the cost of convention described here is not that much and makes code more clean and easier to follow.











