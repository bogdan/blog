!SLIDE[bg=techtalk_main.png] 

<!--<img src="/file/techtalk_main.png" style=""/>-->

!SLIDE[bg=techtalk_bg.png]


# Fighting with fat models
## Bogdan Gusiev

!SLIDE[bg=techtalk_bg.png] 


## Bogdan G.

* is 9 years in IT
* 6 years with Ruby and Rails
  * Long Run Rails Contributor

!SLIDE[bg=techtalk_bg.png] 


# Some of my gems

* [Datagrid](https://github.com/bogdan/datagrid)
* [js-routes](https://github.com/railsware/js-routes)
* [accepts_values_for](https://github.com/bogdan/accepts_values_for)
* [furi](https://github.com/bogdan/furi)
* [http://github.com/bogdan](http://github.com/bogdan)


!SLIDE[bg=techtalk_bg.png]

## My Blog

# http://gusiev.com

!SLIDE[bg=techtalk_bg.png] 


# ![Talkable](http://d2jjzw81hqbuqv.cloudfront.net/assets/static/logo-dark-large.png)

## http://talkable.com

## A small startup is a great place 
## to move from middle to senior and above

!SLIDE[bg=techtalk_bg.png] 

# Fat Models 
## Why the problem appears?

## All business logic code goes to *model by default*.

!SLIDE[bg=techtalk_bg.png]

# In the MVC:
## Why it should not be in controller or view?

Because they are hard to: 

* test
* maintain
* reuse



!SLIDE[bg=techtalk_bg.png] 


## A definition of being fat
# **1000 Lines of code**

But it depends on:

* Docs
* Whitespace
* Comments

!SLIDE[bg=techtalk_bg.png] 

    @@@ text

    $ wc -l app/models/* | sort -n | tail
         532 app/models/incentive.rb
         540 app/models/person.rb
         544 app/models/visitor_offer.rb
         550 app/models/reward.rb
         571 app/models/web_hook.rb
         786 app/models/site.rb
         790 app/models/referral.rb
         943 app/models/campaign.rb
         998 app/models/offer.rb
       14924 total


!SLIDE[bg=techtalk_bg.png] 

## Existing techniques

* Services 
  * Separated utility class
* Concerns
  * Modules that get included to models




!SLIDE[bg=techtalk_bg.png] 

## What do we expect?

Standard:

* *Reusable* code
* Easy to *test*
* Good API

Advanced:


* Single Origin Principle
* *MORE* features per second
* Data Safety

!SLIDE[bg=techtalk_bg.png]

# Good API

Is a user connected to facebook?

    @@@ ruby
    user.connected_to_facebook?
    # OR
    FacebookService.connected_to_facebook?(user)
    # OR
    FacebookWrapper.new(user)
      .connected_to_facebook?


!SLIDE[bg=techtalk_bg.png] 

# The need of Services

## When amount of utils that supports Model goes higher 

## extract them to service is good idea.

!SLIDE[bg=techtalk_bg.png]

    @@@ ruby

    # move
    (1) User.create_from_facebook
    # to
    (2) UserService.create_from_facebook
    # or
    (3) FacebookService.create_user

### Move class methods between files is cheap

!SLIDE[bg=techtalk_bg.png] 


## Organise services by *process* 
## rather than **object** they operate on

### Otherwise at some moment UserService would not be enough


!SLIDE[bg=techtalk_bg.png] 

## The problem of services


Service is separated utility class.

    @@@ ruby
    module CommentService
      def self.create(attributes)
        comment = Comment.create!(attributes)
        deliver_notification(comment)
      end
    end

#### "Я знаю откуда что берется"


!SLIDE[bg=techtalk_bg.png] 

# Services **don't** 
# provide *default behavior*

!SLIDE[bg=techtalk_bg.png] 

## The Need of Default Behavior

Object should encapsulate behavior:

* Data Validation
  * Set of rules that a model should fit at the programming level
    * A comment should have an author
* Business Rules
  * Set of rules that a model should fit to exist in the real world
    * A comment should deliver an email notification


!SLIDE[bg=techtalk_bg.png] 

# What is a model?

##The model is an imitation of real object 
##that reflects some it's behaviors
##that we are focused on.

##### Wikipedia

!SLIDE[bg=techtalk_bg.png] 

## Implementation

Using built-in Rails features:

* ActiveRecord::Callbacks

Have the following benefits:

* Reduce number of conventions
* Suits to common knowledge - nothing more than Rails

!SLIDE[bg=techtalk_bg.png] 

## Hooks in models

We create default behavior and our data is safe.

Example: Comment can not be created without notification.

    @@@ ruby
    class Comment < AR::Base
      after_create :send_notification
    end


!SLIDE[bg=techtalk_bg.png] 

## API comparison

    @@@ ruby
    Comment.create
    # or
    CommentService.create

!SLIDE[bg=techtalk_bg.png]

## Successful Projects tend to do 
# *one thing* 
## in many different ways
## rather than a lot of things

!SLIDE[bg=techtalk_bg.png]

* Comment on a web site
* Comment in native mobile iOS app
* Comment in native mobile Android app
* Comment by replying to an email letter
* Automatically generate comments


!SLIDE[bg=techtalk_bg.png]

# Team Growth Problem
## How would you deliver a knowledge that comment should be made like this to 10 people?

    @@@ ruby
    CommentService.create(...)

!SLIDE[bg=techtalk_bg.png]

## Reimplement other person's API 
## has more wisdom than invent new one.

    @@@ ruby
    Comment.create(...)
    
!SLIDE[bg=techtalk_bg.png] 

# **Edge cases**

### In all cases data created in regular way
### In one edge cases special rules applied



!SLIDE[bg=techtalk_bg.png] 

## Service with options

Plan A:

    @@@ ruby
    module CommentService
      def self.create_with_notification(attrs)
      def self.create(attrs)
    end


Plan B:

    @@@ ruby
    module CommentService
      def self.create(
        attrs, skip_notification = false)
    end


!SLIDE[bg=techtalk_bg.png] 

# *Default behavior* 
# and **edge cases**


* Hey model, create my comment.
  * Ok
* Hey model, why did you send the notification?
  * Because you didn't say you don't need it
* Hey model, create model without notification
  * Ok


!SLIDE[bg=techtalk_bg.png] 

# Support parameter in model


    @@@ ruby
    class Comment < AR::Base
      attr_accessor :skip_comment_notification
      after_create do
        unless self.skip_comment_notification
          send_notification
        end
      end
    end


`#skip_comment_notification` is used only in edge cases.


!SLIDE[bg=techtalk_bg.png]

## Default Behaviour is hard to make
## But it solves communication problem
## that will only increase over time

!SLIDE

## What is the difference?
    @@@ ruby
    FacebookService.register_user(...)
    
    Comment.after_create :send_notification


!SLIDE[bg=techtalk_bg.png] 

<br/>
<br/>
# Model stands for *should*

# Service stands for *could*

## Please do not confuse *should* with **must**

!SLIDE[bg=techtalk_bg.png] 
## The model is still **fat**. 
## What to do?

!SLIDE[bg=techtalk_bg.png] 

## Use Concerns

    @@@ ruby
    class Comment < AR::Base
      include CommentNotification
      include FeedActivityGeneration
      include Archivable
    end

`app/models/concerns/*`

!SLIDE[bg=techtalk_bg.png]

# Attention! 
## People with high pressure or propensity to suicide
## Better close your eyes and ears

!SLIDE[bg=techtalk_bg.png]

## Single Reponsibility Principle 
# SUCKS
## The proof follows

!SLIDE[bg=techtalk_bg.png]

## There is no a single thing 
## in the universe that follows the SRP

<div class="right">

<img src="http://science.jrank.org/article_images/ep201102/science/science982.jpg"/>
<!--![Proton](http://science.jrank.org/article_images/ep201102/science/science982.jpg)-->

</div>

    @@@ ruby
    class Proton
      include Gravitation
      include ElectroMagnetism
      include StrongNuclearForce
      include WeekNuclearForce
    end

<div class="clear"></div>


!SLIDE[bg=techtalk_bg.png]

# Why man made things should?
## The world is unreasonably complext to follow SRP


!SLIDE[bg=techtalk_bg.png] 
### *Vertical slicing* stands for

## Split things by features 
## but not by objects


#### **Unlike MVC** which is horizontal slicing.


!SLIDE[bg=techtalk_bg.png] 



# Split model into *Concerns*

    @@@ ruby
    class User < AR::Base
      include FacebookProfile
    end

    # Hybrid Concern that provides 
    # instance and class methods
    module FacebookProfile
      has_one :facebook_profile # simplified
      def connected_to_facebook?
      def self.register_from_facebook(attributes)
      def self.connect_facebook_profile(user, attributes)
    end

!SLIDE[bg=techtalk_bg.png] 


## Ex.1 User + Facebook

* `has_one :facebook_profile` => Model
* `#register_user_from_facebook` => Service
* `connect_facebook_profile` => Service
* `connected_to_facebook?`  => Model
  * Every user should know if it is connected to facebook or not

!SLIDE[bg=techtalk_bg.png] 

## Ex.2 Deliver comment notification

* Comment `#send_notification` => Model
  * Default Behaviour
  * Even if exceptions exist

!SLIDE[bg=techtalk_bg.png] 

### Basic application architecture


<table class="full-border">
<tr>
  <td colspan="100%">View</td>
</tr>
<tr>
  <td colspan="100%">Controller</td>
</tr>
<tr>
  <td colspan="3" style="">Model</td>
  <td rowspan="2" style="">Services</td>
</tr>

<tr>
  <td style="padding-top: 40px; padding-bottom: 40px">Concern</td>
  <td>Concern</td>
  <td>Concern</td>
</tr>

</table>


!SLIDE[bg=techtalk_bg.png]


# Concerns Base

* Attributes
* Associations
  * `has_one`
  * `has_many`
  * `has_and_belongs_to_many`

## But rarely

* `belongs_to`



!SLIDE[bg=techtalk_bg.png] 

## Associations and Concerns

Associations is a base for Concerns technique.

* *`belongs_to`* is a *core* of a model 
  * This associations is used in almost all methods.
* *`has_many`* is usually *better* to create a slice
  * Methods with this associations is usually independent.


!SLIDE[bg=techtalk_bg.png] 

## Concerns best practices

* Apply pattern to *multifunctional models* only

* Use *OOP*:
  * Abstract method
  * `super` is super


!SLIDE[bg=techtalk_bg.png] 

## Libraries using Concerns

* ActiveRecord
* ActiveModel
* Devise
* Datagrid

<!--##### If it is *possible* for such a **complicated library** -->
<!--##### then it is **easy** for *regular projects*-->


!SLIDE[bg=techtalk_bg.png] 

## *Flow* nature of a Service
## *Event* nature of a Callback



!SLIDE[bg=techtalk_bg.png] 

# Summary

!SLIDE[bg=techtalk_bg.png]

# Inject Service between Model and Controller
## if you need them

!SLIDE[bg=techtalk_bg.png] 
# *Could?*  => **Service**
# *Should?* => **Model**

!SLIDE 

# SRP is a misleading principle

## It should not inhibit you from having
## a Better Application Model
!SLIDE[bg=techtalk_bg.png] 
# **Fat** models => *Thin* Concerns 

!SLIDE[bg=techtalk_bg.png] 
## *Reimplement* other person's API 
## has more wisdom than **invent new** one.





!SLIDE[bg=techtalk_bg.png] 

# The **End**

## Thanks for *your time*

### [http://gusiev.com](http://gusiev.com)
### [https://github.com/bogdan](https://github.com/bogdan)
