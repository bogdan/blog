---
layout: post
title: "Choosing a Templating Language"
tags: 
- templates
- frontend
- ruby
- javascript
---

Whenever you are serious about choosing the frontend template engine to generate HTML, here is some advice how you can make your choice easier and 
more effective. There are too many template languages right now, but there are only a few main criteria how you can limit your selection to 2-3 of them before
getting into details.


<!--more-->

Here they are:

## Logic-less OR with Programming language

The most common way to generate a template that would seem obvious to any developer would be using programming language.
Example: ERB for Ruby, JSP for Java etc.
That is a pretty straight way to implement loops, conditions and more rare view structures.

On the other hand, logic-less templates like Mustache restrict you from using complicated structures in the template forcing you to extract and put them to a different layer.

Example of the same condition in logic-less or programming language template engines:

{% highlight erb %}
<% if @user.posts.empty? && @user.comments.empty? %>
  <a href="#">Delete</a>
<% end %>
{% endhighlight %}
  
In logic-less template language, it would look like:

{% highlight erb %}
<% if possible_to_delete_user? %>
  <a href="#">Delete</a>
<% end %>
{% endhighlight %}

{% highlight ruby %}

def possible_to_delete_user?
  @user.posts.empty? && @user.comments.empty?
end
{% endhighlight %}

That looks more clean but less flexible as the logic-less template forces you to make quality even if you would like to save time instead.

In general I would recommend Logic-Free languages for a huge team with lots of beginner developers that need a strong force &mdash; like language restriction &mdash; to be controlled.

## Frontend Rendering support

Frontend rendering can be the ultimate reason to switch to this type of template language. The decision here usually comes from more strong reasons of the application design rather than template language properties.
I will assume that you already know if you want to use frontend rendering or not.
And in case of yes, you would need to think if it is ok to have a single language  for both &mdash; front and back end &mdash; or a different one for backend rendering.
Two template languages overhead can be not so large overhead sometimes. For example, when the backend templates are only used for static layout like html head, or footer and header of the page, or admin pages.

It is pretty obvious that such a template language needs to use JavaScript in some way even though it is CoffeeScript. 

## Minimalistic OR HTML Compatible

HTML is being blamed for too ambiguous structures: you should always repeat yourself with closing tags, often used html attributes don't have shortcuts etc.
Minimalistic template languages are not trying to look like HTML and provide a convenient way to write an XML-like structure.
When I write HAML instead of ERB, my fingers run a significantly smaller distance.

On the other hand, minimalistic templates can be hard to understand for old school software developers that parse HTML on autopilot.
If your team has too many developers like that, then a Minimalistic template engine isn't worth it.

## Sandbox Mode support

The Sandbox Mode support requirement is pretty exotic. It is only required if you would like to allow users to change the appearance of site pages significantly
by allowing them to edit the template themselves without modifying the site source code.
Maybe it is not obvious to everyone, but in this case, template language would need to support many limitations to the template source code that will prevent your server from blowing up.
The most trivial example of how a template could blow up a server would be loops nested to each other one hundred times that will consume too many resources.
Sandbox is a super mode of the logic-less template. When not just full power programming language is not allowed, but additional limitations exist to make any possible template safe.
Most popular template languages like ERB, HAML or EJS (just like ERB but Javascript instead of Ruby) don't support Sandbox. But here are two that do: [liquid](http://github.com/shopify/liquid) and [scribble](https://github.com/stefankroes/scribble)

## Summary

After a clear answer to what kind of template you need, the choice becomes more obvious as there will be only a few template engines matching given requirements.
I've even spent some time letting to build this nice table for you:

{:.bordered}
| Logic-less | FrontEnd | Minimalistic | Variants                      |
|------------|----------|--------------|-------------------------------|
| yes        | yes      | yes          |                               |
| yes        | yes      | no           | mustache, handlebars          |
| yes        | no       | yes          | hamstache                     |
| yes        | no       | no           | mustache, curly               |
| no         | yes      | yes          | Haml-coffee, Jade             |
| no         | yes      | no           | EJS, ECO                      |
| no         | no       | yes          | HAML, Slim                    |
| no         | no       | no           | ERB +alternative compilers    |
| sandbox    | yes      | yes          |                               |
| sandbox    | yes      | no           |                               |
| sandbox    | no       | yes          |                               |
| sandbox    | no       | no           | Liquid, Scribble              |

This table doesn't include all variants, but I've tried to fill in as many cells in the last column giving at least 2 variants if possible.

The current software world of Ruby & JavaScript doesn't give full spectrum of choices when you would like to have Sandbox mode support.
As I said before: Sandbox Mode is very rare requirement.

But in other cases you have enough choices. It is strange that there is no logic-less, frontend and minimalistic template engine now. If there is one - please suggest me in a comment.

