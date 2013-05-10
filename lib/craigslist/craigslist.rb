module Craigslist
  class Persistent
    attr_accessor :city, :category, :search

    def initialize
      @city = nil
      @category = nil
      @search = search
    end
  end
end
