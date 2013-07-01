module Craigslist
  class Persistable
    def initialize(*args, &block)
      if block_given?
        instance_eval(&block)
        self
      else
        options = args[0]

        options.each do |key, value|
          self.send(key.to_sym, value)
        end

        self
      end

      @results = []
    end

    def fetch(max_results=20)
      uri = Craigslist::Net::build_uri(@city, @category_path)
      search_results = []

      for i in 0..(max_results / 100)
        # uri = self.more_results(uri, i, PERSISTENT.search_query) if i > 0
        doc = Nokogiri::HTML(open(uri))

        doc.css('p.row').each do |node|
          search_result = {}

          title = node.at_css('.pl a')
          search_result['text'] = title.text.strip
          search_result['href'] = title['href']

          info = node.at_css('.l2 .pnr')

          if price = info.at_css('.price')
            search_result['price'] = price.text.strip
          else
            search_result['price'] = nil
          end

          if location = info.at_css('small')
            # Remove brackets
            search_result['location'] = location.text.strip[1..-2].strip
          else
            search_result['location'] = nil
          end

          attributes = info.at_css('.px').text

          search_result['has_img'] = attributes.include?('img') || attributes.include?('pic')

          search_results << search_result
          break if search_results.length == max_results
        end
      end

      @results = search_results
    end

    # Simple reader methods

    attr_reader :results

    # Simple writer methods

    def city=(city)
      @city = city
      self
    end

    def category=(category)
      category_path = Craigslist::category_path_by_name(category)
      if category_path
        self.category_path = category_path
      else
        raise ArgumentError, 'Category name not found. You may need to set the category_path manually.'
      end
    end

    def category_path=(category_path)
      @category_path = category_path
      self
    end

    # Methods compatible with writing from block with instance_eval also serve
    # as simple reader methods

    def city(city=nil)
      if city
        @city = city
        self
      else
        @city
      end
    end

    def category(category)
      self.category = category
      self
    end

    def category_path(category_path=nil)
      if category_path
        @category_path = category_path
        self
      else
        @category_path
      end
    end

    # Other

    def clear
      @city = nil
      @category_path = nil
      self
    end

    def method_missing(name, *args, &block)
      if found_category = Craigslist::category_path_by_name(name)
        self.category_path = found_category
        self
      elsif found_city = Craigslist::valid_city?(name)
        self.city = name
        self
      else
        super
      end
    end
  end
end
