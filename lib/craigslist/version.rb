module Craigslist
  class Version
    MAJOR = 0 unless defined? Craigslist::Version::MAJOR
    MINOR = 0 unless defined? Craigslist::Version::MINOR
    PATCH = 5 unless defined? Craigslist::Version::PATCH
    PRE = nil unless defined? Craigslist::Version::PRE

    class << self
      def to_s
        [MAJOR, MINOR, PATCH, PRE].compact.join('.')
      end
    end
  end
end
