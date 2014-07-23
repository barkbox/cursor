# Overview

Cursor is a fork of [Kaminari](https://github.com/amatsuda/kaminari) that has been gutted to perform cursor pagination only for Rails and ActiveRecord

It’s currently a very simple implementation that pages by the id of the primary table.


# Usage

Suppose we have users with ids 1..100


```
> User.page(before: 50).per(5)
=> [#<User id: 49>, #<User id: 48>, #<User id: 47>, #<User id: 46>, #<User id: 45>]  
> User.page(before: 50).per(5).next_cursor
=> 45
> User.page(before: 50).per(5).prev_cursor
=> 49
```

The before id is NOT included in the results. The next and previous cursors are the min and max ids of the returned set, respectively.

```
> User.page(after: 44).per(5)
=> [#<User id: 45>, #<User id: 46>, #<User id: 47>, #<User id: 48>, #<User id: 49>]  
> User.page(before: 50).per(5).next_cursor
=> 49
> User.page(before: 50).per(5).prev_cursor
=> 45
```

Note that the results are reversed from the before. Before implies order desc. After implies order asc. The cursors are similarly reversed. In both before and after, the specified cursor in the request is excluded from the result.

```
> User.page
=> [#<User id: 100>, #<User id: 99>, ... #<User id: 77>, #<User id: 76>]  
```

The default direction is *before* and the default ``per_page`` value is 25.


# Configuration Options

You can configure the following default values by overriding these values using Cursor.configure method.

```
default_per_page  # 25 by default
max_per_page      # nil by default
page_method_name  # :page by default
before_param_name # :before by default
after_param_name  # :after by default
```

There's a handy generator that generates the default configuration file into config/initializers directory. Run the following generator command, then edit the generated file.
```
rails g cursor:config
```

# Contributing

To run the test suite locally against all supported frameworks:
```
bundle install
rake spec:all
```

To target the test suite against one framework:
```
rake spec:active_record_40
```

You can find a list of supported spec tasks by running <tt>rake -T</tt>. You may also find it useful to run a specific test
for a specific framework. To do so, you'll have to first make sure you have bundled everything for that configuration,
then you can run the specific test:
```
BUNDLE_GEMFILE='gemfiles/active_record_40.gemfile' bundle install
BUNDLE_GEMFILE='gemfiles/active_record_40.gemfile' bundle exec rspec ./spec/requests/users_spec.rb
```


