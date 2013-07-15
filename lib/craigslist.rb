require 'open-uri'

require_relative 'craigslist/persistable'
require_relative 'craigslist/net'
require_relative 'craigslist/categories'

module Craigslist
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
    INITIALIZING_METHODS.each do |value|
      define_method(value) do |arg|
        Persistable.new(value => arg)
      end
    end

    # Handles dynamic finder methods for valid cities and categories
    def method_missing(name, *args, &block)
      if found_category = category_path_by_name(name)
        Persistable.new(category_path: found_category)
      elsif valid_city?(name)
        Persistable.new(city: name)
      else
        super
      end
    end

    # Returns and array of all stored categories
    def categories
      categories = CATEGORIES.keys

      CATEGORIES.each do |key, value|
        categories.concat(value[:children].keys) if value[:children]
      end

      categories.sort
    end

    # Returns true if the given city path is valid
    def valid_city?(city_path)
      begin
        uri = Craigslist::Net::build_city_uri(city_path)
        uri = URI.parse(uri)
        uri.open.status[0] == '200'
      rescue => e
        false
      end
    end

    # Returns true if the given category name is valid
    def valid_category_name?(category)
      category = category.to_sym

      return true if CATEGORIES.keys.include?(category)

      CATEGORIES.each do |key, value|
        if value[:children] && value[:children].keys.include?(category)
          return true
        end
      end

      return false
    end

    # Returns true if the given category path is valid
    def valid_category_path?(category_path)
      CATEGORIES.each do |key, value|
        if value[:path] && value[:path] == category_path
          return true
        end

        if value[:children] && value[:children].values.include?(category_path)
          return true
        end
      end

      return false
    end

    # Returns the category path given the category name, returns false otherwise
    def category_path_by_name(category)
      category = category.to_sym

      return CATEGORIES[category][:path] if CATEGORIES.keys.include?(category)

      CATEGORIES.each do |key, value|
        if value[:children] && value[:children].keys.include?(category)
          return value[:children][category]
        end
      end

      return false
    end
  end
end

# Gateway method for shortcut access to the persistable
def Craigslist(*args, &block)
  Craigslist::Persistable.new(*args, &block)
end
