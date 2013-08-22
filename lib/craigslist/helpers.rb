module Craigslist
  module Helpers

    # Returns an array of all stored categories
    #
    # @return [Array<Craigslist::Categories>]
    def categories
      categories = CATEGORIES.keys

      CATEGORIES.each do |k, v|
        categories.concat(v[:children].keys) if v[:children]
      end

      categories.sort
    end

    # Returns true if the given city path is valid
    #
    # @param city_path [String]
    # @return [Boolean]
    def valid_city?(city_path)
      begin
        uri = Craigslist::Net::build_city_uri(city_path)
        uri = URI.parse(uri)
        uri.open.status[0] == '200'
      rescue => error
        false
      end
    end

    # Returns true if the given category name is valid
    #
    # @param category [Symbol, String]
    # @return [Boolean]
    def valid_category_name?(category)
      category = category.to_sym

      return true if CATEGORIES.keys.include?(category)

      CATEGORIES.each do |k, v|
        if v[:children] && v[:children].keys.include?(category)
          return true
        end
      end

      false
    end

    # Returns true if the given category path is valid
    #
    # @param category_path [String]
    # @return [Boolean]
    def valid_category_path?(category_path)
      CATEGORIES.each do |k, v|
        if v[:path] && v[:path] == category_path
          return true
        end

        if v[:children] && v[:children].values.include?(category_path)
          return true
        end
      end

      false
    end

    # Returns the category path given the category name, returns false otherwise
    #
    # @param category [Symbol, String]
    # @return [String, false]
    def category_path_by_name(category)
      category = category.to_sym

      return CATEGORIES[category][:path] if CATEGORIES.keys.include?(category)

      CATEGORIES.each do |k, v|
        if v[:children] && v[:children].keys.include?(category)
          return v[:children][category]
        end
      end

      false
    end
  end
end
