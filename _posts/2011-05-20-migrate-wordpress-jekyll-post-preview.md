---
layout: post
title: "Finally get rid of WordPress and PHP"
#published: false
tags:
- jekyll
- wordpress
- php
- migration
- liquid
- criticism
---

After a few tries migrate to blog engine with programming language I know well, I finally found 
[jekyll](http://github.com/mojombo/jekyll) - lightweight static site generator. My main concerns in this choice was:

* Edit posts in my favorite text editor with favorite markup
* NO PHP
* Syntax highlight out of the box

<!--more-->

### Migration from WordPress

Three main migration points was:

* Posts that was migrated with [several lines of ruby code](http://google.com/search?q=wordpress%20jekyll%20migrate)
* Comments that imported to [disqus](http://wordpress.org/extend/plugins/disqus-comment-system/) as jekyll is static site engine so the comments should be hosted somewhere else
* Generate [tag cloud and posts by tag pages](http://www.google.com.ua/search?sourceid=chrome&client=ubuntu&channel=cs&ie=UTF-8&q=jekyll+tag+cloud) that also have a lot of workarounds in the web

One problem I am currently have is "post preview" feature that is currently unsupported in jekyll.
My current approach for this looks like this:

    post.content | replace_first:'<!--more-->','<!--' | append:'-->' 

### Problems

Jekyll looks not very extensible. Some methods are not available in the API. Example: integrate SASS require more pain the ass than it should be. I am planning to fix that in a few days. Another problem I ran into is that github native support don't allow you any extension. My suggestion is to generate static content locally with your own code on top of jekyll and upload static content to git repository.

Currently I build site locally from [source code](http://github.com/bogdan/blog) and push static content into [separated repository](http://github.com/bogdan/bogdan.github.com).

### Result

About 12 hours of work to transfer 30 posts and their comments. 
Reworked site design to be more clean.
