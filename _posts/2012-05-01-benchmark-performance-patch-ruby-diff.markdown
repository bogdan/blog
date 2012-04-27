---
layout: post
title: 'Benchmark your performance patches'
published: true
tags: 
- gem
- contribution
- performance
---

After a dozen performance patches to many gems in the last 6 months I want to share some practical experience I gain. 
Tools I've picked up was **ruby-prof** and ruby **built-in benchmark** library.
They are fit well for cases when optimization doesn't go to C level and stays on Ruby level. 

<!--more-->

General flow on how to tackle performance is clear:

* [Ruby-prof](https://github.com/rdp/ruby-prof#ruby-prof-api) shows top slow method calls.
* [Benchmark](http://ruby-doc.org/stdlib-1.9.2/libdoc/benchmark/rdoc/Benchmark.html) proves that we made an improvement.

And it was quite hard to start with benchmarking and profiling tools. But fortunately there is a lot of docs available with some examples.

This flow works fine till the moment when benchmark results before and after patch should be compared. 
Ruby Benchmark can not merge them together and represent in a human readable form like this:

    Running benchmark with current working tree
    Checkout HEAD^
    Running benchmark with HEAD^
    Checkout to previous HEAD again

                        user     system      total        real
    ----------------------------------headers parsing when long
    After patch:    0.100000   0.000000   0.100000 (  0.089926)
    Before patch:   0.700000   0.000000   0.700000 (  0.697444)

    ----------------------------------headers parsing when tiny
    After patch:    0.000000   0.000000   0.000000 (  0.009930)
    Before patch:   0.020000   0.000000   0.020000 (  0.024283)

    ---------------------------------headers parsing when empty
    After patch:    0.010000   0.000000   0.010000 (  0.002160)
    Before patch:   0.000000   0.000000   0.000000 (  0.002354)

So, decided to create a library that fixes this problem.
Try out **[DiffBench](https://github.com/bogdan/diffbench)** if you ever come up with performance patch.

DiffBench in action examples:

* Rails
  * ActiveRecord - [#5467](https://github.com/rails/rails/pull/5467)
  * ActiveModel - [#5431](https://github.com/rails/rails/pull/5431)
  * ActiveSupport - [#4493](https://github.com/rails/rails/pull/4493)
  * ActionPack - [#5957](https://github.com/rails/rails/pull/5957)
* Mail - [#396](https://github.com/mikel/mail/pull/369), [#366](https://github.com/mikel/mail/pull/366)



