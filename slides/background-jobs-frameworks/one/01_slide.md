!SLIDE 

# Background Jobs Frameworks

## Bogdan G.

### April 2013


### [http://x.gusiev.com/background-jobs-frameworks](http://x.gusiev.com/background-jobs-frameworks)

!SLIDE incremental

## First thing that came 
## to your mind should be

* Resque
* Delayed Job
* SideKick


!SLIDE 


# And this is all about this presentation as well


!SLIDE 


# What is a job?

    @@@ ruby
    class SendHeavyReportToUser
      def self.perform(user)
        user.send_heavy_report
      end
    end

!SLIDE 

## But not every framework think so:


    @@@ ruby
    User.find_somewhere.
      delay.
      send_heavy_report(*args)


!SLIDE 

## The job is an API convention 
# to process something asyncronously


!SLIDE 

## So previous definition of Job was just an MVJ:
# Minimum Valuable Job


!SLIDE 

But when we say "asyncronously" we want to controll this process:



    @@@ ruby
    class SendHeavyReportToUser
      @queue = :low
      @retry_exceptions = 
        [Net::SMTPServerBusy, 
          Timeout::Error, 
          Resque::DirtyExit]
      @retry_limit = 3
      @retry_delay = 60 #seconds
    end


user.delay(:priority => 5, :queue => "low", :attempts => 7)


!SLIDE 


## Delayed Job: Minimalistic 
## Resque: power to build really advanced things

!SLIDE 

# Storing the Queue


!SLIDE 

## Delayed Job propose to store it in default database.

    Delayed::Job.all

## And you know it's API very well

!SLIDE 



## A great benefit to build 
## your own features on top of it

    @@@ ruby
    failed_jobs = Delayed::Job.
      where(:queue => "toxic").
      where("last_failed_at is not null")
    if failed_jobs.any?
      Mail.new(
      :subject => failed_jobs.count.to_s +
        "in enterprise queue now", 
      :body => "..."
      )
    end


I've spend 20 minutes on building this feature 

starting from zero knowledge about DJ

!SLIDE 

## DJ support any document or relational database, 
## but using Redis will have problems.

Because DJ was originally designed with using relation database features.

!SLIDE 

# Resque: must use redis

### Which gives you a power of being modern 
### and troll your friends that still not using it.

!SLIDE 

## The true benefit of Redis over Relation database 
## is that it is 100 times faster

!SLIDE 

## In real world example is Ecommerce site:

* 6 purchases per second  
* 5 large instances running jobs
* 7 seconds per job 

## Resque can process 
## But DJ can not

!SLIDE 

# But you will pay a lot for 
# being that fast and that cool


!SLIDE 

# Redis hates activerecord

    @@@ ruby
    class User < AR::Base
      after_create :fetch_linkedin_profile
      def fetch_linkedin_profile
        Resque.enqueue(
          FetchLinkedinProfile, id
        )
      end
    end

    class FetchLinkedinProfile
      def self.perform(user_id)
        user = User.find(user_id)
      end
    end
    
!SLIDE 

## How it look like from IO standpoint
<div style="font-size: 70%">
<div style="width:48%;float: left">
<ol>
<li>BEGIN </li>
<li>INSERT INTO `users`</li>
<li>RPUSH resque:queue:low</li>
<li>---</li>
<li>COMMIT</li>
</ol>
</div>


<div style="width:48%;float: right">
  <ol>
  <li>---</li>
  <li>---<br/></li>
  <li>---<br/></li>
  <li>LPOP resque:queue:low</li>
  <li>SELECT * FROM users WHERE id = ?<br/>
  </li>
  </ol>
</div>
  <div style="clear:both">&nbsp;</div>
</div>

##    AR::RecordNotFound
&nbsp;
&nbsp;
&nbsp;

!SLIDE 

    @@@ ruby
    require 'ar_after_transaction'
    require 'resque'
    Resque.class_eval do
      class << self
        alias_method 
          :enqueue_without_transaction, 
          :enqueue
        def enqueue(*args)
          ActiveRecord::Base.after_transaction do
            enqueue_without_transaction(*args)
          end
        end
      end
    end

[http://x.gusiev.com/resque-active-record](http://x.gusiev.com/resque-active-record)

!SLIDE 

# How to debug redis queue?

* You can use resque web
* but what if there are thousands of jobs there?


!SLIDE 

* Resque.redis.client.logger = Rails.logger

* [http://redis.io/commands](http://redis.io/commands)

### You will quickly understand that redis client API 
### is not as good as ActiveRecord API.


!SLIDE 

    @@@ ruby
    Resque.redis.client.logger = 
      Logger.new(STDOUT)

    6.times do
      Resque.enqueue(UpdateMetrics, rand(10))
    end
    # SADD resque:queues low
    # 0.28ms
    # RPUSH resque:queue:low 
    #  {"class":"UpdateMetrics","args":[3]}
    # 0.50ms

!SLIDE 

    @@@ ruby
    Resque.redis.lrange("queue:low", 0, 10).
      map { |job| JSON.parse(job) }

    # LRANGE resque:queue:low 0 10
    # 0.32ms
    # => [{"class"=>"UpdateMetrics", "args"=>[5]},
    # {"class"=>"UpdateMetrics", "args"=>[9]},
    # {"class"=>"UpdateMetrics", "args"=>[3]},
    # {"class"=>"UpdateMetrics", "args"=>[3]},
    # {"class"=>"UpdateMetrics", "args"=>[9]},
    # {"class"=>"UpdateMetrics", "args"=>[3]}]



!SLIDE 

## Do you want to be a part of that debug process?
## Do you have enough free time to learn all new way of doing same things?

# It is for you to decide

!SLIDE 

## Really advanced things

# Statused Worker Example:

!SLIDE 
    @@@ ruby
    Resque.enqueue(
      CreditCardValidator,
      user_id,
      "4123-5682-3821-1111", {...}
    )
    CreditCardValidator.
      in_progress?(user_id) # => true
    CreditCardValidator.
      status(user_id) # => nil
    sleep(5)
    CreditCardValidator.
      in_progress?(user_id) # => false
    CreditCardValidator.
      status(user_id) 
    # => {:success => false, :errors => ["Credit expire date not given"]}

!SLIDE 


    @@@ ruby
    class CreditCardValidator < StatusedWorker
      def self.job_identity_arguments(
          user_id, number, attrs)
        [user_id]
      end
    end

!SLIDE 


    @@@ ruby
    # RESQUE api change: 
    # define perform at instance level
    def perform(user_id, number, , attrs)
      result = validate_card(number, attrs)
      set_status(
        :success => result.success?,
        :errors => result.errors
      )
    end

## [http://x.gusiev.com/statused-worker](http://x.gusiev.com/statused-worker)
But not sure you really need it.


!SLIDE 

# SideKiq example:

## Right from official doc

    @@@ ruby
    class HardWorker
      include Sidekiq::Worker

      def perform(name, count)
        puts 'Doing hard work'
      end
    end

It seems like is even more flexible

!SLIDE 

# Thank You

## [http://gusiev.com](http://gusiev.com)

## [http://github.com/bogdan](http://github.com/bogdan)

## [http://x.gusiev.com/background-jobs-frameworks](http://x.gusiev.com/background-jobs-frameworks)


