require_relative 'craigslist/categories'
require_relative 'craigslist/errors'
require_relative 'craigslist/helpers'
require_relative 'craigslist/net'
require_relative 'craigslist/persistable'
require_relative 'craigslist/version'
require 'open-uri'

module Craigslist
  extend Helpers

  INITIALIZING_METHODS = [
    :city, :category, :query, :search_type, :limit, :has_image, :min_ask, :max_ask
  ]

  class << self

    # Create methods to return a new persistable object with the given value set.
    # This essentially creates methods resembling the following:
    #
    # def city(city)
    #   Persistable.new(city: city)
    # end
    #
    INITIALIZING_METHODS.each do |v|
      define_method(v) do |arg|
        Persistable.new(v => arg)
      end
    end

    # Provides dynamic finder methods for valid cities and categories
    #
    # @return [Craigslist::Persistable, NoMethodError]
    def method_missing(name, *args, &block)
      if found_category = category_path_by_name(name)
        Persistable.new(category_path: found_category)
      elsif valid_city?(name)
        Persistable.new(city: name)
      else
        super
      end
    end
  end
end

# Gateway method for shortcut access to the persistable
def Craigslist(*args, &block)
  Craigslist::Persistable.new(*args, &block)
end
