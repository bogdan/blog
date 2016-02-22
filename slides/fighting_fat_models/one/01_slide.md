


!SLIDE


<script type='text/javascript'>

function reloadSlides () {
  loadSlides(loadSlidesBool, loadSlidesPrefix, true);
  showSlide();
}
</script>

<style>
 .smbullets > ul {
    list-style: none !important;
   }
</style>


# Fighting with fat models
## Bogdan Gusiev

!SLIDE


## Bogdan G.

* is 9 years in IT
* 6 years with Ruby and Rails
  * Long Run Rails Contributor

!SLIDE


# Some of my gems

* [http://github.com/bogdan](http://github.com/bogdan)
  * [Datagrid](https://github.com/bogdan/datagrid)
  * [js-routes](https://github.com/railsware/js-routes)
  * [accepts_values_for](https://github.com/bogdan/accepts_values_for)
  * [furi](https://github.com/bogdan/furi)


!SLIDE

## My Blog

# http://gusiev.com

!SLIDE bullets incremental



# ![Talkable](http://d2jjzw81hqbuqv.cloudfront.net/assets/static/logo-dark-large.png)

## http://talkable.com

* A small startup is a great place 
  to move from middle to senior and above

!SLIDE smbullets incremental

# Fat Models 

## Why the problem appears?

* All business logic code goes to *model by default*.

!SLIDE

# In the MVC:
## Why it should not be in controller or view?

Because they are hard to: 

* test
* maintain
* reuse



!SLIDE smbullets incremental


## A definition of being fat

* **<h2>1000 Lines of code</h2>**

* But it depends on:

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


!SLIDE smbullets incremental

## Existing techniques

* Services 
  * Separated utility class
* Concerns
  * Modules that get included to models
* Presenters/Wrappers
  * Classes that wrap existing model to plug new methods




!SLIDE smbullets incremental

## What do we expect?

* Standard:

  * *Reusable* code
  * Easy to *test*
  * Good API

* Advanced:
  * Effective data model
  * *MORE* features per second
  * Data Safety

!SLIDE

# Good API

Is a user connected to facebook?

    @@@ ruby
    user.connected_to_facebook?
    # OR
    FacebookService.connected_to_facebook?(user)
    # OR
    FacebookWrapper.new(user)
      .connected_to_facebook?


!SLIDE

# The need of Services

## When amount of utils 
## that support Model goes higher 

## extract them to service is good idea.

!SLIDE

## Move class methods between files is cheap

    @@@ ruby

    # move
    (1) User.create_from_facebook
    # to
    (2) UserService.create_from_facebook
    # or
    (3) FacebookService.create_user


!SLIDE smbullets incremental


## Organise services by *process* 
## rather than **object** they operate on

* Otherwise at some moment UserService would not be enough


!SLIDE

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


!SLIDE

# Services **don't** 
# provide *default behavior*

!SLIDE bullets incremental

## The Need of Default Behavior

Object should encapsulate behavior:

* Data Rules
  * Set of rules that a model should fit at the programming level
    * Ex: A comment should have an author
* Business Rules
  * Set of rules that a model should fit to exist in the real world
    * Ex: A comment should deliver an email notification


!SLIDE

# What is a model?

##The model is an imitation of real object 
##that reflects some it's behaviors
##that we are focused on.

##### Wikipedia

!SLIDE bullets incremental

# Model
## is a best place for *default behaviour*

* MVC authors meant that

!SLIDE bullets incremental

# Implementation

Using built-in Rails features:

* ActiveRecord::Callbacks


!SLIDE

## Hooks in models

We create default behavior and our data is safe.

Example: Comment can not be created without notification.

    @@@ ruby
    class Comment < AR::Base
      after_create :send_notification
    end


!SLIDE

## API comparison

    @@@ ruby
    Comment.create
    # or
    CommentService.create

!SLIDE

## Successful Projects tend to do 
# *one thing* 
## in many different ways
## rather than a lot of things

!SLIDE

* Comment on a web site
* Comment in native mobile iOS app
* Comment in native mobile Android app
* Comment by replying to an email letter
* Automatically generate comments


!SLIDE

# Team Growth Problem
## How would you deliver a knowledge that comment should be made like this to 10 people?

    @@@ ruby
    CommentService.create(...)

!SLIDE

## Reimplement other person's API 
## has more wisdom than invent new one.

    @@@ ruby
    Comment.create(...)
    
!SLIDE

# **Edge cases**

### In all cases data created in regular way
### In one edge cases special rules applied



!SLIDE

## Service with options


    @@@ ruby
    module CommentService
      def self.create(
        attrs, skip_notification = false)
    end

!SLIDE

# *Default behavior* 
# and **edge cases**



* Hey model, create my comment.
  * Ok
* Hey model, why did you send the notification?
  * Because you didn't say you don't need it
* Hey model, create model without notification
  * Ok


!SLIDE

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


!SLIDE

## *Default Behaviour* is hard to make
## But it solves **communication problems**
## that will only increase over time

!SLIDE smbullets incremental

## What is the difference?
    @@@ ruby
    FacebookService.register_user(...)
    
    Comment.after_create :send_notification

* Business rules:

  * User could be registered from facebook
  * Comment should send an email notification

!SLIDE

<br/>
<br/>
# Model stands for *should*

# Service stands for *could*

## Please do not confuse *should* with **must**

!SLIDE 

## Where are presenters?


    @@@ ruby

    UserPresenter.new(user)
    # OR
    class User
     include UserPresenter
    end

## Trade an API for less methods in object

!SLIDE 

# More effective presenters?


!SLIDE 

## Example of Service implementation with wrapper

More example at ActiveRecord source code

    @@@ ruby
    class StiTools
      def self.run(from_model, to_model)
        new(from_model, to_model).perform
      end

      private
      def initialize(from_model, to_model)

      def perform
        shift_id_info
        set_to_model_autoincrement
        set_from_model_autoincrement
        shift_id_in_from_model
      end
    end

!SLIDE 

## Datagrid Gem

### Example of collection wrapper 
### https://github.com/bogdan/datagrid

    @@@ ruby
    UsersGrid.new(
      last_request: Date.today, 
      created_at: 1.month.ago..Time.now)

    class UsersGrid
      scope { User }

      filter(:created_at, :date, range: true)
      filter(:last_request_at, :datetime, range: true)
      filter(:ip_address, :string)
        
      column(:id)
      column(:email)
      column(:last_request_at)
    end



!SLIDE 

# Wrapping Data

https://github.com/bogdan/furi

    @@@ ruby

    u = Furi.parse(
      "http://bogdan.github.com/index.html")
    u.subdomain # => 'bogdan'
    u.extension # => 'html'
    u.ssl?      # => false

    module Furi
      def self.parse(string)
        Furi::Uri.new(string)
      end
    end

!SLIDE 

## Service usage is inconvinient

### because of validation


    @@@ ruby
    Customer.has_many :purchases
    Purchase.has_many :ordered_items
    OrderItem.belongs_to :product
    
    ManualOrder.ancestors.include?(
      ActiveRecord::Base) # => false

    order = ManualOrder.new(attributes)
    if order.valid?
      order.save_all_those_records_at_once!
    else
      order.errors.to_json
    end

!SLIDE 

# Wrappers/Presenters

## Very specific use

* Wrapper around collection
* Parsing serialised object
* Under-the-hood class inside a service
* Service usage is inconvinient

!SLIDE
## The model is still **fat**. 
## What to do?

!SLIDE

## Use Concerns

    @@@ ruby
    class Comment < AR::Base
      include CommentNotification
      include FeedActivityGeneration
      include Archivable
    end

Rails default: `app/models/concerns/*`

!SLIDE

# Attention! 
## People with **high pressure** or **propensity to suicide**
## Next slide can be considered offensive to your religion

!SLIDE

## Single Responsibility Principle 
# **SUCKS**
## The proof follows

!SLIDE

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


!SLIDE

# Why man made things should?
## The world is unreasonably complext to follow SRP


!SLIDE 

## How a model that suppose to simulate those things
## can have a single responsibility?
# It can't!

!SLIDE 

# *Model Concerns* are unavoidable
## if you want to have a *good model*

!SLIDE
## Concerns are *Vertical slicing*

#### **Unlike MVC** which is horizontal slicing.


!SLIDE



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

!SLIDE


## Ex.1 User + Facebook

* `has_one :facebook_profile` => Model
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
  <td rowspan="2" style="">Presenters</td>
</tr>

<tr>
  <td style="padding-top: 40px; padding-bottom: 40px">Concern</td>
  <td>Concern</td>
  <td>Concern</td>
</tr>

</table>


!SLIDE


# Concerns Base

* Attributes
* Associations
  * `has_one`
  * `has_many`
  * `has_and_belongs_to_many`

## But rarely

* `belongs_to`



!SLIDE

## Libraries using Concerns

* ActiveRecord
* ActiveModel
* Devise
* Datagrid

<!--##### If it is *possible* for such a **complicated library** -->
<!--##### then it is **easy** for *regular projects*-->



!SLIDE

# Summary

!SLIDE

# Inject Service between Model and Controller
## if you need them

!SLIDE
# *Could?*  => **Service**
# *Should?* => **Model**

!SLIDE 

# SRP is a misleading principle

## It should not inhibit you from having
## a Better Application Model

!SLIDE
# **Fat** models => *Thin* Concerns 

!SLIDE
## *Reimplement* other person's API 
## has more wisdom than **invent new** one.

!SLIDE 

# *Presenters*
## are pretty **specific**
## Use them in

* Wrapping the collection
* "private" class
* Service usage is inconvenient


!SLIDE

# The **End**

## Thanks for *your time*

### [http://gusiev.com](http://gusiev.com)
### [https://github.com/bogdan](https://github.com/bogdan)
