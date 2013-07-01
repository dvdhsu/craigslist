# require 'cgi'

module Craigslist
  module Net
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

      def build_uri(city_path, category_path)
        "#{build_city_uri(city_path)}/#{category_path}/"
      end

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
