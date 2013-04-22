require 'open-uri'
require 'nokogiri'

require_relative 'craigslist/cities'
require_relative 'craigslist/categories'
require_relative 'craigslist/craigslist'
require_relative 'helpers'

module Craigslist
  PERSISTENT = Persistent.new

  class << self
    def cities
      CITIES.keys.sort
    end

    def categories
      categories = CATEGORIES.keys
      CATEGORIES.each do |key, value|
        categories.concat(value['children'].keys) if value['children']
      end
      categories.sort
    end

    def city?(city)
      CITIES.keys.include?(city)
    end

    def category?(category)
      return true if CATEGORIES.keys.include?(category)

      CATEGORIES.each do |key, value|
        if value['children'] && value['children'].keys.include?(category)
          return true
        end
      end

      return false
    end

    # Create city methods
    CITIES.each do |key, value|
      define_method(key.to_sym) do
        Craigslist::PERSISTENT.city = value
        self
      end
    end

    # Create category methods
    CATEGORIES.each do |key, value|
      if value['path']
        define_method(key.to_sym) do
          Craigslist::PERSISTENT.category = value['path']
          self
        end
      end

      if value['children']
        value['children'].each do |key, value|
          define_method(key.to_sym) do
            Craigslist::PERSISTENT.category = value
            self
          end
        end
      end
    end

    def build_uri(city_path, category_path)
      "http://#{city_path}.craigslist.org/#{category_path}/"
    end

    def more_results(uri, result_count=0)
      uri + "index#{result_count.to_i * 100}.html"
    end

    def last(max_results=20)
      raise StandardError, "city and category must be part of the method chain" unless
        Craigslist::PERSISTENT.city && Craigslist::PERSISTENT.category

      uri = self.build_uri(Craigslist::PERSISTENT.city, Craigslist::PERSISTENT.category)
      search_results = []

      for i in 0..(max_results / 100)
        uri = self.more_results(uri, i) if i > 0
        doc = Nokogiri::HTML(open(uri))

        doc.css("p.row").each do |node|
          search_result = {}

          title = node.at_css(".title1 a")
          search_result['text'] = title.text.strip
          search_result['href'] = title['href']

          if price = node.at_css(".itempp")
            search_result['price'] = price.text.strip
          else
            search_result['price'] = nil
          end

          if location = node.at_css(".itempnr small")
            search_result['location'] = location.text.strip[1..-2].strip # remove brackets
          else
            search_result['location'] = nil
          end

          attributes = node.at_css(".itempx").text

          search_result['has_img'] = attributes.include?('img') ? true : false
          search_result['has_pic'] = attributes.include?('pic') ? true : false

          search_results << search_result
          break if search_results.length == max_results
        end
      end

      search_results
    end
  end
end
