
!SLIDE 

# Web Forms
## Bogdan Gusiev
### July 2012

!SLIDE bullets incremental

## Web Forms are important

More important than 

* deploy apps to clouds
* follow scrum at 100% 
* have 100% test coverage


!SLIDE 

# *New web forms* **requirements**

* Submit with ajax
* Small amount of fields
* Inline validation 
* Agile process (more features per second)

!SLIDE 

## **Validation** is a problem

### Move *validation to client* is main solution

!SLIDE 

# Client side validation

Different approaches

* *Separated* client validation code
* *Generated* client side validations based on Rails validation
* Write validation *in JavaScript* and execute it in backend

!SLIDE 

# Why like this?

* **No way** to make 100% reusable
* Huge **complexity**
* Tons of **bugs**

!SLIDE 

# Why not to validate on *backend always*?

* Forms are small
* AJAX is our friend
  * 100ms or even less
* Just so easy


!SLIDE 

## Submit a form with ajax  

## obtain data or redirection URL if successful 

### or

## errors if validation failed

!SLIDE 

## Rework server side

<pre><code>
 def create
   @user = User.new(params[:user])
   if @user.save
<span class="diff remove">-    redirect_to root_path</span>
<span class="diff add">+    render json: {redirect: root_path}</span>
   else
<span class="diff remove">-    render action: "new"</span>
<span class="diff add">+    render json: {errors: @user.errors}</span>
   end
 end</code></pre>

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

## some problems still remain

!SLIDE 

# Inline validation 
# require *good formatting*
# which yield
# **DESIGN/CSS overhead**

!SLIDE 

# DESIGN/CSS overhead

* Design:
  * **Errors overlaps** page content
  * **Form jump around** when validation appears
  * Different errors layout
* CSS:
  * input, select, textarea
  * Implement a beauty of the design


!SLIDE 

# Three variants of design:

* Show errors in flat page flow
* Show errors on hover
* Show errors in popup-like box with close button

[http://ajaxsubmit.herokuapp.com/](http://ajaxsubmit.herokuapp.com/)

!SLIDE 

<img src="/image/pointer.png"/>
<br/>
<img src="/image/works.png"/>
<img src="/image/mailtrap.png"/>

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


    @@@ javascript
    $.errors.attribute = "validate"

&amp;

    @@@ html
    <div validate="company company_id">
      <select name="company">...</select>
    </div>

&amp;

    @@@ javascript
    [
      ["company_id", "is blank"],
      ["company", "not included in the list"]
    ]


!SLIDE 
  
    @@@ javascript
    $.errors.activationClass = 
                "validation-active"

&amp;

    @@@ html
    <div class="validation-active" 
      validate="company company_id">
      <select name="company">...</select>
      <!-- Error message here -->
    </div>

&amp;

    @@@ css
    .validation-active select {
      color: red;
    }

!SLIDE 
  
    @@@ javascript
    $.errors.format ='<div 
      class="validation-message 
        validation-text"></div>'

&amp;

    @@@ html
    <div class="validation-active" 
      validate="company company_id">
      <select name="company">...</select>
      <div class="validation-message 
        validation-text">is blank</div>
    </div>

&amp;

### More CSS


!SLIDE 

    @@@ javascript
    $.errors.messageClass = 
             "validation-message"


Place to insert error message into error format

!SLIDE 

## Summary

* Complexity never was a good idea 
* Web Forms 2.0 could be done in a way that doesn't break deadline

!SLIDE 



