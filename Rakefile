require 'rubygems'
require 'jekyll'
require "fileutils"
require "sass/plugin"

def f(name)
  File.dirname(__FILE__) + "/" + name
end

def sass
  directory = File.dirname(__FILE__) + "/css"
  Sass::Plugin.options[:template_location] = directory
  Sass::Plugin.options[:css_location] = directory
  Sass::Plugin.check_for_updates
end

def build_git(command)
  git = "git --work-tree=#{f "build"} --git-dir=#{f "build/.git"} #{command}"
  puts git
  output = `#{git}`.strip
  puts output.strip unless output == ""
end

def site
  @site ||= (
    include Jekyll::Filters
    options = Jekyll.configuration({})
    site = Jekyll::Site.new(options)
    site.read_posts('')
    site
  )
end
desc "Start development mode"
task :dev => :build do
  c = Thread.new do
    while true do
      sass
      sleep(1)
    end
  end
  j = Thread.new do
    `ejekyll --server --auto`
  end
  sleep(1)
  c.join
  j.join
end

desc "Build static content"
task :build => [ "build:clean", :tags, :cloud, :sass] do
  unless File.exists? f("build")
    FileUtils.mkdir_p(f("build"))
    `git clone gh:bogdan/bogdan.github.com build`
  end
  begin
    FileUtils.mkdir_p(f("tmp"))
    FileUtils.mv(f("build/.git"), f("tmp"))
    puts `ejekyll --no-auto build`
  ensure
    FileUtils.mv(f("tmp/.git"), f("build"))
  end
end

namespace :build do
  desc "Clean build modifications"
  task :clean do
    build_git "clean -f ."
    build_git "checkout ."
    build_git "fetch origin"
    build_git "merge origin/master"
  end
end

desc "Upload build to github"
task :upload => [:build] do
  build_git "add ."
  build_git "commit -m 'Build #{DateTime.now.to_s}'"
  build_git "push"
end

desc 'Generate tags page'
task :tags do


  FileUtils.mkdir_p("tags")
  site.tags.sort.each do |tag, posts|
    html = ''
    html << <<-HTML
---
layout: tag
title: Posts tagged "#{tag}"
---
    <h1 id="#{tag}">Posts tagged "#{tag}"</h1>
    HTML

    html << '<ul class="posts">'
    posts.each do |post|
      post_data = post.to_liquid
      html << <<-HTML
        <li><a href="#{post.url}">#{post_data['title']}</a></li>
      HTML
    end
    html << '</ul>'

    File.open("tags/#{tag}.html", 'w+') do |file|
      file.puts html
    end
  end

end


desc "Generate tag cloud"
task :cloud do

  FileUtils.mkdir_p("tags")
  html = ''
  keywords = []

  site.tags.sort.each do |category, posts|

    s = posts.count
    if s > 1
      keywords << category
      font_size = 14 + (s*1.8);
      html << "<a href=\"/tags/#{category}.html\" title=\"Pages tagged #{category}\" style=\"font-size: #{font_size}px; line-height:#{font_size}px\" rel=\"tag\">#{category}</a> \n"
    end
  end

  File.open('_includes/cloud.html', 'w') do |file|
    file.puts html
  end

  File.open("_includes/keywords.html", "w") do |file|
    file.write keywords.join(", ")
  end

end

desc "Compile SASS"
task :sass do
  sass
end


