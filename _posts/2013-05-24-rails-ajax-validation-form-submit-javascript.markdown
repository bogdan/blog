---
layout: post
title: Support validation through ajax in Rails 4.x
tags: 
- rails
- contribution
- javascript
- ajax
- validation
---        

I have a constant feeling that in a modern web every web form should be submitted with AJAX not the old retro way with POST request. This is better for numerous reasons.
                                                                                                                                         
At first, it gives better user experience
At second, AJAX is faster than regular request.
At the end,  it doesn't require a work to redraw the page with it's previous state if validation fails.

Currently I am trying to make rails app support this out of the box.
And here is first small step to this goal:

[This patch](https://github.com/rails/rails/pull/8638) allows a complete validation though ajax using active model validators.
This is a [live demo](http://rails-ajax-validation.herokuapp.com/developers/new) of what it allows to do.
If you feel especially interested in this feature, say your +1 here or on github.

<!--more-->
