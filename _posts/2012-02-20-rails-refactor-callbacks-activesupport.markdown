---
layout: post
title: 'Refactor ActiveSupport::Callbacks'
published: false
tags: 
- rails
- contribution
- performance
- success
---

Have you ever ask yourself why Rails is slow? Maybe because Ruby is slow or because Rails programmers don't care about performance.
Anyway when I opened [ActiveSupport::Callbacks file](https://github.com/rails/rails/blob/3-0-stable/activesupport/lib/active_support/callbacks.rb) first time - I was shocked. It was the crazyest library I've ever seen.
All interals is a generated code mixed up with native code creating a conditional compilation full of code duplication and over compexity. It is breaking any programming principle I've ever know. And it's a part of a **super cool and modern** framework called "Ruby on Rails".

After I get rid of all these emotions(that took a while) I've tryed to understand what's going on. Callbacks is one of the most critical part of ActiveSupport used in part of Rails(ActionPack, ActiveRecord, ActiveResource, ActiveModel). And there was [no serious changes in there since 2009](https://github.com/rails/rails/blame/v3.0.10/activesupport/lib/active_support/callbacks.rb). Git log make me understand that there was a lot of work trying to refactor this library but I still didn't manage to follow it's evolution to understand why it looks like this right now.

That make me feel that no body knows what's going on in there. 
And suddenly I felt the opportunity to go beyond the limit of possible and refactor this library. I didn't have enough reputation in Rails core team to submit 1k lines patch with the assumption that I works better than current one. So I needed a smooth changes plan and a proof that every change is making Rails better. 

This proof is a benchark of course: It's great that AS::Callbacks is simple library from API and dependencies stand point: that means that I can esily have two instances of a library at runtime: old one and new one, and compare their performance. All I need to do is:

* copy `callbacks.rb` file to `old_callbacks.rb`
* rename `Callbacks` to `OldCallbacks` in a copy
* Create a benchmark file that runs code with old and new instances of a library

In this way the performance will always be under control. And this benchmark would be the ultimate reason why my Pull Requests should be merged.

