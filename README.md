# Craigslist Gem 

Unofficial Ruby interface for programmatically accessing Craigslist listings.

## Usage

### Instantiation

```ruby
require 'craigslist'

# A direct call to a city or category method will return an instance of the
# internal persistable object
Craigslist.city(:seattle)
=> <Craigslist::Persistable @city=:seattle>

# Additional setter methods can be chained to the persistable

# Setting a category such as :bikes will set the category_path which is mapped
# internally
Craigslist.city(:seattle).category(:bikes)
=> <Craigslist::Persistable @city=:seattle, @category_path="bia">

# Internal search criteria may be more conveniently set using dynamic methods
# for city and category
Craigslist.seattle.bikes
=> <Craigslist::Persistable @city=:seattle, @category_path="bia">

# Any subsequent chained methods will override any previously set attributes
c = Craiglist.seattle.bikes.limit(20).max_ask(200)
=> <Craigslist::Persistable
 @city=:seattle,
 @category_path="bia",
 @limit=20,
 @max_ask=200>

c.sfbay.limit(10).max_ask(100)
=> <Craigslist::Persistable
 @city=:sfbay,
 @category_path="bia",
 @limit=10,
 @max_ask=100>

# The persistable may also be instantiated given a block of attributes and
# their respective arguments
Craigslist do
  city :seattle
  category :bikes
  limit 10
  query 'road bike'
  search_type :T
  has_image true
  min_ask 100
  max_ask 200
end
=> <Craigslist::Persistable
 @city=:seattle,
 @category_path="bia",
 @limit=10,
 @query="road bike",
 @search_type=:T,
 @has_image=true,
 @min_ask=100,
 @max_ask=200>
```

### Helpers

```ruby
require 'craigslist'

# Return true if the city is a valid subdomain
Craigslist.valid_city?(:seattle)
=> true

# Return an array of internally mapped categories
Craigslist.categories
=> [:bikes, :books, ...]

# Return true if the category is internally mapped to its category path
Craigslist.valid_category?(:bikes)
=> true

# If the desired category is not mapped within the gem, the category_path can
# be set manually
Craigslist.seattle.category_path('bia')
=> <Craigslist::Persistable @city=:seattle, category_path="bia">
```

### Fetching results

```ruby
require 'craigslist'

# In its simplest usage, posts can be output using a chained method syntax
Craigslist.seattle.bikes.fetch
=> [{}, ...n]

# Max results can be specified in an argument to #fetch. Results can span
# multiple pages
Craigslist.seattle.bikes.fetch(150)
=> [{}, ...150]

# Max results can also be specified by setting the limit either in the chained
# method syntax or the block syntax
c = Craigslist.seattle.bikes.limit(10)

# OR

c = Craigslist do
  city :seattle
  category :bikes
  limit 10
end

c.fetch
=> [{}, ...10]
```

## Installation

Add this line to your Gemfile:

```ruby
gem 'craigslist'
```

Then execute:

```bash
$ bundle
```

Or install it yourself as:

```bash
$ gem install craiglist
```

## Documentation

[http://rdoc.info/gems/craigslist](http://rdoc.info/gems/craigslist)

## Support

- Ruby 1.9.3
- Ruby 2.0.0

## Notice

This software is not associated with Craigslist and is intended for research purposes only. Any use outside of this may be a violation of Craigslist terms of use.

## License

Copyright (c) 2013 Greg Stallings. See [LICENSE](https://github.com/gregstallings/craigslist/blob/master/LICENSE) for details.
