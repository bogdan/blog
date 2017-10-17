---
layout: post
title: "Naming Things" Solution
tags: 
- principles
- software
- it
- imperfection
---

Naming things in software is really a big deal. It gets harder and harder over time when software gets bigger.
I've never encountered an article that would try to address the issue. Here I will try to define good name criteria as well as 
naming strategies that appeared to be useful in my experience.

<!--more-->

## Name like your users do

The most basic idea of giving a thing like class, method or function a good name is to name by how your users suppose to call it.
Like if there is a tweet in twitter I would assume that there should be a thing named "Tweet" inside twitter source code.
It is as simple as it is, but when you model things right your internal infrastructure just reflects the actual interaction between software users. This principle applies well to the structure we call OOD: the right OOD has maximum number of classes that your users can see through software interface and minimum number of classes that your users can not see. And those things that users can see should have their name from how your users call it or would call it.

Good example when things can get a different name:

Lets say we have Article and Email and both of them are having a header. But in the article it is usually called "title" but in the email it is usually called "subject". If you don't have any shared code between the two, it is better to stick with different names rather than the same: it will make you closer to how your users call it and will avoid unnecessary naming collision that is described later.

It is worse noting that this is not the only one principle to follow. There can be a number of reasons you may go with a different name rather than the name that comes naturally. They are described below.

## Avoid simplifications through naming

If there is some completely new thing that needs to be named for both end users and software, ensure that there is no other thing that has the same name in your software.
Human brain tend to simplify the world around us and use the same name for different things.

Here is a good example:
Suppose your software allows people to subscribe to newsletter and to unsubscribe from email notifications.
In this case, human brain interprets this two possibilities as logically opposite while they are not: there is actually three states the person can have: subscribed to newsletter, unsubscribed from email notification and undefined (or default). Practically it can even result in 2 separated options with "Yes/No" possibility. Even though all software developers in your team understand the difference, you can not expect all people in the world to understand that.
In order to avoid the automatic simplification, you'd better call those states: opted in for newsletter (or simply `opted_in` internally) and unsubscribed from email notifications (or simply `unsubscribed` internally).

The idea that "Opted In" should stuck as a term for newsletter subscription and "Unsubscribed" should stuck for email notifications. When people speak fast, they will always shorten those terms. It means that through the daily conversation certain verbs will be used instead of describing the entire action. Example: "How many subscribed people do we have?" will have some uncertainty in case "to subscribe" will be used for both: describing newsletter subscription and notification emails subscription instead of just one.

## Naming Uniqueness

Here is a good example from my practice on how naming uniqueness can be broken:
English has two words "Company" and "Campaign". In my native tongue they actually translated into a single word: "Компания" /compania/. It is better to just avoid using this both terms for naming in the international team. While this is pretty rare case, it gives the idea on how naming problem appears: Russian conversation don't make a difference between 2 things that pretty different. Same case appears naturally withing single language all the time.

The other source of naming collision can still be a fast speech between team members.
Suppose your software can do a "WebPageSnapshot" as well as "ServerSnapshot"
When people speak fast, they will tend to use "Snapshot" for both terms. It can lead to misunderstanding in daily conversation.
The phrase: "I made a patch that touches a snapshot source code, please take a look" doesn't define the actual place to look at. It will almost certainly lead to time waste from people assumptions they understood each other. Either the speaker or the listener could not be aware that both types of snapshot exist and they may feel natural with the assumption that "Snapshot" can only mean one of the types.
Please only use adjectives to distinguish between terms if they actually same thing at some level of abstraction like:
"VideoFile" and "ImageFile" are just "File" at some levels in your software (in other words: share code and behaviour).

Using same adjectives to ensure things are connected by their names is a good idea.
Consider the business rule: "Affiliate Member" can participate in "Affiliate Campaign". 
We will not make any confusion by using same adjective for both terms. Avoiding adjectives in fast conversation will not be that misleading:
A business rule like: '"Member Affiliate" can participate in "Campaign Affiliate"' is worse than a weapon of mass destruction for communication inside your team.

## Naming internal objects

What I mean by internal here is a thing that is pretty known inside your software but completely unseen by the end users.
Examples from Rails: "UsersController" or "UsersHelper"
Note that there is no problem in calling every controller like "WhateverController" (with the same suffix) because all of those controllers actually share code and behaviour, so they are the same thing at some basic level while "WebPageSnapshot" and "ServerSnapshot" were not in the previous example.
Some subjects are just internal - end users don't interact with them directly. There are some principles that would allow to give them a good name too.
At first, ensure that internal thing doesn't take a name of the thing that is actually available to the end users. This is very important to do: leave good names for things your users care most.

At second,  it is good to give them a longer names to encode more information on what they do. There could be understanding illusion connected to a name. Internals of your software tend to do some specific work. When you give them a short name, software developers tend to assume they understand what they do. It can be a complete illusion. 

At third, sometimes it is even a good idea to give a confusing name to something.
 You may avoid that illusion by giving a name that would cause software developer to never assume what this thing does before looking at it.  
 Choose wisely if you want your developers to assume what a method does based on name or not. These assumptions can be misleading for complex cases. In my project, we have a method called `def fuck_short_url(text)`. It has more comments than lines of code: it makes a very specific replacement of links inside a text fragment and we don't want any developer to assume they know what it does based on name. Here is the method source code for the most curious readers: [https://gist.github.com/7a823c15ac350aaf948668f0fc3a3238](https://gist.github.com/7a823c15ac350aaf948668f0fc3a3238)


## Summary

There could be 3 types of names: 

1. Direct name - like your users call it
2. Descriptive name - long and describing the function of an object or method
3. Strange Name - eliminates the name based assumption

Good principles to follow:

1. Follow naming that was already given by software users or community/business overall
2. Name things uniquely
3. Avoid naming collision through simplification of terms

