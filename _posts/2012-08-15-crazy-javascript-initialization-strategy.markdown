---
layout: post
title: Crazy Javascript initialization strategy
published: false
tags: 
- solr
- sunspot
- postgresql
- fulltext
- search
---

JavaScript initialization process is a pain in the ass since dynamic HTML and AJAX became popular. We need to take care all the time about what we need to initialize after every change in DOM. Thanks to `jQuery#live` and `jQuery#on` that is [not so right] but still very effective solution. It allows to fix the problem with initialization of typical events.
But at first initialization is not always about assigning event callbacks:

{% highlight js %}
$(".data-picker").datePicker();
{% endhighlight %}

This line will be required not only on `$(docuemnt).ready` but every time an update in DOM occur that adds some new date input on page.

At second when the application code gets more complicated.

```
var ImageGallery = function(){}; //your preferred way to define a class here

$(".product-image-gallery").each(function(element){
  new ImageGallery(element);
});
```

In this example code is split into two sections: class and initializer.
And this initializer are scattered across the code.


