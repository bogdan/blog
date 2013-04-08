---
layout: post
title: Attach git commits to pivotal stories
#published: false
tags: 
- git
- commit
- gem
- pivotaltracker
---        

I heard about 10 different ways to organize work flow around pivotaltracker and git and about 5 gems to support that process.
All of them seems abusing for me: the outcome of pivotal/git integration is a git commit attached to pivotal story and the rest of conventions like naming branches or merge policy doesn't make any sense in long time perspective and is just a waste of time in fact. 

That's why I've decided to make the most trivial integration that covers this idea and don't provide additional complexity:
Meet [git-storyid](https://github.com/bogdan/git-storyid) gem - the only one git/pivotaltracker integration that saves your time.

<!--more-->

## Installation

{% highlight sh %}
gem install git-storyid
{% endhighlight %}


## Usage

{% highlight sh %}
git storyid -m "Initial implementation of campaign tags"
# Api token (https://www.pivotaltracker.com/profile): a56f0e9a4fbXXXXXXXXXXXXXX
# Use SSL (y/n): y
# Your pivotal initials (e.g. BG): BG
# Project ID: 494XXX
{% endhighlight %}

Now interactive menu is displayed to select one of **Started stories** owned by you:

<pre><code>[1] Removing Billing Page
[2] Welcome Email
[3] Email Shares -  Capture
[4] Speed up activities by dates aggregation
[5] Mass Email to Customer List - thurs AM
[6] Investigate production error
[7] Tag campaign insertion points

Indexes(csv): 7
[campaign-tags 3020407]  [#44116647] Initial implementation of campaign tags
 1 file changed, 1 insertion(+), 2 deletions(-)</code></pre>

Result commit:

<pre><code>commit 3020407e92cb125083cf50ad494ff15169a7f2e6
Author: Bogdan Gusiev &lt;youremail@gmail.com&gt;
Date:   Fri Mar 15 12:42:32 2013 +0200

[#44116647] Initial implementation of campaign tags

Feature: Tag campaign insertion points and 
campaigns with an identifier, 
so only campaigns with matching identifier will get shown</code></pre>

## How should I name branches?

Branch names is not something that you should focus on. Unlike commit messages, branches are removed from history after merge. That is why you should name them in a way that takes less of your time. I personally prefer to have only one branch for myself called `bogdandev` when I work on a project. When the feature is not done - there is no sense to work on another feature.
