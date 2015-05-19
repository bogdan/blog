---
layout: post
title: Why Single Reponsibility principle should not be guiding principle
published: false
tags: 
- srp
- criticism
---

I've never been a fan of Single Responsibility Principle (SRP)

Whenever you are serious about choosing the frontend template engine to generate HTML, here is some advice how you can make your choice easier and 
more effective. There are too many template languages right now, but there are only a few main criteria how you can limit your selection to 2-3 of them before
getting into details.


<!--more-->

The role of information technology software is to simulate the outer world, but is there many things in real world that follows SRP?
SRP feels more elegant initialize: why isn't it wounderful that every tool you have does only one specific job. And all your tools are always shart and you know exectly which tool is designed for what kind of job.

<img src="http://www.evansclarke.com.au/Lib/tools.JPG" width="300px"/>


Well, in fact even common instruments are usually multifunctional.

<img src="http://upload.wikimedia.org/wikipedia/commons/8/84/Claw-hammer.jpg" width="300px"/>

It feels like Hammer should be a perfect example of SRP, but it is not. 
Hint: Pay attention to what is on opposite sides of the handle: these are two different ends designed to do completely different job.
It is a good example how functionality into one two based on process but not SRP. SRP is too idealistic even for hammer and pliers.

And this multi-functionality factor expands as we move to more famous devices. Like:

<img src="http://store.storeimages.cdn-apple.com/4428/as-images.apple.com/is/image/AppleInc/aos/published/images/i/ph/iphone6/plus/iphone6-plus-box-space-gray-2014?wid=478&hei=595&fmt=jpeg&qlt=95&op_sharpen=0&resMode=bicub&op_usm=0.5,0.5,0,0&iccEmbed=0&layer=comp&.v=1411520743411" width="200px"/>

Same thing happen in software world: utilities are designed to support a process and classes are made to simulate real world object.

So next time you would blame ActiveRecord::Base for having 200+ methods, try to think how well it is designed to support persistence process of the database entity.



