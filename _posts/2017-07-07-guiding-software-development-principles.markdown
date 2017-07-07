---
layout: post
title: Guiding Software Development Principles
tags: 
- principles
- software
- it
- imperfection
---

It is becoming popular to talk about software development principles from time to time. The new major concepts appear and die due to the fact that most of them are designed to be perfect but they are not. If you would stay in IT long enough, you encounter articles and talks where people discovered an amazing concept "X" that solved all their development problems and brought their team to inevitable success. Unfortunately permanent success is usually temporary or even a self-deception. The truth is: there is no silver bullets in software development just like in any other engineering process. Engineering of world class products requires precise resources control, trade offs and balance between easy and complex, fast and slow, and beautiful and ugly. Here, I will try to explain my guiding software development principles as well as the why-s.

<!--more-->


## Priority Matters

We often forget that most principles don't match not only with the real solutions but also each other: you can not swim and guard clothing at the same time. So first thing you need to consider is priority of your principles. Some of them should be more important than others. In this way you can solve contradiction between them: if there are two principles and they can not be followed at the same time, pick the higher priority one.


## Less is More 

There should be very limited number of principles to follow. More principles under the same concept just creates more contradiction and leaves less room to be situational and follow additional guidelines that would fit best for given problem. I think the ideal number in you "guiding principles" that apply **almost** to everything in your software should be 3. Higher numbers are possible. 

Christian God was so kind that he left us with 10 that still have very small contradiction like: should I steal a weapon from a person that wants to kill me tomorrow? That's an amazing result for human moral that is at least 1000x times older than software development. Based on our level of understanding of software engineering, we can effort only 3 at the same time.

## Build for Humans

Software is always build by humans and for humans. Software should do what it should do in a convenient, fast and robust way. If any principle violates the usefulness of software, it can be only partially followed. And that is fine because principles are imperfect. They should not be taken as dogmas because they are defined imperfectly by imperfect people.

## Getting to the core

So here are principles that guide me through software development sprints as well as through software development marathons:

0. Software should do what it should do.
1. Model the real world
2. Reuse Code
3. Track Dependencies

Lets go through them one by one:

## 1. Model the real world

This is the most important and genius principles I ever encounter that is even older than computers comes for analogue computers: model the real world.
Try to be as close as possible to the piece of world you are modelling in the software: if there are users of your software, there should be a User in your code. If you simulate an iPhone, there should be an essence of iPhone in your software that performs all of its functions no matter how many of them there are. Also this principle requires you to name things right making them closer to processes they simulate. There will be always a gap between how the process is simulated in software and the real process, but this gap needs to be as close as possible to ensure software does things efficiently. 

We tend to think that a software is complex. But the complexity comes from several factors. First is the processes being modeled are complex - here you would need to rethink them to make them simpler. But the second reason is software developer didn't model them right. If you model things as they are, you eliminate second factor. If you model things even better than they are, you can even eliminate the first factor. It is worth mentioning that is only possible if you have a power to alter the process or the process you are modeling doesn't exist yet. This is mostly the case for the modern software. If you are about to make a "select your seat" functionality for the plane ticket, there is no way you can simplify plane seat locations. If you make a new e-commerce web site, you are an author of most processes and can make product finding functionality as simple as possible until you reach a fact that it needs to fit not just your needs but also all your users needs which are quite different. 

## 2. Code Reuse

As you model more and more processes, the code base grows. It needs to be generalized and reused. We all know which problems come from unreused code: bug fixes and changes need to be made more than once that inevitably leads to the lack of consistency in software where buttons that would suppose to do the same thing do it in a slightly or not so slightly different way. But code reuse is more than that: architecture is just a code reuse metric. If you have a code that is easy to reuse, the architecture arises on its own because people tend to reuse existing code instead of writing new. From the other hand, you can measure the "architectureness" of any code piece including third party(aka gems) by counting how many times it is used. That definition is well aligned with the popular idea that architecture is hard to change: if you reuse a particular piece more, it gets harder and harder to change it because the change affects more places. Following this principle also requires a good test coverage. The most reused code is usually the most covered by tests. You can not test everything, but you can define your priority based on number of usages of particular module.

## 3. Track Dependencies

This is the most advanced and the most complex principle of all three. I have heard so many times: "Hey, why couldn't we just break up our code into reusable modules that are independent?" or "Can we just write many independent micro-services?". Yes, this is all about real breaking of software into independent pieces. Many theoretical-software-developers think it is a silver bullet, but it is not. Firstly because you violate Principle 1: model the real world. If things are interconnected and mutually dependent in the real world, you can not model them differently. It is a big talent to be able to find those possibilities with the minimum sacrifices of principles 1 and 2 which are more important to follow, but still sometimes violated due to the need of breaking software into independent modules.
It is worse clarifying that there are 3 level of dependencies:

1. Mutually Dependent
2. One-way Dependent
3. Independent

Here is more formal definition: if you have code blocks A and B, they are totally independent if each block can perform its functions (aka pass all tests written) without other one. They are one-way dependent if A can perform its work without B or vice versa. And, finally, they are mutually dependent if neither can perform its work without another. In most cases, when Rails developers talk about several modules in their app, that is just a bullshit because there is no way one model can perform its work without others. They all are mutually dependent. And this is a very effective design because this is how the real world works: no modules - everything is mutually dependent as much as flowers and bees. You may start modeling pollination process from Bee class and Flower class and even consider them "independent modules" but in a few hours you would end up referencing one from another all the time. 

The name of the principle as "Track Dependencies" comes from the fact that there are 3 level of interdependencies and you should at least stop thinking too abstract about them: figure out how much they are dependent and control that. Usually making things completely independent is unnecessary within one application. One-way dependent is good enough. You in-app dependency tree should be based on your vendor libraries dependency tree that is very well defined. You may consider your Gemfile dependency tree as the ideal dependency tree. Maybe you will come along the same structure in your app but it will be 10 times harder due to reasons that are hard to explain in a small article.

There is far more to say about it, but I'll probably make a dedicated article about "Track Dependencies" later.


## 0. Software should do what it should do. 

As I said earlier. You should always sacrifice principles if you can not build software that meets all the requirements with them.
It is worth admitting that this is due to the fact that you are not a perfect software developer. Maybe the task wants you to be 2x better at software development than you are. And you can not become 2x better in a blink of an eye while your project has deadlines. Most likely you would be able to complete the task following all your principles with infinite resources, but they will not happen any time soon. You need sacrifices due lack of time, brain power, people and restrictions from security, performance, usability and other sources. Those are main reasons that causes the code to look ugly and complex, but never give up the beauty completely.

## Summary

There is more to say about each principle above. It lacks examples but it is hard to find good ones that don't require a lot of context to understand. I'll write a more detailed article on each principle. Also, even thought the priority of principles is pretty important to follow, there might be exceptions. Exceptions are hard to formalize. You should judge them based on your practical experience and still make an internal note why the priority was changes for a particular case, but not the rest.


