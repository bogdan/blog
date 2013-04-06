!SLIDE 

# Background Jobs Frameworks

## Bogdan G.

### April 2013


### [gusiev.com/slides/background-jobs-frameworks/static](http://gusiev.com/slides/background-jobs-frameworks/static)

!SLIDE incremental

## First thing that came 
## to your mind should be

* Resque
* Delayed Job
* SideKiq


!SLIDE 


# And this is all about this presentation as well


!SLIDE 


# What is a job?

class SendHeavyReportToUser
  def self.perform(user)
    user.send_heavy_report
    
  end
end

!SLIDE 

# But not every framework think so:

User.find_somewhere.delay.send_heavy_report(*args)


!SLIDE 

The job is an API convention to process something asyncronously.


!SLIDE 

## So previous definition of Job was just an MV<strike>P</strike>J (Minimum Valuable Job)


!SLIDE 

But when we say "asyncronously" we want to controll this process:


class SendHeavyReportToUser
  @queue = :low
  @retry_exceptions = [Net::SMTPServerBusy, Timeout::Error, Resque::DirtyExit]
  @retry_limit = 3
  @retry_delay = 60 #seconds_to_user @ret
end


user.delay(:priority => 5, :queue => "low", :attempts => 7)


!SLIDE 


## Delayed Job: Minimalistic 
## Resque: power to build really advanced things



!SLIDE 

Storing the Queue


!SLIDE 

Delayed Job propose to store it in default database.

Delayed::Job.all

And you know it's API very well

!SLIDE 

A great benefit to build your own features on top of it

Example:
failed_jobs = Delayed::Job.where(:queue => "enterprise").where("last_failed_at is not null")
if failed_jobs.any?
Mail.new(:subject => "We have #{failed_jobs.count} in enterprise queue now", :body => "...")
end


I've spend 20 minutes on building this feature 
starting from zero knowledge about DJ

!SLIDE 

DJ support any document or relation database, 
using Redis will have problems.

Because DJ was originally designed with using relation database features.

!SLIDE 

Resque: must use redis

Which gives you a power of being modern 
and troll your friends that still not using it.

!SLIDE 

The true benefit of Redis over Relation database 
is that it is 100 times faster

!SLIDE 

But you will pay a lot for being cool


!SLIDE 

Redis dont love activerecord

class User < AR::Base
  after_create :fetch_linkedin_profile
  def fetch_linkedin_profile
    Resque.enqueue(FetchLinkedinProfile, id)
  end
end

class FetchLinkedinProfile
  def self.perform(user_id)
    user = User.find(user_id)
  end
end
    
!SLIDE 
<div>
<div style="float: left">
1. SQL: BEGIN
2. SQL: INSERT INTO `users`
3. Redis: RPUSH resque:queue:low 
4. SQL: database has to do some staff
5. SQL: database is still doing something
6. SQL COMMIT
</div>


<div style="float: right">
1. ---
2. ---
3. ---
4. Redis: LPOP resque:queue:low
5. SQL: SELECT * FROM users WHERE id = ?

=> AR::RecordNotFound
<div style="clear:both"></div>
</div>
</div>


!SLIDE 

    require 'ar_after_transaction'
    require 'resque'
    Resque.class_eval do
      class << self
        alias_method :enqueue_without_transaction, :enqueue
        def enqueue(*args)
          ActiveRecord::Base.after_transaction do
            enqueue_without_transaction(*args)
          end
        end
      end
    end
http://x.gusiev.com/12eFsaF

!SLIDE 

How to debug redis queue?

* You can use resque web
* but what if there are thousands job there?


!SLIDE 

Resque.redis.client.logger = Rails.logger

[http://redis.io/commands](http://redis.io/commands)

You will quickly understand that redis client API is not as good as ActiveRecord API.


!SLIDE 
Resque.redis.client.logger = Logger.new(STDOUT)

6.times do
  Resque.enqueue(UpdateMetrics, rand(10))
end
# SADD resque:queues low
# 0.28ms
# RPUSH resque:queue:low {"class":"UpdateMetrics","args":[3]}
# 0.50ms

!SLIDE 
Resque.redis.lrange("queue:low", 0, 10).map do |job|
  JSON.parse(job)
end

# LRANGE resque:queue:low 0 10
# 0.32ms
=> [{"class"=>"UpdateMetrics", "args"=>[5]},
 {"class"=>"UpdateMetrics", "args"=>[9]},
 {"class"=>"UpdateMetrics", "args"=>[3]},
 {"class"=>"UpdateMetrics", "args"=>[3]},
 {"class"=>"UpdateMetrics", "args"=>[9]},
 {"class"=>"UpdateMetrics", "args"=>[3]}]



!SLIDE 

# Do you want to be a part of that debug process?

## It is for you to decide

!SLIDE 

## Really advanced things

# Statused Worker Example:

    user_id = 1
    Resque.enqueue(CreditCardValidator, user_id, "4123-5682-3821-1111", {...})
    CreditCardValidator.in_progress?(user_id) # => true
    CreditCardValidator.status(user_id) # => nil
    sleep(5)
    CreditCardValidator.in_progress?(user_id) # => false
    CreditCardValidator.status(user_id) 
      # => {:success => false, :errors => ["Credit expire date not given"]}

!SLIDE 

## [http://x.gusiev.com/statused-worker](http://x.gusiev.com/statused-worker)

    class CreditCardValidator < StatusedWorker
      def self.job_identity_arguments(user_id, credit_card_number, attributes = {})
        [user_id] # Want each user to run only one job
      end
      # RESQUE api change: define perform at instance level
      def perform(user_id, credit_card_number, , attributes)
        result = validate_card(credit_card_number, attributes)
        set_status(:success => result.success?, :errors => result.errors)
      end
    end

But not sure you really need it.


!SLIDE 

# Thank You

## [http://gusiev.com](http://gusiev.com)

## [http://github.com/bogdan](http://github.com/bogdan)


