---
layout: post
title: Smart Javascript Initialization Strategy
#published: false
tags: 
- javascript
- initialization
- class
---

JavaScript initialization process is a pain in the ass since dynamic HTML and AJAX became popular. We need to take care all the time about what we need to initialize after every change in DOM. Thanks to `jQuery#live` and `jQuery#on` that is not so right but still very effective solution. It allows to fix the problem with initialization of typical events.
But initialization is not always about binding DOM events. In more advanced cases it could be wrapping widget class over an element or custom jQuery method call like date-picker.

<!--more-->

Here is an example:

{% highlight js %}
// This line will be required not only on `$(docuemnt).ready` 
// but every time an update in DOM occur that adds some new date input on page.
$(".data-picker").datePicker();
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

In example above is split into two sections: definition and initialization.
This fact makes code hard to follow as moving from class to DOM element in HTML template require at least two transitions in your editor.

And when large page update comes after ajax query this is getting even worth. All initializer should called again:

{% highlight js %}
$.get("/profile/edit", data, function(response) {
  showSomeProfileEditingPopup(response);
  $(".profile-birth-date").datePicker();
  new ImageGallery($('.profile-image-gallery'));
  // More initialization here
});
{% endhighlight %}


### Tired to handle things like this? 

## Change the way of thinking about initialization

Initialization code is a bridge where between actual JS class and DOM element.
In 99% of cases it has one to one or one to many relation.
Than, why do we always need that intermediate initialization code?

The DOM element could have the class itself:


{% highlight html %}
<div class="profile-image-gallery" data-class="ImageGallery">
{% endhighlight %}

Now your way from DOM element to JS class require only one transition.
Moreover all DOM elements could be initialized with one call. It needs to run over DOM and find all elements with `data-class` attributes that are not initialized and wrap them with a specified class:

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

This code bit will probably require some additional functionality to support an options but general idea is strong enough to handle all possible complexity in a future.
Now, whenever DOM changes everything we need to do is call:

{% highlight js %}
Initializer.perform();
{% endhighlight %}

In order to attach third-party libraries to this initialization process we need to create a simple wrapping class around them:

{% highlight js %}
var DatePicker = function (element) {
  $(element).datePicker()
}
{% endhighlight %}

Now we are able to convert inputs to date pickers with unified initialization process:

{% highlight html %}
<input type="text" name="profile[birth_date]" data-class="DatePicker">
{% endhighlight %}


## Conclusion

JavaScript coding is annoying for most people that came from other languages because it keeps fragmented things that should be bound together.
In order to avoid this problem we need to invent conventions to follow, so that every person in a team understand that.
But the cost of convention described here is not that much and makes code move clean and easy to follow.











