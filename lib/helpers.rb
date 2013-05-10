require 'cgi'

module Helpers
  # Borrowed from the Rack gem
  def self.build_query(params)
    params.map { |k, v|
      if v.class == Array
        build_query(v.map { |x| [k, x] })
      else
        v.nil? ? escape(k) : "#{escape(k)}=#{escape(v)}"
      end
    }.join("&")
  end

  # Borrowed from the Rack gem
  def self.escape(s)
    URI.encode_www_form_component(s)
  end
end
