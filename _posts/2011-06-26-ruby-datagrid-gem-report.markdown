---
layout: post
title: Reporting made easy by Datagrid gem for Rails
tags: 
- rails
- activerecord
- datagrid
- gem
- report
---

4 years ago I was working on some enterprise projects with a lot of reports. From that time I was thinking about [perfect report library](https://github.com/bogdan/datagrid) that would provide easy DSL to make filters and sortable columns to build reports and make it all reusable with standard OOP techniques. Since that time this idea never left my head for a long and now finally I have enough knowledge and opportunities to build such tool. 

<!--more-->

### Defining a grid

The idea of Datagrid DSL is to define a scope of ActiveRecord models and define different independent criterias to filter this scope. 
Than convert filtered data to table view with defined columns. So, typical datagrid report consists of:

* A scope of records to query data
* Filters with parameters to make a subsets of this data
* Columns to display this data

And we can easily split their definition with the following ruby DSL

{% highlight ruby %}
class SimpleReport

  include Datagrid

  scope do
    User.includes(:group)
  end

  filter(:category, :enum, :select => ["first", "second"])
  filter(:group_id, :multiple => true)
  filter(:group_name, :header => "Group") do |value|
    self.joins(:group).where(:groups => {:name => value})
  end


  column(:name)
  column(:group, :order => "groups.name")
    self.group.name
  end
  column(:active, :header => "Activated", :order => false)
    !self.disabled
  end
end
{% endhighlight %}

### Grid instance API

And now we can create and manipulate reports:

{% highlight ruby %}
report = SimpleReport.new(
        :order => "group", 
        :descending => true, 
        :group_id => [1,2], 
        :from_logins_count => 1, 
        :category => "first",
        :order => :group,
        :descending => true
)

report.assets # => Array of User instances: 
              # SELECT * FROM users WHERE users.group_id in (1,2) AND users.logins_count >= 1 AND users.category = 'first' ORDER BY groups.name DESC

report.assets.paginate(:page => params[:page]) # => Yes, it is

report.header # => ["Group", "Name", "Activated"]
report.rows   # => [
              #      ["Steve", "Spammers", true],
              #      [ "John", "Spoilers", true],
              #      ["Berry", "Good people", false]
              #    ]
report.data   # => [ header, *rows]

report.to_csv # => Yes, it is
{% endhighlight %}



### What about flexibility?

I love flexibility. That is why datagrid has a lot of things for non trivial use cases.
In order to proof that I'll show you some examples of what you can do:

* [Range filters](https://gist.github.com/7ba4267aa25b6e37eb44)
* [Time sheets aggregation report](https://gist.github.com/4e84d2dad2f2362a9ab4)
* [Daily statistics](https://gist.github.com/8b91694edec900de84be)
* [Extending built in methods](https://gist.github.com/106acfc3fe689564896c)

### Documentation

[Datagrid WIKI](https://github.com/bogdan/datagrid/wiki) is main documentation source of the gem.
Also feel free to ask questions right after this post.

### In my TODO list

Current version of datagrid gem have fully document back-end staff. It's production ready - we are running three projects that use datagrid. Now I am working on front-end that is already part of the distribution, but not yet documented.

