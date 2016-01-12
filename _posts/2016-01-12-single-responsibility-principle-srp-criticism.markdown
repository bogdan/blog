---
layout: post
title: Something is wrong with Single Reponsibility Principle
tags: 
- srp
- criticism
- tools
---

I've never been a fan of Single Responsibility Principle aka SRP

If any physical thing I used has multiple responsibilities, why would software be built from SRP things?

<!--more-->

The role of information technology software is to build a model of the outer world. But is there many things in real world that follow SRP?

SRP feels so elegant from the first glance: why isn't it wonderful that every tool you have does only one specific job. And all your tools are always sharp and you know exactly which tool is designed for what kind of job.

<img src="http://www.evansclarke.com.au/Lib/tools.JPG" width="300px"/>


Well, in fact even common instruments are usually multifunctional.

<img src="http://upload.wikimedia.org/wikipedia/commons/8/84/Claw-hammer.jpg" width="300px"/>

It feels like hammer should be a perfect example of SRP, but it is not. 
Hint: Pay attention to what is on opposite sides of the handle: these are two different ends designed to do completely different job.
It is a good example how solution is done based on the process but not on SRP. SRP is too idealistic even for a hammer.
Convenience requires to merge two instruments into one to make it easy to switch from riving in to pulling out.
It always requires in depth integration of functions into processes. 

The pliers show even deeper integration in their design, allowing many processes associated with a wire to be done with using a single tool:


And this multi-functionality factor expands as we move to more complex and famous devices. Like:

<img src="http://store.storeimages.cdn-apple.com/4428/as-images.apple.com/is/image/AppleInc/aos/published/images/i/ph/iphone6/plus/iphone6-plus-box-space-gray-2014?wid=478&hei=595&fmt=jpeg&qlt=95&op_sharpen=0&resMode=bicub&op_usm=0.5,0.5,0,0&iccEmbed=0&layer=comp&.v=1411520743411" width="200px"/>


Moving into another direction: none of two things on the image below follows SRP.
Both of them are carrying not just an electrical charge, but some mass and spin as well. It tells that their behaviour is described by their electromagnetic and gravitational responsibilities. See that two is still not one.

<img src="http://science.jrank.org/article_images/ep201102/science/science982.jpg"/>

Same thing happen in software world: utilities are better when designed to support a specific process and classes are made to simulate real world object that have tons of responsibilities.

So next time you blame ActiveRecord::Base for having 200+ methods, try to think how well it is designed to support a CRUD process of a database entity.

### Summary

Principles discusses in software development always were very hot mainly because all engineering principles are pretty controversial. But I can definitely say that SRP is one of the most controversial among them.



