require 'craigslist'

describe 'Craigslist' do
  describe 'Module' do
    context '#categories' do
      it 'should return an Array of categories' do
        categories = Craigslist.categories
        categories.should be_a Array
        categories.length.should be > 100
      end
    end

    context '#valid_city?' do
      let(:existing_cities) { %w[seattle sfbay] }
      let(:nonexisting_cities) { %w[asdfasdf qwerty] }

      it 'should return true for cities that exist' do
        existing_cities.each do |city|
          Craigslist.valid_city?(city).should be true
        end
      end

      it 'should return false for cities that do not exist' do
        nonexisting_cities.each do |city|
          Craigslist.valid_city?(city).should be false
        end
      end
    end

    context '#valid_category_name?' do
      let(:existing_categories) { %w[for_sale bikes] }
      let(:nonexisting_categories) { %w[asdfasdf qwerty] }

      it 'should return true for categories that exist' do
        existing_categories.each do |cat|
          Craigslist.valid_category_name?(cat).should be true
        end
      end

      it 'should return false for categories that do not exist' do
        nonexisting_categories.each do |cat|
          Craigslist.valid_category_name?(cat).should be false
        end
      end
    end

    context '#valid_category_path?' do
      let(:existing_categories) { %w[sss bia] }
      let(:nonexisting_categories) { %w[asdfasdf qwerty] }

      it 'should return true for categories that exist' do
        existing_categories.each do |cat|
          Craigslist.valid_category_path?(cat).should be true
        end
      end

      it 'should return false for categories that do not exist' do
        nonexisting_categories.each do |cat|
          Craigslist.valid_category_path?(cat).should be false
        end
      end
    end

    context '#category_path_by_name' do
      let(:category_pairs) { { for_sale: 'sss', bikes: 'bia' } }

      it 'should return the correct path for each name' do
        category_pairs.each do |key, value|
          Craigslist.category_path_by_name(key).should == value
        end
      end
    end

    describe 'an initial call to city' do
      context 'using writer methods' do
        it 'should return a new instance with the expected value set' do
          c = Craigslist.city(:seattle)
          c.should be_instance_of Craigslist::Persistable
          c.city.should == :seattle
        end
      end

      context 'using dynamic finder methods' do
        it 'should return a new instance with the expected value set' do
          c = Craigslist.seattle
          c.should be_instance_of Craigslist::Persistable
          c.city.should == :seattle
        end
      end
    end

    describe 'an initial call to category' do
      context 'using writer methods' do
        it 'should return a new instance with the expected value set' do
          c = Craigslist.category(:bikes)
          c.should be_instance_of Craigslist::Persistable
          c.category_path.should == 'bia'
        end
      end

      context 'using dynamic finder methods' do
        it 'should return a new instance with the expected value set' do
          c = Craigslist.bikes
          c.should be_instance_of Craigslist::Persistable
          c.category_path.should == 'bia'
        end
      end
    end

    describe 'an initial call to limit' do
      it 'should return a new instance with the expected value set' do
        c = Craigslist.limit(200)
        c.should be_instance_of Craigslist::Persistable
        c.limit.should == 200
      end
    end

    describe 'an initial call to query' do
      it 'should return a new instance with the expected value set' do
        c = Craigslist.query('test')
        c.should be_instance_of Craigslist::Persistable
        c.query.should == 'test'
      end
    end

    describe 'an initial call to search_type' do
      it 'should return a new instance with the expected value set' do
        c = Craigslist.search_type(:T)
        c.should be_instance_of Craigslist::Persistable
        c.search_type.should == :T
      end
    end

    describe 'an initial call to has_image' do
      it 'should return a new instance with the expected value set' do
        c = Craigslist.has_image(true)
        c.should be_instance_of Craigslist::Persistable
        c.has_image.should == 1
      end
    end

    describe 'an initial call to min_ask' do
      it 'should return a new instance with the expected value set' do
        c = Craigslist.min_ask(100)
        c.should be_instance_of Craigslist::Persistable
        c.min_ask.should == 100
      end
    end

    describe 'an initial call to max_ask' do
      it 'should return a new instance with the expected value set' do
        c = Craigslist.max_ask(200)
        c.should be_instance_of Craigslist::Persistable
        c.max_ask.should == 200
      end
    end

    describe 'a correctly formatted block' do
      it 'should be evaluated and return a new instance with the expected values set' do
        c = Craigslist {
          city :seattle
          category :bikes
          limit 200
          query 'test'
          search_type :T
          has_image true
          min_ask 100
          max_ask 200
        }
        c.should be_instance_of Craigslist::Persistable
        c.city.should == :seattle
        c.category_path.should == 'bia'
        c.limit.should == 200
        c.query.should == 'test'
        c.search_type.should == :T
        c.has_image.should == 1
        c.min_ask.should == 100
        c.max_ask.should == 200
      end
    end
  end

  describe 'Persistable' do
    describe 'a chained call to city' do
      context 'using writer methods' do
        it 'should return the instance with the expected value set' do
          c = Craigslist.category(:bikes).city(:seattle)
          c.should be_instance_of Craigslist::Persistable
          c.city.should == :seattle
        end
      end

      context 'using dynamic finder methods' do
        it 'should return the instance with the expected value set' do
          c = Craigslist.category(:bikes).seattle
          c.should be_instance_of Craigslist::Persistable
          c.city.should == :seattle
        end
      end
    end

    describe 'a chained call to category' do
      context 'using writer methods' do
        it 'should return a new instance with the expected value set' do
          c = Craigslist.city(:seattle).category(:bikes)
          c.should be_instance_of Craigslist::Persistable
          c.category_path.should == 'bia'
        end
      end

      context 'using dynamic finder methods' do
        it 'should return a new instance with the expected value set' do
          c = Craigslist.city(:seattle).bikes
          c.should be_a Craigslist::Persistable
          c.category_path.should == 'bia'
        end
      end
    end

    describe 'a chained call to limit' do
      it 'should return a new instance with the expected value set' do
        c = Craigslist.city(:seattle).limit(200)
        c.should be_instance_of Craigslist::Persistable
        c.limit.should == 200
      end
    end

    describe 'a chained call to query' do
      it 'should return a new instance with the expected value set' do
        c = Craigslist.city(:seattle).query('test')
        c.should be_instance_of Craigslist::Persistable
        c.query.should == 'test'
      end
    end

    describe 'a chained call to search_type' do
      it 'should return a new instance with the expected value set' do
        c = Craigslist.city(:seattle).search_type(:T)
        c.should be_instance_of Craigslist::Persistable
        c.search_type.should == :T
      end
    end

    describe 'a chained call to has_image' do
      it 'should return a new instance with the expected value set' do
        c = Craigslist.city(:seattle).has_image(true)
        c.should be_instance_of Craigslist::Persistable
        c.has_image.should == 1
      end
    end

    describe 'a chained call to min_ask' do
      it 'should return a new instance with the expected value set' do
        c = Craigslist.city(:seattle).min_ask(100)
        c.should be_instance_of Craigslist::Persistable
        c.min_ask.should == 100
      end
    end

    describe 'a chained call to max_ask' do
      it 'should return a new instance with the expected value set' do
        c = Craigslist.city(:seattle).max_ask(200)
        c.should be_instance_of Craigslist::Persistable
        c.max_ask.should == 200
      end
    end

    describe '#fetch' do
      describe 'a request to fetch 1 result' do
        it 'should return an Array with length of 1' do
          res = Craigslist.city(:seattle).category(:bikes).fetch(1)
          res.should be_instance_of Array
          res.length.should == 1
        end
      end

      describe 'a request to fetch 100 results' do
        it 'should return an Array with length of 100' do
          res = Craigslist.city(:seattle).category(:bikes).fetch(100)
          res.should be_instance_of Array
          res.length.should == 100
        end
      end

      describe 'a request to fetch 150 results (more than 1 page of results)' do
        it 'should return an Array with length of 150' do
          res = Craigslist.city(:seattle).category(:bikes).fetch(150)
          res.should be_instance_of Array
          res.length.should == 150
        end
      end

      describe 'a request to fetch 0 results' do
        it 'should return an Array with length of 0' do
          res = Craigslist.city(:seattle).category(:bikes).fetch(0)
          res.should be_instance_of Array
          res.length.should == 0
        end
      end

      describe 'a request with the limit set' do
        it 'should enforce the limit' do
          res = Craigslist.city(:seattle).category(:bikes).limit(1).fetch
          res.should be_instance_of Array
          res.length.should == 1
        end
      end
    end
  end
end
