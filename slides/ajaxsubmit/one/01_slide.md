
!SLIDE 

# AjaxSubmit
## Bogdan Gusiev
### July 2012

!SLIDE bullets incremental
## Web Forms are important

* they live for a very long time
* in general they are the same as they were 10 years ago
* but some things have changed


!SLIDE 

# New web forms requirements

* Submit with ajax
* Small amount of fields
* Inline validation 
* Agile process

!SLIDE 

## Validation is a problem

### Move client side validation to client is main solution

!SLIDE 

# Client side validation

* Separated client side validation code
* Generate client side validations based on Rails validation
* Write validation in JavaScript and execute it in backend

!SLIDE 

# Why like this?

* No way to make 100% reusable
* Huge complexity
* Tons of bugs

!SLIDE 

# Why we can not validate on backend always?

* Forms are small
* Ajax query is fast
  * 100 ms or even less
* Just so easy


!SLIDE 

## Submit a form with ajax  

## obtain data if successful 

### or

## errors if validation failed

!SLIDE 

    @@@ diff
     def create
       @user = User.new(params[:user])
       if @user.save
    -    redirect_to root_path
    +    render json: {redirect: root_path}
       else
    -    render action: "new"
    +    render json: {errors: @user.errors}
       end
     end

!SLIDE 


## Modify form to assign validations

<pre><code>
<span class="diff remove">-  &lt;div class="field"&gt;</span>
<span class="diff add">+  &lt;div class="field" validate="email"&gt;</span>
    &lt;label&gt;Email&lt;/label&gt;
    &lt;input name="user[email]" /&gt;
   &lt;/div&gt;
<span class="diff remove">-  &lt;div class="field"&gt;</span>
<span class="diff add">+  &lt;div class="field" validate="password"&gt;</span>
     &lt;label&gt;Password&lt;/label&gt;
     &lt;input name="user[password]" /&gt;
   &lt;/div&gt;
</code></pre>


!SLIDE 

## Add some JS magic

[https://github.com/bogdan/ajaxsubmit](https://github.com/bogdan/ajaxsubmit)

    @@@ javascript
    $.errors.format ='<div 
      class="validation-message 
        validation-text"></div>';
    $(".ajax-form").ajaxForm()

!SLIDE 

# And a little CSS

    @@@ css
    .validation-text { display: none; }

    .validation-active .validation-text {
      display: block;
      color: red;
    }

!SLIDE 

## And it works!

<img src="/image/works.png"/>


!SLIDE 

* Why to focus on edge cases? 
* Why to deal with tons of generated code?
* Why hardcore debugging?

## You don't get all these pain in work flow above


!SLIDE 

# But this is not the end

!SLIDE 

# Inline validation 
# require good formatting
# which yield
# DESIGN/CSS overhead

!SLIDE 

# DESIGN/CSS overhead

* Design:
  * Errors overlaps page content
  * Form starts to jump around when validation appears
  * Different forms and input types
* CSS:
  * Different forms and input types
  * Implement a beauty of the design


!SLIDE 

# Three variants of design:

* Show errors in flat page flow
* Show errors on hover
* Show errors in popup-like box with close button

[http://ajaxsubmit.heroku.com/](http://ajaxsubmit.heroku.com/)

!SLIDE 

# Solving CSS overhead

* Flexible formatting configuration
* Custom DOM for any particular validation error

!SLIDE 

# Ajaxsubmit configuration idea

    @@@ javascript
    $.errors = {
      attribute: "validate"
      activationClass: "validation-active"
      format: "<div class='validation-block'>
        <div class='validation-message'></div>
        </div>"
      messageClass: "validation-message"
    }


!SLIDE 

# kk
