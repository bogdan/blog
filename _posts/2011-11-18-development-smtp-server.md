--- 
layout: post
title: 'Improve your Email delivery code with Mailtrap'
tags: 
- smtp
- development
- service
- environment
---

Today, I want introduce the <a href="http://mailtrap.io">Mailtrap web service</a> aimed to help developers build and improve their email delivery functionality. 

Usually people use same SMTP settings for all environments, but this actually creates many problems in Staging and Development environments. Mailtrap is a special SMTP service for these environments aimed to solve specific problems.
<!--more-->

### Problems 


#### Testing user registration is hell

In order to register yet another user You need to have new unique email address that should be hosted somewhere.

#### Perform mass email sending is a problem too

Suppose you have a daily email to all customers and need check if your delivery logic works fine. In this case you need to know what emails were send, which customers received them. And again you need a batch of email addresses to test with.

#### Discuss email layout and functional problems with product team

In order to share email You need to forward it to some inbox or attach to bug ticket as file. This is still not as easy as it could be.

#### Send emails to real customers by mistake

In some cases copy production database to staging is a good idea. But You have a risk that real emails appear on development servers. You need to take care about that.

My personal score is about 2500 emails sent by mistake at a time.
Some people I know told me that their personal record is **more than 2 millions emails sent by mistake**.
(Share your personal fuckup story in comments.)

### Existing solutions

You can go in many ways to fix the problem e.g.: 

* setup the script on your smtp server that changes recipient email
* use services like mailinator.com (only in some cases)
* use custom Ruby specific gems like mail\_view or mailcatcher. 

All of them solves only some of the problems described above.

### Our Idea

Development SMTP service should work in a different way then production one: It should not deliver emails but just gather them in one place and provide a shared access for team to debug it. Mailtrap is the first SMTP service built specifically for this purpose. 

<img src="http://mailtrap.io/assets/marketing/banner-cfb4ba4d680e3d51ed5d08641b8501b7.png" style="width: 693px"/>

Unlike many alternative solutions, Mailtrap is platform independent, doesn't require any daemon to run and is just an SMTP server from application stand point.  All you need to do is **setup host, username and password**.


### Features

This is not about high load, not about delivery statistics but about:

* Ability to access ANY sent email without registration
* Share Email is as easy as copypasting the URL
* Developer tools for debugging & improving email template:
  * Syntax highlight
  * Easy view source
  * Apply CSS reset
* Access to the history


## Try [Mailtrap](http://mailtrap.io) right now

