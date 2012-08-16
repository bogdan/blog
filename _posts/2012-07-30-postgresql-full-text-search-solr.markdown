---
layout: post
title: Full text search - Solr(Sunspot) vs PostgreSQL 
published: true
tags: 
- solr
- sunspot
- postgresql
- fulltext
- search
---

This is short notes about my experience with full text search based on PostgreSQL and Solr.
Solr was primary used with a help of [Sunspot gem](https://github.com/sunspot/sunspot) that was definitely a good idea, 
but unfortunately caused some drawbacks. PostgreSQL provides full text search out of the box and to my opinion doesn't need any 
additional ruby specific tools other than ORM.
<!--more-->

## TL;DR

PostgreSQL approach is simple and fit well to agile project.
Solr is pretty powerful, but you need to pay for that power. And this is significant cost.
Think twice if you really need this power from the first day of full text search in your project.

## Search index

Solr search index is something you create almost manually by defining a new data schema.
Sunspot sets `after_save` hooks to your model to update it's solr index.

Here is an example of schema definition based on Sunspot gem:

{% highlight ruby %}
class Product < ActiveRecord::Base
  searchable do
    text :title
    text :material
    text :category do
      category.title
    end
    text :brand do
      brand.title
    end
  end # do
end
{% endhighlight %}



PostgreSQL search index might be yet another column in the database, set by pre save hook:

{% highlight ruby %}
class Product < ActiveRecord::Base

  before_validation :set_searchable_content
  protected
  def set_searchable_content
    self.searchable_content = [title, material, category.title, brand.title].join(" ")
  end
end
{% endhighlight %}

And don't forget about database index:

{% highlight sql %}
CREATE INDEX source_idx ON products USING gin(to_tsvector('english', searchable_content)); 
{% endhighlight %}

While this is very basic use case, it shows up the direction where your code will go in each variant.

* Advanced high level DSL with a lot of "unknown unknowns" in Solr case
* Just ruby code that everyone would understand from the first look in case of Postgres

As an example of how you would solve more advanced problem, I want to show facet search implementation:

{% highlight ruby %}
# Suppose to receive a list of ids to count between different categories
def self.search_facets(ids)
  return [] if ids.blank?
  ProductCategory.select("product_categories.id, count(product_categories.id) as product_count").
     joins(:products).
     where("products.id" => ids).
     group("product_categories.id").
end
{% endhighlight %}

While Solr based facet would be easier:

{% highlight ruby %}
Product.search do |s|
  s.keywords params[:query]
  s.facet :category_id
  s.paginate :page => params[:page], :per_page => 10
end
{% endhighlight %}

At first look you might say that Solr way is more clear, but you still don't know what it does in deep details.
Sunspot gives a nice DSL that overlaps with SQL in many things (e.g. [comparison operators](https://github.com/sunspot/sunspot/wiki/Scoping-by-attribute-fields)), while postgres lets use SQL - language you should know already.

There is also easy to spot that Solr and Sunspot tool chain brings more features to you out of the box.
But this is where Solr advantages ends.
Note stat Solr config file is not as readable as Sunspot DSL. 
Here is a short example that tells Solr to do some string transformation before create a search index:

{% highlight xml %}
<fieldType name="text" class="solr.TextField" omitNorms="false">
  <analyzer>
    <tokenizer class="solr.StandardTokenizerFactory"/>
    <!-- remove punctualtion -->
    <filter class="solr.StandardFilterFactory"/>
    <!-- lower case letters -->
    <filter class="solr.LowerCaseFilterFactory"/>
    <!-- language semantic support -->
    <filter class="solr.SnowballPorterFilterFactory" language="English"/>
  </analyzer>
</fieldType>
{% endhighlight %}

When you go deeper into solr you might need to deal with configs like example above.

## Deployment and Testing

Solr is a standalone application and you need to take care about Solr configuration. It is a part of a code since some search business logic depends on it. This might require:

* different solr config files across different branches 
* test suite that covers some config options
* different solr instances launched for development and test environments
* a need to rebuild search index when you switch branches

Postgres built in search doesn't have these problems at all. This will give a significant performance boost in agile process.  Deployment, testing and switching branches doesn't require any full text search specific action.


## Reindex process

Reindex complexity comes from several factors.

First of them is complicated search index that cover more than one model (Ex: `Product.belongs_to :brand` and `Brand#title` should be a part of `Product` index).
It makes both approaches more complex as business logic becomes more complex.

But in case of Solr this is not the only one thing to care.
With database size growth you gain more problems. Solr index do not have that nice migration mechanism and dump transfer tools as Relational databases.
No matter which gem you will use to connect Solr and Relational database: you need to take care when search index schema changes.


## Conclusion

Conceptually I would like my database to respond for every data search operation e.g. full text search.
This is where PostgreSQL is going. But this feature is not that strong now e.g. it still lacks spell checking and result highlight features.
Solr is old school tool having all full text search features you ever imagine, but it's heavy configuration file and technology stack should be easier.


