---
layout: post
title: 'New release of Datagrid: Mongoid, Rails Engines and HTML columns support'
tags: 
- datagrid
- gem
- rails
- changelog
---

[Datagrid](https://github.com/bogdan/datagrid) version 0.5.0 has been released. 

Datagrid is a Ruby on Rails plugin that helps you to build and [represent table-like data](http://datagrid.heroku.com) with:

* Customizable filtering
* Columns
* Sort order
* Localization
* Export to CSV

New version has some notable improvements.
<!--more-->

### Mongoid support

Previously Datagrid supported only ActiveRecord ORM. Now Mongoid is also available: [see the demo](http://datagrid.heroku.com/document_reports).

New datagrid driver architecture allows to add yet another ORM in less then [40 lines of code](https://github.com/bogdan/datagrid/blob/master/lib/datagrid/drivers/mongoid.rb).

### HTML columns

In order to use view helpers to render columns You can use `:html` option.
This will call column block in the view context:

{% highlight ruby %}
column(:completed, :html => true) { |asset| asset.completed? ? image_tag("green.gif") : image_tag("red.gif") }
# or do it in partial
column(:actions, :html => true) { |asset| render :partial => "admin/assets/actions", :object => asset }
{% endhighlight %}

Note that in this case html column won't appear in CSV export.

### Table customization with Rails Engines

If You need serious customization of datagrid `<table>` and HTML Columns doesn't help, you can customize datagrid internal views by running:

{% highlight sh %}
rake datagrid:copy_partials
{% endhighlight %}
This will create the following files in your rails root directory:

<pre>
<code>
|~app/
| ~views/
|   ~datagrid/
|     |-_head.html.erb
|     |-_row.html.erb
|     |_table.html.erb
</code>
</pre>

Now You are able to customize whatever You want.
