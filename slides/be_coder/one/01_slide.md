!SLIDE 

# Why is it better to be coder than architect?

!SLIDE 

## Why is it better to be coder than architect?
# For ME

!SLIDE 

# There was also a marketing name 
## that I didn't manage to copypaste



!SLIDE 

# Who is an architect?

    me: "Человек, который пишет код каждый день,
      может решить эту задачу за 10 минут"

    someone: "Я не пишу код каждый день.
      Я больше по архитектуре."

!SLIDE 

# Architect Fact:

* Handles most modern smart phone in a hand
  * Not less than 1 hour a day
* Thinking about  "Architecture"
  * Not less than 6 hours a day
* Has more than 2 databases in project
  * Better when project is not yet in production
* Have meetings 
  * Not less than 1 hour a day


!SLIDE 

## What is an architecture?

# It is a code reuse metrics

!SLIDE 

# Why this is important?

* Good products tend to make one thing in 10 different ways 
  * over do 10 different things
* Less lines of code is one of the greatest quality metrics

!SLIDE 

## Github Commits

* manage with git command line
* manage though web
* receive as web hooks
* etc.


!SLIDE 

* Easier to maintain
* Less time to write down
* Less bugs
* Works faster


!SLIDE 

# Bugs load over High load

Most people think that when web site becomes popular 
a high load issue becomes a bottle neck.

This is not true for most of the projects: 
reach load problems is harder 
than reach support problems



!SLIDE 

## What is a benefit of using Resque over DelayedJob?

# It uses Redis as backend instead of Mysql

!SLIDE 

# This is the cost 

# but not the benefit!!


!SLIDE 

    
    Delayed::Job Create (0.2ms)   
        INSERT INTO `delayed_jobs` (...) 
                            VALUES (...)


!SLIDE 

    Redis >> SADD resque:queues low
    Redis >> 4.09ms
    Redis >> RPUSH resque:queue:low {...}
    Redis >> 0.28ms

### And BTW how to enable logging in Resque?

!SLIDE 

## Delayed Job:

    Delayed::Job.all

## Resque:

    ???



!SLIDE 

## How many lines of code here?

    @@@ ruby
    class User
      
      def name
        [first_name, last_name].join(" ")
      end

    end


!SLIDE 

# What code to reuse?

* Most Stars in github
* Great guy Bob recommended it


!SLIDE 

# You will now it as soon as you 
# start writing reusable code yourself



!SLIDE 

Random phrase from the internet:

## "Hey! I already know a framework 
## that uses same ideas as Node.js
  
##  It is Visual Basic."


IT is following the loop just like any other industry
And it's ok!


!SLIDE 

### But we should understand that

## Learn classic programming is better

### than learn popular technologies

!SLIDE 

# Advices

 If you said architecture 3 times in a row
 You won't solve the problem in the next hour

!SLIDE 

The gem that doesn't save lines of code is bad gem

(with exception for performance improving gems)

Use something because of good API doesn't worth it at the end.

!SLIDE 

# If you stop thinking about architecture you will have more time to:

* Write reusable code
* Build great product
* Meet deadlines
* Drink beer

!SLIDE 

## Developer quality

* Developer - writes code
* Good Developer - writes reusable code
* Great Developer - rewrites bad code written by other people and reuse it

!SLIDE 

# Great developer is a person that writes reusable code 
# and know what code to reuse

## (in case it is 3rd party)



