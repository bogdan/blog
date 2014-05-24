#<html>
#<head>
#</head>
#<body>
#<p>
#Hello <strong>World</strong>
#</p>
#</body>
#</html>



class Comment
  belongs_to :parent, class_name: "Comment"
  has_many :children, class_name: "Comment", foreign_key: :parent_id

  def add_child(text)
    self.children << Comment.new(:parent => self, text: text)
  end
end

class Tag

  attr_accessor :children
  def initialize(name)
    @name = name
    self.children = []
  end

  def add_tag(name)
    tag = Tag.new(name)
    children << tag
    tag
  end

  def add_text(text)
    children << text
  end

  def to_html

  end
end

h = Tag.new(:html)
h.add_tag(:head)
body = h.add_tag(:body)
p = body.add_tag(:p)
p.add_text("Hello")
strong = p.add_tag("strong")
strong.add_text("World")
h.to_html



