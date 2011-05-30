---
layout: post
title: Patching dbext vim plugin to support Rails naming conventions
tags: 
- rails
- vim
- dbext
- patch
- convention
- sql
---

[dbext](http://www.vim.org/scripts/script.php?script_id=356) is an excellent vim plugin that allows you to execute SQL queries directly from vim. For example: `select * from <word under cursor>`. When dbext is used with Rails there is a problem that you can work with some variation of table name like: 

* UserRole
* user\_role\_id
* user\_role\_ids
* user\_role

But still wants to use it as table name in your database queries so that you won't type it manually.

<!--more-->

So, I made it to automatically convert word under cursor into a table name with the following configuration options:

    let g:dbext_table_names_number = 2 
        # 0 - disabled, 1 - singular, 2 - plural
    let g:dbext_table_names_case = 2 
        # 0 - disabled, 1 - camelcase, 2 - underscore

Also there is an option to automatically strip `_id` suffix from word to convert it to table name:

    let g:dbext_table_names_strip_id = 1


All these options match Rails table name convention by default.
Staff in [my dbext fork](http://github.com/bogdan/dbext). 

Once you install it in your vim runtime put your cursor on any table name variation like example above and run `:DBSelectFromTable` to get:

```select * from user_roles```

Other commands are also patched. Please let me know if any bugs found.

Don't know if non-rails developers would love this patch but pretty sure that it won't annoy them. 
Please support [my pull request](https://github.com/zklinger/dbext/pull/1) if you like it.

