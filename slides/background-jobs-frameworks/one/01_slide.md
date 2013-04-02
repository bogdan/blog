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

But when we say "asyncronously" we want to controll this process:


class SendHeavyReportToUser
  @queue = :low
  @retry_exceptions = [Net::SMTPServerBusy, Timeout::Error, Resque::DirtyExit]
  @retry_limit = 3
  @retry_delay = 60 #seconds_to_user @ret
end


user.delay(:priority => 5, :queue => "low", :attempts => 7)


!SLIDE 

## So previous definition of Job was just an MV<strike>P</strike>J (Minimum Valuable Job)


!SLIDE 

Delayed Job:

Minimalistic over a power to build really advanced things




