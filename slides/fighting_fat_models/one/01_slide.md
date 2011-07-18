!SLIDE 
# Fighting fat models
## Bogdan Gusiev
### July 2011

!SLIDE 

*Scope* of this presentation:

* Create
* Update 
* Delete

**Not the scope** of this presentation:

* Select

!SLIDE 
##### Why the problem appear?

####All business logic code goes to *model by default*.

<br/>

##### Why it should not be in controller?

#### Because **controller is hard** to test, maintain and reuse.


<br/>

##### Why it should not be in **view**?

#### Because your will be  **doom** forever.


!SLIDE 

## Existing techniques

* Services 
  * Separated utility class
* Observers 
  * Event listeners
* Traits 
  * Modules that get included to models

The problem is to **understand** which one *fit best* for you.



!SLIDE 

## What do we expect?

* *Agile* process
* *Reusability* of the code
* Easy to *test*
* Make the data safe **strict**


!SLIDE 
### The need of Services

When amount of utils that supports Model goes higher support model with service is good idea.

    @@@ ruby

    # move
    User.create_from_facebook
    # to
    UserService.create_from_facebook
    # or
    FacebookService.create_user

!SLIDE 

## Services

The most common way to extract logic from model is create a service.

Service is separated utility class.

    @@@ ruby
    module CommentService
      def create(attributes)
        comment = Comment.create!(attributes)
        deliver_notification(comment)
      end
    end

#### "Я знаю откуда что берется"


!SLIDE 

## Observers

    @@@ ruby
    class CommentObserver < AR::Observer
      def after_create(comment)
        send_comment_notification(comment)
      end
    end

Nothing interesting



!SLIDE 

### Benefits of model and observer


We create default behavior and our data is safe.

Example: Comment can not be created without notification.

    @@@ ruby
    class Comment < AR::Base
      def after_create
        send_comment_notification
      end
    end

Reimplement other person's API has more wisdom than invent new one.

!SLIDE 

## **Edge cases** of data creation


### In all cases data created in regular way
### In one edge cases special rules applied

!SLIDE 

## Services with options

Plan A:

    @@@ ruby
    module CommentService
      def create(attributes, skip_notification = false)
        comment = Comment.create!(attributes)
        unless skip_comment_notification
          deliver_notification(comment)
        end
      end
    end

* Method will be a **mess** as number of options goes higher.
* Don't look very functional stylish

!SLIDE 

## Service with options

Plan B:

    @@@ ruby
    module CommentService
      def create_with_notification(attributes)
      def create(attributes)
    end

Maintenance problems:

* Hard to keep all team informed about all services in the App
* Don't provide default behavior
* Hard to support as number of contexts goes higher


!SLIDE 

## Observers with option


    @@@ ruby

    class Comment < AR::Base
      attr_accessor :skip_comment_notification
    end

    class CommentObserver < AR::Observer
      def after_create(comment)
        unless comment.skip_comment_notification
          send_comment_notification(comment)
        end
      end
    end

* Hard to access to model internals
  * Some observer code stays in model
* Have some problems with testing
* Makes the app more fragmented
* "Not done well in Rails"

!SLIDE 
### Support parameter in model

Solved by not persisted attributes. 

    @@@ ruby
    class Comment < AR::Base
      attr_accessor :skip_comment_notification
      def after_create
        unless self.skip_comment_notification
          send_comment_notification
        end
      end
    end


The property of default behavior in this example:

* Hey model, create my comment.
  * Ok
* Hey model, why did you send the notification?
  * Because you didn't say you don't need it
* Create model without notification
  * Ok

`#skip_comment_notification` is used only in edge cases.


!SLIDE 

## Priorities

####Model stands for **should**

####Service stands for *could*

####Observer stands for *maybe*

!SLIDE 
### The model is still **fat**. What to do?
## *Vertical slicing* with Traits
##### Unlike MVC which is horizontal slicing.

!SLIDE 

### Vertical slicing


Split model into chunks

    @@@ ruby
    class User < AR::Base
      include Traits::User::Facebook
      include Traits::User::Linkedin
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

Traits include all staff that can be defined in model

* Scopes
* Associations
* Validation
* Callbacks


!SLIDE 

#### *ActiveRecord* uses Traits
##### If it is *possible* for such a **complicated library** 
##### then it is easy for regular projects




!SLIDE


### Traits and associations

Associations is a base for Traits technique.

* *`belongs_to`* is a *core* of a model that usually used almost everywhere.
  * This associations is used in almost all methods.
* *`has_many`* is usually *better* to create a slice of functionality.
  * Methods with this associations is usually independent from each other.


<table>
<tr>
<td>belongs_to :company</td>
<td>belongs_to :location</td>
</tr>
<tr>
<td colspan="2">Job</td>
</tr>
<tr>
<td>has_many :candidates</td>
<td>has_many :criterias</td>
</tr>

</table>
!SLIDE 


### Basic application architecture


<table>
<tr>
  <td colspan="3">View</td>
</tr>
<tr>
  <td colspan="3">Controller</td>
</tr>
<tr>
  <td colspan="3" style="padding-top: 0px; padding-bottom: 0px">Thin model</td>
</tr>

<tr>
  <td style="padding-top: 40px; padding-bottom: 40px">Trait</td>
  <td>Trait</td>
  <td>Trait</td>
</tr>

</table>


!SLIDE 



### let's talk about 

### **BIG FAT ENTERPRISE**



!SLIDE 

### Enterprise world


*Agile* projects are *well focused*

**Enterprise** apps use to **do everything**.

That is why:

* More huge web forms
* More complicated data structure 
* More significant updates

!SLIDE 

### When services are getting fatter,
##### there is a need to 
## Extract *Workflow* from service.

!SLIDE 

## Workflow designed to handle huge updates for data


WorkFlow is logic layer controller, because of it's "gathering" role.

Parts of WorkFlow that should be *reused* are extracted to *services*.


    @@@ ruby
    module BillingWorkFlow
      def self.charge(cycle)
        cycle.close!
        cycle.items.each do |item|
          item.charge!
        end
        UserMailer.cycle_charged(cycle).deliver!
        ProjectService.close_stages(cycle.job)
        ProjectService.generate_new_cycle(cycle.job)
        .....
      end
    end


!SLIDE 

## Improve safety of Workflow

* Workflow method designed to have only one usage.
* Protect state attribute from mass assignment

!SLIDE 

## Flow nature and Event nature

Flow :

* goes step by step
* can not be part of each other
* more related on utils 

Event:

* less care about order
* one can spawn more than one other events
* can be parallelized 



!SLIDE 

## Super advanced logic infrastructure

![Architecture](./file/architechture.png)


!SLIDE 

### There is only one 100% reason 
### when this can be broken?



!SLIDE 

### Of course this is 
## Perfomance
#### Others are doubtful

!SLIDE 

## Summary

Every technique has it's own use case:

* Service for helpers
* Traits for strict data model
* Observers for external service notification

!SLIDE 

### The **End**

#### Thanks for *watching*

##### [http://gusiev.com](http://gusiev.com)
##### [https://github.com/bogdan](https://github.com/bogdan)
