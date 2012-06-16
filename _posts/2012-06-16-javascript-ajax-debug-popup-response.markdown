---
layout: post
title: 'How many clicks do you need to debug ajax request?'
tags: 
- javascript
- debug
- ajax
- efficiency
---


Here I am gonna use Chrome browser as an example:

1. Open context menu
2. Click inspect element.
3. Click "Network" tab
4. Spawn again an ajax request (at least one click. Sometimes more)
5. Click on failed request at Network tab
6. Click "Preview" or "Response" subtab

<!--more-->

<img width="400px" src="http://i.imm.io/skBN.png"/>

### THIS IS A LOT AND THIS SHOULD CHANGE

With [this tiny script](https://github.com/bogdan/jquery-ajax-debug) you don't need any:
Error response will be displayed in Popup at once after it occur.

<img width="400px" src="http://i.imm.io/skDh.png"/>



