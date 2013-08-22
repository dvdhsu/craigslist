module Craigslist
  class Error < StandardError
    def to_s
      message
    end
  end

  class InsufficientQueryAttributesError < Error
    def message
      "A minimum of attributes city and category must be set before fetching " \
        "results can occur."
    end
  end
end
