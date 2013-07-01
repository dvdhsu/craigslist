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

    describe 'a correctly formatted block' do
      it 'should be evaluated and return a new instance with the expected values set' do
        c = Craigslist {
          city :seattle
          category :bikes
        }
        c.should be_instance_of Craigslist::Persistable
        c.city.should == :seattle
        c.category_path.should == 'bia'
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
  end
end
