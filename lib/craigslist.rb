require 'open-uri'
require 'nokogiri'

require_relative 'craigslist/cities'
require_relative 'craigslist/categories'
require_relative 'craigslist/craigslist'
require_relative 'helpers'

module Craigslist
  PERSISTENT = Persistent.new

  class << self
    def clear
      Craigslist::PERSISTENT.city = nil
      Craigslist::PERSISTENT.category = nil
      Craigslist::PERSISTENT.search = nil
      self
    end

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

    def more_results(uri, result_count=0, search=nil)
      if search
        uri + "&s=#{result_count.to_i * 100}"
      else
        uri + "index#{result_count.to_i * 100}.html"
      end
    end

    def build_city_uri(city_path)
      "http://#{city_path}.craigslist.org"
    end

    SEARCH_TYPE = {
      entire_post: "A",
      only_title:  "T",
    }

    def build_uri(city_path, category_path, search=nil)
      if search
        query_string = Helpers.build_query(
          query: search.fetch(:query),
          srchType: SEARCH_TYPE[search.fetch(:type, :only_title)],
        )

        "#{build_city_uri(city_path)}/search/#{category_path}?%s" % query_string
      else
        "#{build_city_uri(city_path)}/#{category_path}/"
      end
    end

    def search(params)
      Craigslist::PERSISTENT.search = params
      self
    end

    def last(max_results=20)
      raise StandardError, "city and category must be part of the method chain" unless
        Craigslist::PERSISTENT.city && Craigslist::PERSISTENT.category

      uri = self.build_uri(Craigslist::PERSISTENT.city, Craigslist::PERSISTENT.category, Craigslist::PERSISTENT.search)
      search_results = []

      for i in 0..(max_results / 100)
        uri = self.more_results(uri, i, Craigslist::PERSISTENT.search) if i > 0
        doc = Nokogiri::HTML(open(uri))

        doc.css("p.row").each do |node|
          search_result = {}

          title = node.at_css(".pl a")
          search_result['text'] = title.text.strip
          search_result['href'] = title['href']

          info = node.at_css(".l2 .pnr")

          if price = info.at_css(".price")
            search_result['price'] = price.text.strip
          else
            search_result['price'] = nil
          end

          if location = info.at_css("small")
            search_result['location'] = location.text.strip[1..-2].strip # remove brackets
          else
            search_result['location'] = nil
          end

          attributes = info.at_css(".px").text

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
