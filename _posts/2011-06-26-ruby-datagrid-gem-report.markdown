---

layout: post
title: Easy datagrid builder for Ruby on Rails
published: false
tags: 
- rails
- activerecord
- datagrid
- gem
---

4 years I was working on some enterprise project with a lot of reports. From that time I was thinking about perfect reusable datagrid library that would provide easy DSL to make filters and sortable columns to build reports. Since that time this idea never left my head for a long time And now I finally have opportunity and understanding how to build such tool - [datagrid](https://github.com/bogdan/datagrid).

### Defining the grid

Most of the reports consists of:

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
  column(:active, :header => "Activated")
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
        :group_id => [1,2], :from_logins_count => 1, 
        :category => "first",
        :order => :group,
        :descending => true
)

report.assets # => Array of User instances: 
              # SELECT * FROM users WHERE users.group_id in (1,2) AND users.logins_count >= 1 AND users.category = 'first' ORDER BY groups.name DESC

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



### In my TODO list

Current version of datagrid gem have fully document backend. Now I am working on frontend that is already part of the distribution, but not yet documented.

