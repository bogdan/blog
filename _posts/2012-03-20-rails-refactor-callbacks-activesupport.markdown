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

Have you ever ask yourself why Rails is slow? Maybe because Ruby is slow or because Rails programmers don't care about performance or because Rails does so many work. Anyway spend 10 minutes reviewing [ActiveSupport::Callbacks file](https://github.com/rails/rails/blob/3-0-stable/activesupport/lib/active_support/callbacks.rb) to understand that Rails internals are not as good as Rails API.

All types of Rails Callbacks(e.g. after\_save, before\_validation, before\_filter) is a generated code mixed up with native code creating a conditional compilation full of code duplication and over complexity. Probably it breaks any programming principle You ever know. And it's a part of a **super cool and modern** framework called "Ruby on Rails".

<!--more-->
## Preparing a strategy

But let's leave this emotions and try to understand what's going on. Callbacks is one of the most critical part of ActiveSupport used in every part of Rails (ActionPack, ActiveRecord, ActiveResource, ActiveModel). And there was [no serious changes in there since 2009](https://github.com/rails/rails/blame/v3.0.10/activesupport/lib/active_support/callbacks.rb). Git log shows that there was a lot of work trying to refactor this library in a past but it's still hard to follow the thread to understand why it looks like this right now.

That make me feel that no body knows what's going on in there. 
And there is a good opportunity to go beyond the limit of possible by refactoring this library or even rewrite it from scratch. But Rails core team would never accept a 1k lines diff with the assumption that it works better than current one. So, it need to be a smooth refactor plan and a proof that every change is making Rails better. 

This proof is a benchmark of course: It's great that AS::Callbacks is simple library from API and dependencies stand point: You can easily have two instances of a library at runtime: old one and new one, and compare their performance.

In this way the performance will always be under control. And this benchmark would be the ultimate reason why Pull Requests should be merged.

## Long Long Way:

#### Patch 1: [Decrease amount of generated code](https://github.com/rails/rails/commit/bf6e29e00759547d5d0e0bab20434a12a449eb48)

`#define_method` is a good way to define method. With the exception that it doesn't support methods with blocks and it is significatly slower.
In case of rails we need to use `eval` in many places to support blocks and performance.
A general pattern that would make your code easier to read: do not let generated method be more than one line of code.

{% highlight ruby %}
class_eval <<-RUBY
def #{method_name}(*args, &block)
  self.call_static_method(#{extra_arg}, *args, &block)
end
RUBY
{% endhighlight %}

This commit doesn't make it perfect but push the code to the right direction.
  
#### Patch 2: [Get rid of useless things](https://github.com/rails/rails/commit/08cc49b919cfa43a19f55b761dba56bc3673b6b7)

It is easy to discover that `@_keyed_callbacks` hash (that suppose to act as cache) doesn't do anything. Because of `unless respond_to?(name)` condition that reject all ways when cache can be hit. 

#### Patch 3: [Simple is better than complex](https://github.com/rails/rails/commit/8483c7c0a612592316dcf6048cc45e8aee101e47)

This patch improves the result `#_compile_options` that use to return an array, while can return just a [single value of this array](https://github.com/rails/rails/commit/8483c7c0a612592316dcf6048cc45e8aee101e47#L0L255).

#### Patch 4: [Make generated code less crazy](https://github.com/rails/rails/commit/3dc80b7fdf7f9d11c64f3de9feb78edf83a9e2a8)

Generated code is evil. We can make it less evil with at least operating a valid peaces of code at any point.
In order to make Callbacks code always operate on valid peaces of code,  it needs to wrap already generated code with condition or block, because Ruby is a recursive grammar.
So, concatenated `Callback#start` and `Callback#end` method into `#apply` method.

#### Patch 5: [Comeback to patch 1](https://github.com/rails/rails/commit/66a587cf5590d37483d8aba64da5022df08ecf07)

This commit finally implements a pattern defined in Patch 1.

#### Patch 6: [Finding new opportunities](https://github.com/rails/rails/commit/7e75dc5d8645b3a63dc4b3df2e624686145500b6)

Now the generated method from Patch 1 and 5 has only one line of code that is static. We don't need to regenerate it each time.
And generate it once if it was not defined before.

#### Patch 7: [Use method as cache for generated code](https://github.com/rails/rails/commit/99433e4ce57afbbeebe706ee2cec1a0362e03b0f)

There is still another generated method (not the one improved in Patches 1,5,6) that is not static and need to be redefined each time when callbacks added, changed or removed.
Let's call it callback runner.  This method acts as cache for all generated code.
This patch makes runner definition lazy: instead of redefine on callback chain change, it's just undefined. And redefinition occur on first callbacks run.

#### Patch 8: [Get rid of useless things again](https://github.com/rails/rails/commit/19357a7b023fd56a5b381cd8894bb520c60cdb59)

There is actually two generated methods. Useful runner improved in Patch 7 and useless runner improved in Patches 2, 5, 6.
And right now it's uselessness has no doubt. This was the most arguable patch and long discussion before everyone came to agreement.
So, useful runner is called directly from `run_callbacks` method that is part of the API.

#### Patch 9: [Improve abstraction](https://github.com/rails/rails/commit/766195563469ce8c081a0937974e3cd2bb84f107)

In some cases usages of AS::Callbacks library was relay on it's internals.
I would say that it's hard to get what is going on in [this line](https://github.com/rails/rails/commit/766195563469ce8c081a0937974e3cd2bb84f107#L0L179). That is why it's reasonable to convert it to documented option of AS::Callbacks instead

#### Patch 10: [Remove inefficient cache](https://github.com/rails/rails/commit/a21b5771ad6673b8743f76d0f883f37bdf11ce4c)

During this long journey, I discovered another cache built into the library. This was special case performance optimization for controller filters in ActionPack called `:per_key` option. New caching schema defined in Patch 7 was much more superior than this one. And it was just ripped out.

#### Patch 11: [Cleanup unused variables](https://github.com/rails/rails/commit/24b75fc40c59bf987630286b1f4007b2688834b6)

Many things got rip out in Patches 8,10. This is just a cleanup.


#### Patch 12: [Reduce complexity be removing useless option](https://github.com/rails/rails/commit/10bac29b330ddda69102d43b77a1e7dba8741c45)

`:rescuable` option of AS::Callbacks doesn't need to exists.
It has only one usage and can be easily implemented outside with native code instead of generated code inside.

This is a list of the most critical improvements.
But there was also tons of minor changes a long the way. You can view them all in [git history](https://github.com/rails/rails/commits/3-0-stable/activesupport/lib/active_support/callbacks.rb).

## Result

#### Benchmark

A [huge benchmark file](https://gist.github.com/1626009) that tests all use cases.

{% highlight diff %}
                    user     system      total        real
New set_callback  0.030000   0.000000   0.030000 (  0.026836)
Old set_callback  0.070000   0.010000   0.080000 (  0.074195)
***********************************************************************
                       user     system      total        real
New define_callbacks  0.020000   0.010000   0.030000 (  0.020878)
Old define_callbacks  0.010000   0.000000   0.010000 (  0.015654)
***********************************************************************
                      user     system      total        real
New run_callbacks  0.010000   0.000000   0.010000 (  0.004305)
Old run_callbacks  0.000000   0.000000   0.000000 (  0.003734)
***********************************************************************
                               user     system      total        real
New run_callbacks with key  0.000000   0.000000   0.000000 (  0.000819)
Old run_callbacks with key  0.000000   0.000000   0.000000 (  0.001410)
***********************************************************************
                      user     system      total        real
New skip_callback  0.020000   0.000000   0.020000 (  0.023353)
Old skip_callback  0.060000   0.000000   0.060000 (  0.052788)

{% endhighlight %}

**`set_callback`** method that is a **bottle neck** in most cases was **improved 3 times**.
There are some side on `define_callbacks` and `run_callbacks`. There will be more patches that solves the problem there as well.

#### Resources

Understanding and implementing all these changes took about 3 month and required to spend many many hours looking into source code.

#### Tools

After all these patches I end up with patch benchmark tool, that helps to keep performance under control when applying new changes.
Check out [diffbench](https://github.com/bogdan/diffbench) if need to benchmark some patch.

#### Conclusion

Generated code is not as evil as it could be. At the beginning I was thinking that I will remove it completely, but now the performance of the library is faster than it could be without generated code. It's was hard to believe from beginning but it's clean right now.
