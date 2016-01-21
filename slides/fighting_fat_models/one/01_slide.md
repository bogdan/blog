!SLIDE 

# Fighting with fat models
##### and many other problems
## Bogdan Gusiev

!SLIDE 


## Bogdan G.

* is 7 years in IT, 3 years with Ruby and Rails
* Long Run Rails Contributor
* Some of my gems
  * [Datagrid](https://github.com/bogdan/datagrid)
  * [js-routes](https://github.com/railsware/js-routes)

* http://github.com/bogdan



!SLIDE 

## Why the problem appears?

## All business logic code goes to *model by default*.

!SLIDE

## Why it should not be in controller or view?

Because **controller is hard** to 

* test
* maintain
* reuse



!SLIDE 


## A definition of being fat
# **1000 Lines of code**

But it depends on:

* Docs
* Whitespace
* Comments

!SLIDE 

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


!SLIDE 

## Existing techniques

* Services 
  * Separated utility class
* Traits 
  * Modules that get included to models

The problem is to **understand** which one *fit best* for you.



!SLIDE 

## What do we expect?

Standard:

* *Agile*
* *Reusable* 
* Easy to *test*


Specific:

* *MORE* FEATURES PER SECOND
* Make the data  **safe**


!SLIDE 
### The need of Services

#####When amount of utils that supports Model goes higher 

#####extract them to service is good idea.

    @@@ ruby

    # move
    (1) User.create_from_facebook
    # to
    (2) UserService.create_from_facebook
    # or
    (3) FacebookService.create_user

### Move class methods between files is cheap
!SLIDE 


## Organise services by *process* 
## rather than **object** they operate on

### Otherwise at some moment UserService would not be enough


!SLIDE 

## Services

The most common way to extract logic from model is create a service.

Service is separated utility class.

    @@@ ruby
    module CommentService
      def self.create(attributes)
        comment = Comment.create!(attributes)
        deliver_notification(comment)
      end
    end

#### "Я знаю откуда что берется"


!SLIDE 

#### The problem of services
### Services **don't** provide *default behavior*

!SLIDE 

## Need of Default Behavior

Object should incapsulate behavior:

* Data Validation
  * Set of rules that a model should fit at the programming level
    * A comment should have an author
* Business Rules
  * Set of rules that a model should fit to exist in the real world
    * A comment should deliver an email notification


(Circles here)

!SLIDE 

# What is a model?


##The model is an imitation of real object 
##that reflects some it's behaviors
##that we are focused on.

##### Wikipedia

!SLIDE 

## Implementation

Using builtin Rails features:

* ActiveRecord::Callbacks

Have the following benefits:

* Reduce number of conventions
* Suits to common knowledge - nothing more than Rails

!SLIDE 

## Hooks in models

We create default behavior and our data is safe.

Example: Comment can not be created without notification.

    @@@ ruby
    class Comment < AR::Base
      after_create :send_comment_notification
    end


!SLIDE 

## API comparision

    @@@ ruby
    Comment.create
    # or
    CommentService.create

#### Reimplement other person's API 
#### has more wisdom than invent new one.

!SLIDE 

# **Edge cases**

### In all cases data created in regular way
### In one edge cases special rules applied

!SLIDE 

## Service with options

Plan A:

    @@@ ruby
    module CommentService
      def self.create_with_notification(attrs)
      def self.create(attrs)
    end

Maintenance problems:

* Hard to keep all team informed about all services in the App
* Hard to support as number of options goes higher

!SLIDE 

## Services with options

Plan B:

    @@@ ruby
    module CommentService
      def self.create(
        attrs, skip_notification = false)
    end

* Method will be a **mess** as number of options goes higher.
* Don't respect functional paradigm
  * As many functions as possible


!SLIDE 

# *Default behavior* and **edge cases**


The property of default behavior in this example:

* Hey model, create my comment.
  * Ok
* Hey model, why did you send the notification?
  * Because you didn't say you don't need it
* Hey model, create model without notification
  * Ok


!SLIDE 
### Support parameter in model


    @@@ ruby
    class Comment < AR::Base
      attr_accessor :skip_comment_notification
      after_create do
        send_comment_notification \
          unless self.skip_comment_notification
      end
    end


`#skip_comment_notification` is used only in edge cases.



!SLIDE 


###Model stands for *should*

###Service stands for *could*

!SLIDE 
## The model is still **fat**. 
## What to do?

!SLIDE 

## Use traits

    @@@ ruby
    class Comment < AR::Base
      include Traits::Comment::Notification
    end

`Notification` module encapsulates a feature

!SLIDE 
### *Vertical slicing* stands for

## Split things by features 
## but not by objects


#### **Unlike MVC** which is horizontal slicing.


!SLIDE 

### Vertical slicing


Split model into *Traits*

    @@@ ruby
    class User < AR::Base
      include Traits::User::Facebook
      include Traits::State::CanBeDisabled
    end

    module Facebook
      has_one :facebook_profile
      def connected_to_facebook?
      ...
    end

    module CanBeDisabled
      scope :disabled
      scope :enabled
      def disable!
      def disabled?
    end

!SLIDE 


## Ex.1 User + Facebook

* `belongs_to :facebook_profile` => Model
* `#register_user_from_facebook` => Service
* `connect_facebook_profile` => Service
* `connected_to_facebook?`  => Model
  * Every user should know if it is connected to facebook or not

!SLIDE 

## Ex.2 Deliver comment notification

* Comment `#send_notification` => Model
  * Default Behaviour
  * Even if exceptions exist

!SLIDE 

### Basic application architecture


<table>
<tr>
  <td colspan="100%">View</td>
</tr>
<tr>
  <td colspan="100%">Controller</td>
</tr>
<tr>
  <td colspan="3" style="padding-top: 0px; padding-bottom: 0px">Thin model</td>
  <td rowspan="2" style="padding-top: 0px; padding-bottom: 0px">Services</td>
</tr>

<tr>
  <td style="padding-top: 40px; padding-bottom: 40px">Trait</td>
  <td>Trait</td>
  <td>Trait</td>
</tr>

</table>

!SLIDE 

## This is OOP

### Traits include all staff that can be defined in model



!SLIDE


### Dependencies appear

As number of traits grow:

* associations
* attributes

#### Dependency tree

![Model dependency](./file/model_dependency.png)

<!--<table>-->
<!--<tr>-->
<!--<td colspan="4">Model</td>-->
<!--</tr>-->
<!--<tr>-->
<!--<td colspan="2">belongs_to :model1</td> -->
<!--<td colspan="2">belongs_to :model2</td>-->
<!--</tr>-->
<!--<tr>-->
<!--<td>attribute1</td>-->
<!--<td>attribute2</td>-->
<!--<td>attribute3</td>-->
<!--<td>attribute4</td>-->
<!--</tr>-->
<!--<tr>-->
<!--<td colspan="2">has_many :models3</td>-->
<!--<td colspan="2">has_many :models4</td>-->
<!--</tr>-->

<!--</table>-->

!SLIDE 

## Associations and Traits

Associations is a base for Traits technique.

* *`belongs_to`* is a *core* of a model 
  * This associations is used in almost all methods.
* *`has_many`* is usually *better* to create a slice
  * Methods with this associations is usually independent from each other.

!SLIDE 

#### How to not get lost?

## If *A* depends on *B* 
## then **B** should not depend on **A**

!SLIDE 

## Traits best practices

* Apply pattern to *multifunctional models* only
  * `User`
* Traits name space with the same name as model
  * `Traits::User::Facebook`

* Use *OOP*:
  * Abstract method
  * `super` is super

* Api *consistency*
  * "name", "subject", "title" => select one
  * "disabled", "inactive", "deleted" => select one

!SLIDE 

## Libraries using traits

* ActiveRecord
* ActiveModel
* Devise
* Datagrid

<!--##### If it is *possible* for such a **complicated library** -->
<!--##### then it is **easy** for *regular projects*-->


!SLIDE 

## *Flow* nature and *Event* nature


Service has flow nature:

* goes step by step
  * order can matter
* call each other
  * dependent

Observers and Callbacks have event nature:

* one can spawn more than one other events
  * can be parallelized 
* don't call each other
  * can be backgrounded
  



!SLIDE 

## Super advanced logic infrastructure

![Architecture](./file/architechture.png)



!SLIDE 

# Summary


!SLIDE 
### *Could?*  => **Service**
### *Should?* => **Model**
!SLIDE 
## **Fat** models => *Thin* Traits 
#### and sometimes observers
!SLIDE 
### *Reimplement* other person's API 
### has more wisdom than **invent new** one.
!SLIDE 
### If *A* depends on *B* 
### then **B** should not depend on **A**


!SLIDE 

### The **End**

#### Thanks for *watching*

##### [http://gusiev.com](http://gusiev.com)
##### [https://github.com/bogdan](https://github.com/bogdan)
