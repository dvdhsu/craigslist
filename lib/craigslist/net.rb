require 'open-uri'

module Craigslist
  module Net
    OPTIONS_MAP = {
      query: 'query',
      search_type: 'searchType',
      has_image: 'hasPic',
      min_ask: 'min_ask',
      max_ask: 'max_ask'
    }

    class << self
      def build_query(params)
        params.map { |k, v|
          if v.class == Array
            build_query(v.map { |x| [k, x] })
          else
            v.nil? ? escape(k) : "#{escape(k)}=#{escape(v)}"
          end
        }.join('&')
      end

      def escape(s)
        URI.encode_www_form_component(s)
      end

      # Returns a Craigslist uri given the city subdomain
      def build_city_uri(city_path)
        "http://#{city_path}.craigslist.org"
      end

      def build_uri(city_path, category_path, options, max_results=nil)
        "#{build_city_uri(city_path)}/#{category_path}/"
      end

      # def paginated_uri(uri, max_results=0)
      #   uri + "index#{max_results.to_i * 100}.html"
      # end

      # Returns a Craigslist uri given a city subdomain, category path, and
      # optional search query
      # def build_uri(city_path, category_path, search_query=nil)
      #   if search
      #     query_string = build_query(
      #       query: search.fetch(:search_query),
      #       srchType: SEARCH_TYPE[search.fetch(:type, :only_title)],
      #     )

      #     "#{build_city_uri(city_path)}/search/#{category_path}?%s" % query_string
      #   else
      #     "#{build_city_uri(city_path)}/#{category_path}/"
      #   end
      # end
    end
  end
end
