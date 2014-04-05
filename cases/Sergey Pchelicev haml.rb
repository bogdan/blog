def hello(word)
  puts 'hello #{word}'
end


%html
  %head
    %title
       Text
  %body
    %p 
       Hello

class DomElement
    attr_reader :name, :children
    
    def initialize(name, level = 0 , parent = nil)
        @name = name
        @level = level
        @parent = parent 
        @children = []
    end
    
    def tag(tag_name, content = nil, &block)
        child =  DomElement.new(tag_name, level + 1, parent)
        @children << child
        child.children << content if content
        yield child if block_given?
        child
    end
    
    def to_s
        result =  "<#{ name}" 
        if children.empty?
          result << "/>" 
        else
          result << ">"
          children.each { |child| result << child.to_s }
          result << "</#{ name }>"
        end
        result
    end
end

dom = DomElement.new(:html)
dom.tag(:head) do |head|
    head.tag(:title, "Text")
end.tag(:body) do |body|
   tag(:p, "Hello")
end

module HamlParser
    extend self
    
    def parse_line(line)
      level = line[/\t+/].to_s.size + 1
      if line.include?("%")   
         tag  = line[/\s+/]
         { :level => level, :tag => tag }
      else
         { :level => level, :content => line.strip }
      end
    end
    
    def parse(input)
        current = root = DomElement.new("")
        input.each_line do |line|
          opts = parse_line(line)
          new_dom = DomElement.new
          # if opts[:level] > current.level
            # current = current.tag(opts[:tag], opts[:content])
          # else 
             while current.level >= opts[:level]
                current = current.parent
             end
             current = current.tag(opts[:tag], content)
          # end 
        end
        root.to_s
    end
end


