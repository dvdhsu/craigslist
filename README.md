# Craigslist Gem [![Build Status](https://secure.travis-ci.org/gregstallings/craigslist.png)](http://travis-ci.org/gregstallings/craigslist)

Unofficial Ruby interface for programmatically accessing Craigslist listings.

## Usage

### Instantiation

```ruby
require 'craigslist'

# A direct call to a city or category method will return an instance of the
# internal persistable object
Craigslist.city(:seattle)
=> <Craigslist::Persistable:0x0000 @city=:seattle>

# Additional setter methods can be chained to the persistable

# Setting a category such as :bikes will set the category_path which is mapped
# internally
Craigslist.city(:seattle).category(:bikes)
=> <Craigslist::Persistable:0x0000 @city=:seattle, @category_path="bia">

# Internal search criteria may be more conveniently set using dynamic methods
# for city and category
Craigslist.seattle.bikes
=> <Craigslist::Persistable:0x0000 @city=:seattle, @category_path="bia">

# Any subsequent chained methods will override any previously set attributes
c = Craiglist.seattle.bikes.limit(20).max_ask(200)
=> <Craigslist::Persistable:0x0000
 @city=:seattle,
 @category_path="bia",
 @limit=20,
 @max_ask=200>

c.sfbay.limit(10).max_ask(100)
=> <Craigslist::Persistable:0x0000
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
=> <Craigslist::Persistable:0x0000
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
=> <Craigslist::Persistable:0x0000 @city=:seattle, category_path="bia">
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

## Contributing

Contributions are welcome and appreciated.

## Notice

This software is not associated with Craigslist and is intended for research purposes only. Any use outside of this may be a violation of Craigslist terms of use.

## License

Copyright (c) 2013 Greg Stallings

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
