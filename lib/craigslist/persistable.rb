require 'nokogiri'

module Craigslist
  class Persistable

    DEFAULTS = {
      limit: 100,
      query: nil,
      search_type: :A,
      min_ask: nil,
      max_ask: nil,
      has_image: false
    }

    def initialize(*args, &block)
      if block_given?
        instance_eval(&block)
        set_uninitialized_defaults_as_instance_variables
      else
        options = DEFAULTS.merge(args[0])

        options.each do |k, v|
          self.send(k.to_sym, v)
        end
      end
    end

    # Fetches results with Nokogiri using initialized attributes from the
    # Persistable
    #
    # @param max_results [Integer]
    # @return [Array]
    def fetch(max_results=@limit)
      raise InsufficientQueryAttributesError.new if
        @city.nil? || @category_path.nil?

      options = {
        query: @query,
        search_type: @search_type,
        min_ask: @min_ask,
        max_ask: @max_ask,
        has_image: @has_image
      }

      uri = Craigslist::Net::build_uri(@city, @category_path, options)
      results = []

      for i in 0..(([max_results - 1, -1].max) / 100)
        uri = Craigslist::Net::build_uri(@city, @category_path, options, i * 100) if i > 0
        doc = Nokogiri::HTML(open(uri))

        doc.css('p.row').each do |node|
          result = {}

          title = node.at_css('.pl a')
          result['text'] = title.text.strip
          result['href'] = title['href']

          info = node.at_css('.l2 .pnr')

          if price = info.at_css('.price')
            result['price'] = price.text.strip
          else
            result['price'] = nil
          end

          if location = info.at_css('small')
            # Remove brackets
            result['location'] = location.text.strip[1..-2].strip
          else
            result['location'] = nil
          end

          attributes = info.at_css('.px').text
          result['has_img'] = attributes.include?('img') || attributes.include?('pic')

          results << result
          break if results.length == max_results
        end
      end

      results
    end

    ##
    # Simple reader methods
    ##

    attr_reader :results

    # @param city [Symbol]
    # @return [Craigslist::Persistable]
    def city=(city)
      @city = city
      self
    end

    # @param category [Symbol, String]
    def category=(category)
      category_path = Craigslist::category_path_by_name(category)
      if category_path
        self.category_path = category_path
      else
        raise ArgumentError, 'category name not found. You may need to set the category_path manually.'
      end
    end

    # @param category_path [String]
    # @return [Craigslist::Persistable]
    def category_path=(category_path)
      @category_path = category_path
      self
    end

    # @param limit [Integer]
    # @return [Craigslist::Persistable]
    def limit=(limit)
      raise ArgumentError, 'limit must be greater than 0' unless
        limit != nil && limit > 0
      @limit = limit
      self
    end

    # @param query [String]
    # @return [Craigslist::Persistable]
    def query=(query)
      raise ArgumentError, 'query must be a string' unless
        query.nil? || query.is_a?(String)
      @query = query
      self
    end

    # @param search_type [Boolean]
    # @return [Craigslist::Persistable]
    def search_type=(search_type)
      raise ArgumentError, 'search_type must be one of :A, :T' unless
        search_type == :A || search_type == :T
      @search_type = search_type
      self
    end

    # @param has_image [Integer]
    # @return [Craigslist::Persistable]
    def has_image=(has_image)
      raise ArgumentError, 'has_image must be a boolean' unless
        has_image.is_a?(TrueClass) || has_image.is_a?(FalseClass)

      # Store this value as an integer
      @has_image = has_image ? 1 : 0
      self
    end

    # @param min_ask [Integer]
    # @return [Craigslist::Persistable]
    def min_ask=(min_ask)
      raise ArgumentError, 'min_ask must be at least 0' unless
        min_ask.nil? || min_ask >= 0
      @min_ask = min_ask
      self
    end

    # @param max_ask [Integer]
    # @return [Craigslist::Persistable]
    def max_ask=(max_ask)
      raise ArgumentError, 'max_ask must be at least 0' unless
        max_ask.nil? || max_ask >= 0
      @max_ask = max_ask
      self
    end

    ##
    # Methods compatible with writing from block with instance_eval also serve
    # as simple reader methods. `Object` serves as the toggle between reader and
    # writer methods and thus is the only object which cannot be set explicitly.
    # Category is the outlier here because it's not accessible for reading
    # since it does not persist as an instance variable.
    ##

    # @param category [Symbol]
    # @return [Craigslist::Persistable]
    def category(category)
      self.category = category
      self
    end

    # @param city [Symbol]
    # @return [Craigslist::Persistable, Symbol]
    def city(city=Object)
      if city == Object
        @city
      else
        self.city = city
        self
      end
    end

    # @param category_path [String]
    # @return [Craigslist::Persistable, String]
    def category_path(category_path=Object)
      if category_path == Object
        @category_path
      else
        self.category_path = category_path
        self
      end
    end

    # @param limit [Integer]
    # @return [Craigslist::Persistable, Integer]
    def limit(limit=Object)
      if limit == Object
        @limit
      else
        self.limit = limit
        self
      end
    end

    # @param query [String]
    # @return [Craigslist::Persistable, String]
    def query(query=Object)
      if query == Object
        @query
      else
        self.query = query
        self
      end
    end

    # @param search_type [Symbol]
    # @return [Craigslist::Persistable, Symbol]
    def search_type(search_type=Object)
      if search_type == Object
        @search_type
      else
        self.search_type = search_type
        self
      end
    end

    # @param has_image [Integer]
    # @return [Craigslist::Persistable, Integer]
    def has_image(has_image=Object)
      if has_image == Object
        @has_image
      else
        self.has_image = has_image
        self
      end
    end

    # @param min_ask [Integer]
    # @return [Craigslist::Persistable, Integer]
    def min_ask(min_ask=Object)
      if min_ask == Object
        @min_ask
      else
        self.min_ask = min_ask
        self
      end
    end

    # @param max_ask [Integer]
    # @return [Craigslist::Persistable, Integer]
    def max_ask(max_ask=Object)
      if max_ask == Object
        @max_ask
      else
        self.max_ask = max_ask
        self
      end
    end

    ##
    # Misc
    ##

    # Clears the Persistable and returns it for continued chaining
    #
    # @return [Craigslist::Persistable]
    def clear
      reset_defaults
      self
    end

    # Provides dynamic finder methods for valid cities and categories
    #
    # @return [Craigslist::Persistable, NoMethodError]
    def method_missing(name, *args, &block)
      if found_category = Craigslist::category_path_by_name(name)
        self.category_path = found_category
        self
      elsif Craigslist::valid_city?(name)
        self.city = name
        self
      else
        super
      end
    end

    private

    # Sets uninitialized defaults as instance variables of the Persistable
    def set_uninitialized_defaults_as_instance_variables
      DEFAULTS.each do |k, v|
        var_name = "@#{k}".to_sym
        if instance_variable_get(var_name).nil?
          self.instance_variable_set(var_name, v)
        end
      end
    end

    # Resets all instance variables of the Persistable
    def reset_defaults
      @city = nil
      @category_path = nil

      DEFAULTS.each do |k, v|
        var_name = "@#{k}".to_sym
        self.instance_variable_set(var_name, v)
      end
    end
  end
end
