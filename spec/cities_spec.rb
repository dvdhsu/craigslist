require 'craigslist'

describe "Cities" do
  context "Cities hash" do
    it "should return valid uri's for every city key" do
      Craigslist::CITIES.each do |key, value|
        uri = Craigslist.build_uri(value, 'bia')
        doc = Nokogiri::HTML(open(uri))
        doc.xpath("//blockquote[@id = 'toc_rows']").length.should be > 0
      end
    end
  end
end
