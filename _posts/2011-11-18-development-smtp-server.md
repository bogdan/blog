--- 
layout: post
title: 'Improve your Email delivery code with Mailtrap'
published: false
tags: 
- smtp
- development
- service
---

Today, I want introduce the <a href="http://mailtrap.io">Mailtrap web service</a> aimed to help developers build and improve their email delivery code. 


Usually people use same SMTP settings for Production and Development environment, but this actually creates many problems. 
<!--more-->

### Problems 

Here are some common problems with email delivery that occur during development:

#### Testing user registration is hell

In order to register yet another user You need to have new unique email address that should be registered somewhere.

#### Perform mass email sending is a problem too

Suppose you have a daily email to all customers and need check if your delivery logic works fine. In this case you need to know what emails were send, which customers received them. And again you need a batch of email addresses to test with.

#### Sharing some problems in email layout with team

In order to share email You need to forward it to some inbox or attach to but ticket. This is still not as easy as it could be.

#### Send emails to real customers by mistake

In some cases copy production database to staging is a good idea. But You have a risk that real emails appear on development servers. You need to always remember about that.

My personal score is about 2500 emails sent by mistake at a time.
Some people around me have their personal record **more than 2 millions emails** sent by mistake.
(Share your personal fuckup story in comments.)

### Existing solutions

You can do many things to fix the problem e.g.: 

* setup the script on your smtp server that changes recipient email
* use services like mailinator.com
* use custom Ruby solution like mail\_view or mailcatcher. 


### Our Idea


Development SMTP server should work in a different way then production one: It should not deliver emails but just gather them in one place and provide a shared access for team to debug it. Mailtrap is the first SMTP service built for Development and Staging servers making your work easier. 

Unlike many alternatives, Mailtrap is platform independent, doesn't require any service to run and is just an SMTP server from application stand point.  All you need to do is setup host, username and password.


### Features

This is not about high load, not about delivery statistics but about:

* Ability to access ANY email without registration
* Access to the history
* Share Email is as easy as copypasting the URL
* Developers tools to improve email layout:
  * Syntax highlight
  * Easy view source
  * Apply CSS reset


## Try [mailtrap](http://mailtrap.io) right now
