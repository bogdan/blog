---
layout: post
title: 'Substitute driven refactoring'
published: false
tags: 
- substitute
- shell
- ruby
- refactoring
---


If you ever find yourself renaming a core class or method in the application you should think about some process automation tools. In case when class name or method name is unique - **Substitute** is the best choice. 

Running sever find/sed commands in console will cover almost all use cases. In case of Rails there is not only one ClassName you need to rename, but also some it's modifications  (underscore\_name, plural/singular form). In order to not touch plural form while working with singular form start from plural form first.
Also there must be some model/controller relationships you might need to cover.

<!--more-->

```
find ./path -type f -exec sed -i 's/OldClassNames/NewClassNames/g'
find ./path -type f -exec sed 's/OldClassName/NewClassName/g'
find ./path -type f -exec sed 's/old_class_names/new_class_names/g'
find ./path -type f -exec sed 's/new_class_name/new_class_name/g'
```

The thing left rename related files and directories. 

```
$old_name="old_class_name"
$new_name="new_class_name"
for filename in $(find -name $old_name*)
 do
  echo $filename;
  w_o_ext=$(echo $filename | sed 's/$old_name/$new_name/g');
  echo $w_o_ext;
  mv $filename $w_o_ext;
done
```

Before you commit:

*	Check that database doesn't store any Class name that is under renaming. Apply migration in "Yes" case.
* Check for super-meta calls where class name or method name is constructed dynamically (you don't do it often, right?)
*	Run your unit tests(you have some, yeah?) and check core pages before commit.
*	Check diff with your version control system



