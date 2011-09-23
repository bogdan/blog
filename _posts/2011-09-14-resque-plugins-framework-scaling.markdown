--- 
layout: post
title: 'Resque-way'
published: false
tags: 
- resque
- framework
---

When we start using Resque 2 years ago we were impressed by it's power out of the box and scalability opportunities.
Since that time we made a long pass through Resque internals and many it's plugins, so here we want to share our practical experience using Resque during different phases of Web Application life cycle.

<!--more-->
### Working in development and Running Tests

The first problem we force with was how to organize development for non-ruby people and test environment. My aim was to keep most of the team free from knowledge about Resque and Workers and avoid stubs in tests. This idea was resulted in [inline mode for Resque](https://github.com/defunkt/resque/commit/b4fcfa787e27cc564ad69ef0951d6df72d5b4816) that solved problem perfectly.


### First step in Production: ActiveRecord and Resque

I won't tell you how to deploy with Resque(There are many articles around) but will focus on all issues that wasn't described before.

After two weeks of production it became clear to us that something was wrong between Resque and ActiveRecord. 
In some cases Resque enqueue job inside database transaction, but Redis operations are independent from database transaction: Sometimes worker start working on job before business transaction that create this job commits. After a few ugly solutions that forces us to restructure the code we finally found what we need in [ar\_after\_transaction](https://github.com/grosser/ar_after_transaction) gem.  Here is how to solve the problem in Resque FAQ [How to make Resque job to wait for ActiveRecord transaction commit, so that it see all changes made by that transaction?](https://github.com/defunkt/resque/wiki/FAQ).

### Second step in Production: Outer HTTP APIs with Resque

External HTTP calls use to be a bottle neck in web requests. And they need to be moved to background as well because of unpredictable response time and down time for these APIs. In this case you will probably need the [resque-retry](https://github.com/lantins/resque-retry) plugin (and [resque-scheduler](https://github.com/bvandenbos/resque-scheduler) plugin as it's dependency), that allows you to retry HTTP and any other exception in workers with customizable delay.

The following list of common HTTP errors is in "just try again to fix" category:

``` ruby
@retry_exceptions = [
  Timeout::Error, 
  Errno::ECONNREFUSED,
  Errno::ECONNRESET,
  # errors from your favorite 
  # Net::HTTP wrapping library goes here
]
```

### Third step in Production: Email sending

If you are using external SMTP server to send your email, your next step will be move Email delivery to background with help of Resque, of course. There are number of plugins available, but we choose [resque\_mailer](https://github.com/zapnap/resque_mailer) because it feel right. And even here it didn't work like we want to work out of the box. There was a problem with `Net::SMTPServerBusy` and `Timeout::Error` exceptions that appeared randomly on sending email. [resque-retry](https://github.com/lantins/resque-retry) is also useful here. In case of Resque Mailer we wanted to have shared configuration for resque retry for every Mailer class and it was not 100% easy: Historically Resque is configured through instance variables in a class but they doesn't inherit. We needed a base class that could share all instance variables across any it's child class:

``` ruby
class AsyncApplicationMailer < ActionMailer::Base

  include Resque::Mailer

  extend Resque::Plugins::Retry

  # All Notifiers inherited from this class 
  # require same resque-retry options.
  # Resque workers are classes but not instances of classes.
  # That is why resque retry require class variables that is not inherited
  # In order to setup same resque-retry class variables 
  # for every inherited class we need this hack.
  def self.inherited(host)
    super(host)
    host.class_eval do
      @retry_exceptions = [Net::SMTPServerBusy, Timeout::Error, Resque::DirtyExit]
      @retry_limit = 3
      @retry_delay = 60 #seconds
    end
  end

end
```

Use this class as base class for all your mailers and retry configuration will be shared among them.

### Play Minesweeper: fix all bug along the way

After we get more users and more load we found it a good idea to include plugins like [resque-loner](https://github.com/jayniz/resque-loner) to track job uniqueness and [resque-cleaner](https://github.com/ono/resque-cleaner) to cleanup failed jobs.

Going through this required to fix and improve all these libraries: 

* [Fix resque-scheduler process death after pushing invalid resque job class](https://github.com/bvandenbos/resque-scheduler/commit/7f65bba3bf9ec066b114c95a42b3a8b58736ff16)
* [Fix infinitive recursion in edge case usage of ar\_after\_transaction](https://github.com/grosser/ar_after_transaction/commit/a59386e31939d64a5c0f78b8732a29499ac97fae)
* [Make resque-mailer to respect the `ActionMailer::Base.perform_deliveries` configuration option](https://github.com/zapnap/resque_mailer/issues/3)
* [Fix resque-retry suppression in resque failures for jobs with custom identifier](https://github.com/lantins/resque-retry/pull/22)
* [Modulize resque-loner to be compatible with other plugins](https://github.com/jayniz/resque-loner/commit/2ada35a8a080cc2f2540ecf83a8461e4b0b2df0b)

### Business requirements goes higher: Returning result from jobs

Resque original design does not allow you receive something back after worker completes. And maybe it's a good idea for most use cases.
But our use case (payment checkout through outer Authorization gateway) we need to know whether it is in progress or not, and if not - whether it was successful or not. 

Many Resque plugins introduce job identifier based on arguments passed to this job but there is no standardization on how it should be done. 

resque-retry:

``` ruby
  # @abstract You may override to implement a custom identifier,
  #           you should consider doing this if your job arguments
  #           are many/long or may not cleanly cleanly to strings.
  #
  # Builds an identifier using the job arguments. This identifier
  # is used as part of the redis key.
  def identifier(\*args)
```

resque-loner:

``` ruby
 #
 #  Payload is what Resque stored for this job along with the job's class name.
 #  On a Resque with no plugins installed, this is a hash containing :class and :args
 #
 def redis_key(payload)
```

In order to synchronize job identifier across plugins we implemented our own [interface for jobs with completion status](https://gist.github.com/1222167)(don't confuse with execution status in [resque-status](https://github.com/quirkey/resque-status)) that can be a good advice for people that needs something like this.


### Result and Statistics

Our current system at [plumdistrict](http://plumdistrict.com) can serve **6 purchases\* per second** during activity peaks and running **19 workers**. And this is not the end - there is a lot of places to optimize current architecture that just makes more complicated scaling techniques (like Service Orienter Architecture) less necessary right now.

\* "purchase" from technical standpoint is business operation that does 3 HTTP API calls and update data in 3 database tables

### Contribution to open source

Thanks to people that took the responsibility for supporting our patches:

* @bvandenbos/resque-scheduler: Merged. Thanks. Will ship in 1.9.8.
* @defunkt/resque: Love it. ... This is a great patch - docs, tests, and code! Thanks. 
* @zapnap/resque\_mailer: Good point. I just pushed a change to the repository that should take care of this and released a new gem (1.0.1) 
* @jayniz/resque-loner: Awesome, thanks! Will pull ASAP :)
 

[Bogdan Gusiev](https://github.com/bogdan), 2011-09-16
